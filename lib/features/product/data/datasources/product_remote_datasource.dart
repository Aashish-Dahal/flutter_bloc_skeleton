import '../../../../shared/models/pagination_params.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseM> getAllProducts(PaginationParams paginationParams);
  Future<ProductM> getProductById(String id);
}
