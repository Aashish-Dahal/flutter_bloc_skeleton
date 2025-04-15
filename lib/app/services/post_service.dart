import 'package:fpdart/fpdart.dart';

import '../config/api/api_endpoints.dart';
import '../config/api/api_error.dart';
import '../config/api/api_response.dart';
import '../config/api/dio_service.dart';
import '../core/utils/enum/index.dart';
import '../core/utils/typedf/index.dart';
import '../injector.dart';
import '../models/params/pagination_params/index.dart';
import '../models/post/index.dart';

abstract class PostApiService {
  Future<Either<Failure, ApiResponse<PostM>>> getPost(
    PaginationParams paginationParams,
  );
}

class PostApiServiceImpl extends PostApiService {
  @override
  Future<Either<Failure, ApiResponse<PostM>>> getPost(
    PaginationParams paginationParams,
  ) async {
    return await sl<DioService>().makeRequest<PostM, JsonMap>(
      type: RequestType.get,
      endpoint: ApiEndpoints.login,
      fromJson: PostM.fromJson,
    );
  }
}
