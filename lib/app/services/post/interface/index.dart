import 'package:fpdart/fpdart.dart';

import '../../../core/error/failure.dart';
import '../../../models/params/pagination_params/index.dart';
import '../../../models/post/index.dart';

abstract class PostInterface {
  Future<Either<Failure, PostM>> getPost(
    PaginationParams paginationParams,
  );
}
