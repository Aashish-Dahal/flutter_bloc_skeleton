import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api/index.dart';
import '../../../../core/utils/enum/index.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../models/product_model.dart';

abstract class ProductApiService {
  Future<Either<Failure, ApiResponse<ProductResponseM>>> getPost(
    PaginationParams paginationParams,
  );
}

class ProductApiServiceImpl extends ProductApiService {
  final DioService _dioService;

  ProductApiServiceImpl(DioService dioService) : _dioService = dioService;
  @override
  Future<Either<Failure, ApiResponse<ProductResponseM>>> getPost(
    PaginationParams paginationParams,
  ) async {
    return _dioService.makeRequest<ProductResponseM, JsonMap>(
      type: RequestType.get,
      endpoint: ApiEndpoints.login,
      fromJson: ProductResponseM.fromJson,
    );
  }
}
