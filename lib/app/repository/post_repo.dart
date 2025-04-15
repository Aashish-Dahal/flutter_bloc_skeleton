import 'package:fpdart/fpdart.dart';

import '../config/api/api_error.dart';
import '../config/api/api_response.dart';
import '../injector.dart';
import '../models/params/pagination_params/index.dart';
import '../models/post/index.dart';
import '../services/post_service.dart';

abstract class PostRepository {
  Future<Either<Failure, ApiResponse<PostM>>> getPost(
    PaginationParams paginationParams,
  );
}

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Either<Failure, ApiResponse<PostM>>> getPost(
    PaginationParams paginationParams,
  ) {
    return sl<PostApiService>().getPost(paginationParams);
  }
}
