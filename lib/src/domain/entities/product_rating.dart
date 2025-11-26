import 'package:equatable/equatable.dart';

/// Representa la calificación de un producto.
///
/// Contiene la puntuación promedio y el número total de calificaciones.
///
/// Esta clase es inmutable y proporciona comparación por valor
/// mediante [Equatable].
///
/// ## Ejemplo
///
/// ```dart
/// const rating = ProductRating(
///   rate: 4.5,
///   count: 120,
/// );
///
/// print('Puntuación: ${rating.rate}/5 (${rating.count} reseñas)');
/// ```
class ProductRating extends Equatable {
  /// Puntuación promedio del producto (0.0 - 5.0).
  final double rate;

  /// Número total de calificaciones recibidas.
  final int count;

  /// Crea una nueva instancia de [ProductRating].
  ///
  /// [rate] es la puntuación promedio del producto.
  /// [count] es el número total de calificaciones.
  const ProductRating({
    required this.rate,
    required this.count,
  });

  @override
  List<Object> get props => [rate, count];

  @override
  String toString() => 'ProductRating(rate: $rate, count: $count)';
}
