import '../../../../core/network/api_result.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProductRepository {
  Future<ApiResult<UserEntity>> getProfile();
}
