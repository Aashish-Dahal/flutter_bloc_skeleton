import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class ProductUsecase {
  final ProductRepository productRepository;

  ProductUsecase(this.productRepository);
  Future<Either<Failure, ApiResponse<List<ProductEntity>>>> call(
    PaginationParams params,
  ) async {
    return productRepository.getProducts(params);
  }
}
