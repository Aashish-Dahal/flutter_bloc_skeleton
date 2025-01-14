import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ScrollController;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, Emitter;

import '../../../models/params/pagination_params/index.dart'
    show PaginationParams;
import '../../utils/enum/index.dart';
import '../../utils/typedf/index.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final FutureCall call;
  final PaginationType type;
  final scrollController = ScrollController();
  final params = PaginationParams(pageSize: 20);
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  PaginationBloc(this.call, {this.type = PaginationType.page})
      : super(const PaginationInitial()) {
    scrollController.addListener(_handleScroll);
    on<PageBasePagination>(_pageBasePagination);
    on<CursorBasePagination>(_cursorBasePagination);
    on<PageBasedLoadMore>(_onPageBasedLoadMore);
    on<CursorBasedLoadMore>(_onCursorBasedLoadMore);
    on<PaginationRefresh>(_onRefresh);
  }
  void _handleScroll() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !hasReachedMax) {
      add(
        type == PaginationType.cursor
            ? CursorBasedLoadMore()
            : const PageBasePagination(),
      );
    }
  }

  _pageBasePagination(
    PageBasePagination event,
    Emitter<PaginationState> emit,
  ) async {
    emit(const PaginationLoading());
    final res = await call(params);
    res.match(
      (l) => emit(PaginationError(error: l.message)),
      (r) => emit(PaginationSuccess(data: r.data)),
    );
  }

  _cursorBasePagination(
    CursorBasePagination event,
    Emitter<PaginationState> emit,
  ) async {
    emit(const PaginationLoading());
    final res = await call(params);
    res.match(
      (l) => emit(PaginationError(error: l.message)),
      (r) => emit(PaginationSuccess(data: r.data)),
    );
  }

  _onPageBasedLoadMore(
    PageBasedLoadMore event,
    Emitter<PaginationState> emit,
  ) async {
    isLoadingMore = true;
    hasReachedMax = false;
    params.page++;

    final res = await call(params);
    res.match(
      (l) => emit(PaginationError(error: l.message)),
      (r) {
        emit(PaginationSuccess(data: [...state.data, ...r.data]));
        if (state.data.length == r.count) {
          isLoadingMore = false;
          hasReachedMax = true;
        }
      },
    );
  }

  _onCursorBasedLoadMore(
    CursorBasedLoadMore event,
    Emitter<PaginationState> emit,
  ) async {
    isLoadingMore = true;
    hasReachedMax = false;
    params.skip = state.data.length;
    final res = await call(params);
    res.fold(
      (l) => emit(PaginationError(error: l.message)),
      (r) {
        emit(PaginationSuccess(data: [...state.data, ...r.data]));
        if (state.data.length == r.count) {
          isLoadingMore = false;
          hasReachedMax = true;
        }
      },
    );
  }

  _onRefresh(PaginationRefresh event, Emitter<PaginationState> emit) async {
    emit(const PaginationLoading());
    final res = await call(params..page = 1);
    res.match(
      (l) => emit(PaginationError(error: l.message)),
      (r) => emit(PaginationSuccess(data: r.data)),
    );
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
