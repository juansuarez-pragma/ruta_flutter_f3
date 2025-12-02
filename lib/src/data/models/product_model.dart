import 'package:fake_store_api_client/src/data/models/product_rating_model.dart';
import 'package:fake_store_api_client/src/domain/entities/entities.dart';

/// Modelo de datos para un producto.
///
/// Extiende [Product] y añade métodos de serialización JSON.
/// Se usa en la capa de datos para transformar respuestas de la API.
class ProductModel extends Product {
  /// Crea una nueva instancia de [ProductModel].
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  /// Crea un [ProductModel] desde un mapa JSON.
  ///
  /// [json] debe contener todas las claves requeridas del producto.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final json = {
  ///   'id': 1,
  ///   'title': 'Camiseta',
  ///   'price': 29.99,
  ///   'description': 'Una camiseta cómoda',
  ///   'category': 'ropa',
  ///   'image': 'https://example.com/image.jpg',
  ///   'rating': {'rate': 4.5, 'count': 120},
  /// };
  /// final product = ProductModel.fromJson(json);
  /// ```
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

  /// Convierte este modelo a una entidad de dominio.
  ///
  /// Útil para el mapeo en la capa de repositorio.
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
