import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ScrollController;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, Emitter;

import '../../core/utils/enum/index.dart';
import '../../core/utils/typedf/index.dart';
import '../models/pagination_params.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final FutureCall call;
  final PaginationType type;
  final ScrollController _scrollController;
  final params = PaginationParams(pageSize: 20);
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  PaginationBloc(
    this.call, {
    this.type = PaginationType.page,
    required ScrollController scrollController,
  }) : _scrollController = scrollController,
       super(const PaginationInitial()) {
    scrollController.addListener(_handleScroll);
    on<PageBasePagination>(_pageBasePagination);
    on<CursorBasePagination>(_cursorBasePagination);
    on<PageBasedLoadMore>(_onPageBasedLoadMore);
    on<CursorBasedLoadMore>(_onCursorBasedLoadMore);
    on<PaginationRefresh>(_onRefresh);
  }
  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !hasReachedMax) {
      add(
        type == PaginationType.cursor
            ? CursorBasedLoadMore()
            : PageBasedLoadMore(),
      );
    }
  }

  Future<void> _pageBasePagination(
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

  Future<void> _cursorBasePagination(
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

  Future<void> _onPageBasedLoadMore(
    PageBasedLoadMore event,
    Emitter<PaginationState> emit,
  ) async {
    isLoadingMore = true;
    hasReachedMax = false;
    params.page++;

    final res = await call(params);
    res.match((l) => emit(PaginationError(error: l.message)), (r) {
      emit(PaginationSuccess(data: [...state.data, ...r.data]));
      if (state.data.length == r.count) {
        isLoadingMore = false;
        hasReachedMax = true;
      }
    });
  }

  Future<void> _onCursorBasedLoadMore(
    CursorBasedLoadMore event,
    Emitter<PaginationState> emit,
  ) async {
    isLoadingMore = true;
    hasReachedMax = false;
    params.skip = state.data.length;
    final res = await call(params);
    res.fold((l) => emit(PaginationError(error: l.message)), (r) {
      emit(PaginationSuccess(data: [...state.data, ...r.data]));
      if (state.data.length == r.count) {
        isLoadingMore = false;
        hasReachedMax = true;
      }
    });
  }

  Future<void> _onRefresh(
    PaginationRefresh event,
    Emitter<PaginationState> emit,
  ) async {
    emit(const PaginationLoading());
    final res = await call(params..page = 1);
    res.match(
      (l) => emit(PaginationError(error: l.message)),
      (r) => emit(PaginationSuccess(data: r.data)),
    );
  }

  @override
  Future<void> close() {
    _scrollController.removeListener(_handleScroll);
    return super.close();
  }
}
