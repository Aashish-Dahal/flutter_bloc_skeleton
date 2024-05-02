import 'package:fpdart/fpdart.dart';

import '../../config/api/api.dart';
import '../../core/error/failure.dart';
import '../../models/params/pagination_params/index.dart';
import '../../models/post/index.dart';
import 'interface/index.dart';

class PostService extends PostInterface {
  @override
  Future<Either<Failure, PostM>> getPost(
    PaginationParams paginationParams,
  ) async {
    try {
      final res = await dio.get(
        "/posts",
        queryParameters: paginationParams.toCursorJson(),
      );

      return right(PostM.fromJson(res.data));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
