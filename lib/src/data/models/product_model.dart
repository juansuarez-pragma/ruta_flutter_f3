import 'package:fake_store_api_client/src/data/models/product_rating_model.dart';
import 'package:fake_store_api_client/src/domain/entities/entities.dart';

/// Modelo de datos para deserialización JSON de [Product].
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: ProductRatingModel.fromJson(
        json['rating'] as Map<String, dynamic>,
      ),
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: ProductRating(rate: rating.rate, count: rating.count),
    );
  }
}
