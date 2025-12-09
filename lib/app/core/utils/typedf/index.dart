import 'package:fpdart/fpdart.dart' show Either;

import '../../../shared/models/pagination_params.dart' show PaginationParams;
import '../../config/api/api_error.dart' show Failure;
import '../../config/api/api_response.dart' show ApiResponse;

typedef JsonMap = Map<String, dynamic>;
typedef FutureCall<T> =
    Future<Either<Failure, ApiResponse<T>>> Function(
      PaginationParams paginationParams,
    );
