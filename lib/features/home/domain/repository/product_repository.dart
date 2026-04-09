import '../../../../core/network/api_result.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ApiResult<ProductResponseEntity>> getProducts(
    PaginationParams paginationParams,
  );
}

class ProductResponseEntity {
  final List<ProductEntity> products;
  final int total;

  ProductResponseEntity({required this.products, required this.total});
}
