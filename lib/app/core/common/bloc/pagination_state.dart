part of 'pagination_bloc.dart';

class PaginationState extends Equatable {
  final List data;
  const PaginationState([this.data = const []]);

  @override
  List<Object?> get props => [];
}

class PaginationInitial extends PaginationState {
  const PaginationInitial();
}

class PaginationLoading extends PaginationState {
  const PaginationLoading();
}

class PaginationSuccess extends PaginationState {
  const PaginationSuccess({required data}) : super(data);
  @override
  List<Object?> get props => [data];
}

class PaginationError extends PaginationState {
  final String? error;

  const PaginationError({this.error});
  @override
  List<Object?> get props => [error];
}
