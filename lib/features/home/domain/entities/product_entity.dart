import '../../data/models/product_model.dart';

class ProductResponseEntity {
  final List<ProductEntity> products;
  final int total;

  ProductResponseEntity({required this.products, required this.total});
}

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
