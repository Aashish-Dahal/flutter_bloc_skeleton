import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/network/api_result.dart';
import '../../core/utils/enum/index.dart';
import '../models/pagination_params.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';
part 'base_pagination_bloc.freezed.dart';

abstract class BasePaginationBloc<T>
    extends Bloc<PaginationEvent, PaginationState<T>> {
  final PaginationParams params;

  BasePaginationBloc({PaginationParams? initialParams})
    : params = initialParams ?? PaginationParams(pageSize: 20),
      super(PaginationState<T>()) {
    on<PaginationFetch>(_onPaginationFetch);
    on<PaginationRefresh>(_onPaginationRefresh);
  }

  /// Subclasses must implement this to provide data fetching logic.
  /// Returns an ApiResult containing a list of items and whether there is more data.
  Future<ApiResult<PaginatedData<T>>> fetchItems(PaginationParams params);

  Future<void> _onPaginationFetch(
    PaginationFetch event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PaginationStatus.initial) {
        emit(state.copyWith(status: PaginationStatus.loading));
      }

      final result = await fetchItems(params);

      result.when(
        success: (paginatedData) {
          final newData = List<T>.of(state.data)..addAll(paginatedData.items);

          emit(
            state.copyWith(
              status: PaginationStatus.success,
              data: newData,
              hasReachedMax: paginatedData.isEnd,
            ),
          );

          // Increment for next page
          params.page++;
          if (params.skip != null) {
            params.skip = newData.length;
          }
        },
        failure: (failure) {
          emit(
            state.copyWith(
              status: PaginationStatus.failure,
              error: failure.message,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: PaginationStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _onPaginationRefresh(
    PaginationRefresh event,
    Emitter<PaginationState<T>> emit,
  ) async {
    params.page = 1;
    if (params.skip != null) params.skip = 0;

    emit(
      state.copyWith(
        status: PaginationStatus.initial,
        data: <T>[],
        hasReachedMax: false,
      ),
    );

    add(const PaginationFetch());
  }
}

class PaginatedData<T> {
  final List<T> items;
  final bool isEnd;

  PaginatedData({required this.items, required this.isEnd});
}
