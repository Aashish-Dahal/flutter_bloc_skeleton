import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/pagination_params.dart';
import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(DioClient dioClient) : _dioClient = dioClient;

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
