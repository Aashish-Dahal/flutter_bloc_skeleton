import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/product_entity.dart';

class ProductResponseM {
  final List<ProductM> data;
  final int count;

  ProductResponseM({required this.data, required this.count});

  factory ProductResponseM.fromJson(JsonMap json) {
    return ProductResponseM(
      data: ProductM.parseList(json['posts']),
      count: json['total'],
    );
  }
}

class ProductM {
  final int id;
  final String title;
  final String body;

  ProductM({required this.id, required this.title, required this.body});

  factory ProductM.fromJson(JsonMap json) {
    return ProductM(id: json['id'], title: json['title'], body: json['body']);
  }

  ProductEntity toEntity() {
    return ProductEntity(id: id, title: title, description: body);
  }

  static List<ProductM> parseList(Iterable data) =>
      List<ProductM>.from(data.map((res) => ProductM.fromJson(res)));
}
