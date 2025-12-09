import '../../data/models/product_model.dart';

class ProductEntity {
  final int id;
  final String title;
  final String description;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  static List<ProductEntity> parseList(List<ProductM> data) =>
      List<ProductEntity>.from(data.map((res) => res.toEntity()));
}
