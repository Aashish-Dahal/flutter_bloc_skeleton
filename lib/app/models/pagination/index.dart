import '../../core/utils/typedf/index.dart';

abstract class PaginationModel<T> {
  int count;
  T data;
  PaginationModel({
    required this.count,
    required this.data,
  });

  JsonMap toJson();
}
