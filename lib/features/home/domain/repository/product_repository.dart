import '../../../../core/network/api_result.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ApiResult<ProductResponseEntity>> getProducts(
    PaginationParams paginationParams,
  );
}
