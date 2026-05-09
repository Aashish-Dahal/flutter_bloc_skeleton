import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../shared/state/base_state.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/product_usecase.dart';

part 'get_product_by_id_event.dart';
part 'get_product_by_id_state.dart';
part 'get_product_by_id_bloc.freezed.dart';

class GetProductByIdBloc
    extends Bloc<GetProductByIdEvent, GetProductByIdState> {
  final ProductUsecase _productUsecase;

  GetProductByIdBloc({required ProductUsecase productUsecase})
    : _productUsecase = productUsecase,
      super(GetProductByIdState.initial()) {
    on<GetProductByIdRequested>(_onGetProductByIdRequested);
  }
  Future<void> _onGetProductByIdRequested(
    GetProductByIdRequested event,
    Emitter<GetProductByIdState> emit,
  ) async {
    emit(const GetProductByIdState.loading());

    final result = await _productUsecase.callGetProductById(event.id);

    result.when(
      success: (res) => emit(GetProductByIdState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProductByIdState.failure(message: failure.message)),
    );
  }
}
