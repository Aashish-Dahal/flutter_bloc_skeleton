import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/extension/common_extension.dart'
    show ApiIdExtension;
import '../../../../core/utils/typedf/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(DioClient dioClient) : _dioClient = dioClient;

  @override
  Future<ProductResponseM> getAllProducts(
    PaginationParams paginationParams,
  ) async {
    // Calculate skip (offset) based on page if skip is not explicitly set
    final int skip =
        paginationParams.skip ??
        (paginationParams.page - 1) * paginationParams.pageSize;

    final response = await _dioClient.get(
      ApiEndpoints.getProducts,
      queryParameters: {'limit': paginationParams.pageSize, 'skip': skip},
    );

    return ProductResponseM.fromJson(response.data);
  }

  @override
  Future<ProductM> getProductById(String id) async {
    final response = await _dioClient.get(ApiEndpoints.getProducts.addId(id));
    return ProductM.fromJson(response.data);
  }

  @override
  Future<ProductM> addProduct(JsonMap product) async {
    final response = await _dioClient.post(
      ApiEndpoints.addProduct,
      data: product,
    );
    return ProductM.fromJson(response.data);
  }

  @override
  Future<ProductM> updateProduct(JsonMap product, {required String id}) async {
    final response = await _dioClient.put(
      ApiEndpoints.getProducts.addId(id),
      data: product,
    );
    return ProductM.fromJson(response.data);
  }
}
