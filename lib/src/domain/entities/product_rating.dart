/// Calificación de un producto.
class ProductRating {
  /// Puntuación promedio (0.0 - 5.0).
  final double rate;

  /// Número total de calificaciones.
  final int count;

  const ProductRating({required this.rate, required this.count});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductRating && other.rate == rate && other.count == count;
  }

  @override
  int get hashCode => Object.hash(rate, count);

  @override
  String toString() => 'ProductRating(rate: $rate, count: $count)';
}
