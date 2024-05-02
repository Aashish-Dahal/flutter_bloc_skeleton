import 'package:fpdart/fpdart.dart';

import '../../../models/pagination/index.dart';
import '../../../models/params/pagination_params/index.dart';
import '../../error/failure.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FutureCall = Future<Either<Failure, PaginationModel>> Function(
  PaginationParams paginationParams,
);
