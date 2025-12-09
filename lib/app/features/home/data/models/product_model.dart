import '../../../../core/utils/typedf/index.dart';
import '../../domain/entities/product_entity.dart';

class ProductResponseM {
  final List<ProductM> data;
  final int count;

  ProductResponseM({required this.data, required this.count});

  factory ProductResponseM.fromJson(JsonMap json) {
    return ProductResponseM(
      data: ProductM.parseList(json['products']),
      count: json['total'],
    );
  }
}

class ProductM {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final DimensionsM dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewM> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;

  ProductM({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
  });

  factory ProductM.fromJson(JsonMap json) {
    return ProductM(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'],
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'],
      sku: json['sku'],
      weight: json['weight'],
      dimensions: DimensionsM.fromJson(json['dimensions']),
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews:
          (json['reviews'] as List<JsonMap>)
              .map((e) => ReviewM.fromJson(e))
              .toList(),
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(id: id, title: title, description: description);
  }

  static List<ProductM> parseList(Iterable data) =>
      List<ProductM>.from(data.map((res) => ProductM.fromJson(res)));
}

class DimensionsM {
  final double width;
  final double height;
  final double depth;

  DimensionsM({required this.width, required this.height, required this.depth});

  factory DimensionsM.fromJson(JsonMap json) {
    return DimensionsM(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }
}

class ReviewM {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  ReviewM({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ReviewM.fromJson(JsonMap json) {
    return ReviewM(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }
}
