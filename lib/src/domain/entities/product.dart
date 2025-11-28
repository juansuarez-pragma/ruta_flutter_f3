import 'product_rating.dart';

/// Representa un producto de la tienda.
///
/// Esta clase es inmutable y proporciona comparación por valor.
///
/// ## Ejemplo
///
/// ```dart
/// final product = Product(
///   id: 1,
///   title: 'Camiseta Premium',
///   price: 29.99,
///   description: 'Una camiseta de alta calidad',
///   category: 'ropa',
///   image: 'https://example.com/image.jpg',
///   rating: ProductRating(rate: 4.5, count: 120),
/// );
///
/// print('${product.title} - \$${product.price}');
/// ```
class Product {
  /// Identificador único del producto.
  final int id;

  /// Nombre o título del producto.
  final String title;

  /// Precio del producto en dólares.
  final double price;

  /// Descripción detallada del producto.
  final String description;

  /// Categoría a la que pertenece el producto.
  final String category;

  /// URL de la imagen del producto.
  final String image;

  /// Calificación del producto.
  final ProductRating rating;

  /// Crea una nueva instancia de [Product].
  ///
  /// Todos los parámetros son requeridos para garantizar
  /// la integridad de los datos del producto.
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
