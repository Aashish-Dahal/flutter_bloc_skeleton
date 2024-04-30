import 'package:fpdart/fpdart.dart';

import '../../../models/params/pagination_params/index.dart';
import '../../error/failure.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FutureCall<T> = Future<Either<Failure, List<T>>> Function(
  PaginationParams paginationParams,
);
