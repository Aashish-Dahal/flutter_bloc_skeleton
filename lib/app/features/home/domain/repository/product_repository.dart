import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, ApiResponse<List<ProductEntity>>>> getProducts(
    PaginationParams paginationParams,
  );
}
