import 'package:fake_store_api_client/src/domain/entities/entities.dart';

/// Modelo de datos para deserialización JSON de [ProductRating].
class ProductRatingModel extends ProductRating {
  const ProductRatingModel({required super.rate, required super.count});

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  ProductRating toEntity() {
    return ProductRating(rate: rate, count: count);
  }
}
