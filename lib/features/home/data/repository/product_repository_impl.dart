import '../../../../core/network/api_result.dart';
import '../../../../core/network/failures.dart';
import '../../../../shared/models/pagination_params.dart';
import '../../domain/repository/product_repository.dart';
import '../datasources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _productApiService;

  ProductRepositoryImpl(ProductApiService productApiService)
    : _productApiService = productApiService;

  @override
  Future<ApiResult<ProductResponseEntity>> getProducts(
    PaginationParams paginationParams,
  ) async {
    try {
      final responseM = await _productApiService.getPost(paginationParams);

      final products = responseM.data.map((m) => m.toEntity()).toList();

      return ApiResult.success(
        ProductResponseEntity(products: products, total: responseM.count),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
