import 'package:fake_store_api_client/src/domain/entities/product_rating.dart';

/// Representa un producto de la tienda.
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final ProductRating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.description == description &&
        other.category == category &&
        other.image == image &&
        other.rating == rating;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, price, description, category, image, rating);

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}
