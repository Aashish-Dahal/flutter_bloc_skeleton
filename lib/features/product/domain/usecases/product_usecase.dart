import '../../../../core/network/api_result.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class ProductUsecase {
  final ProductRepository _repository;

  ProductUsecase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<ProductResponseEntity>> call(PaginationParams params) async {
    return await _repository.getAllProducts(params);
  }

  Future<ApiResult<ProductEntity>> callGetProductById(String id) async {
    return await _repository.getProductById(id);
  }
}
