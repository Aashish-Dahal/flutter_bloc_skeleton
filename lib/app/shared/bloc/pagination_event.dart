part of 'pagination_bloc.dart';

sealed class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object> get props => [];
}

class PageBasePagination extends PaginationEvent {
  const PageBasePagination();
  @override
  List<Object> get props => [];
}

class CursorBasePagination extends PaginationEvent {
  const CursorBasePagination();
  @override
  List<Object> get props => [];
}

class PageBasedLoadMore extends PaginationEvent {}

class CursorBasedLoadMore extends PaginationEvent {}

class PaginationRefresh extends PaginationEvent {}
