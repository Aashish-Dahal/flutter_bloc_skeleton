part of 'base_pagination_bloc.dart';

@freezed
class PaginationEvent with _$PaginationEvent {
  const factory PaginationEvent.fetch() = PaginationFetch;
  const factory PaginationEvent.refresh() = PaginationRefresh;
}
