import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/pagination_params.dart';
import '../models/product_model.dart';

abstract class ProductApiService {
  Future<ProductResponseM> getPost(PaginationParams paginationParams);
}

class ProductApiServiceImpl extends ProductApiService {
  final DioClient _dioClient;

  ProductApiServiceImpl(DioClient dioClient) : _dioClient = dioClient;

  @override
  Future<ProductResponseM> getPost(PaginationParams paginationParams) async {
    final response = await _dioClient.get(
      ApiEndpoints.getPosts,
      queryParameters: {
        'limit': paginationParams.pageSize,
        'skip': (paginationParams.page - 1) * paginationParams.pageSize,
      },
    );

    return ProductResponseM.fromJson(response.data);
  }
}
