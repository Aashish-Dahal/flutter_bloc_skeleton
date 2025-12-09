import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/api_error.dart';
import '../../../../core/config/api/api_response.dart';
import '../../../../shared/models/pagination_params.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../datasources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _productApiService;

  ProductRepositoryImpl(ProductApiService productApiService)
    : _productApiService = productApiService;
  @override
  Future<Either<Failure, ApiResponse<List<ProductEntity>>>> getProducts(
    PaginationParams paginationParams,
  ) async {
    final result = await _productApiService.getPost(paginationParams);
    return result.map((response) {
      final productModel = response.data.data;
      final productEntity = ProductEntity.parseList(productModel);
      return ApiResponse<List<ProductEntity>>(
        data: productEntity,
        statusCode: response.statusCode,
      );
    });
  }
}
