import '../../domain/entities/entities.dart';

/// Modelo de datos para la calificación de un producto.
///
/// Extiende [ProductRating] y añade métodos de serialización JSON.
/// Se usa en la capa de datos para transformar respuestas de la API.
class ProductRatingModel extends ProductRating {
  /// Crea una nueva instancia de [ProductRatingModel].
  const ProductRatingModel({
    required super.rate,
    required super.count,
  });

  /// Crea un [ProductRatingModel] desde un mapa JSON.
  ///
  /// [json] debe contener las claves 'rate' y 'count'.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final json = {'rate': 4.5, 'count': 120};
  /// final rating = ProductRatingModel.fromJson(json);
  /// ```
  factory ProductRatingModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  /// Convierte este modelo a un mapa JSON.
  ///
  /// ## Ejemplo
  ///
  /// ```dart
  /// final rating = ProductRatingModel(rate: 4.5, count: 120);
  /// final json = rating.toJson();
  /// // {'rate': 4.5, 'count': 120}
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }

  /// Convierte este modelo a una entidad de dominio.
  ///
  /// Útil para el mapeo en la capa de repositorio.
  ProductRating toEntity() {
    return ProductRating(
      rate: rate,
      count: count,
    );
  }
}
