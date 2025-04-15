import 'package:fpdart/fpdart.dart';

import '../../../config/api/api_error.dart';
import '../../../models/params/pagination_params/index.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FutureCall<T> =
    Future<Either<Failure, T>> Function(PaginationParams paginationParams);
