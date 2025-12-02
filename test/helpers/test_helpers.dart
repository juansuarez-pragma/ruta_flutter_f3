/// Helpers y utilidades compartidas para testing.
///
/// Proporciona funciones de fábrica para crear entidades y modelos
/// de prueba de manera consistente.
library;

import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_api_client/src/data/models/models.dart';

/// Crea un [ProductRating] de prueba con valores por defecto.
ProductRating createTestProductRating({double rate = 4.5, int count = 120}) {
  return ProductRating(rate: rate, count: count);
}

/// Crea un [ProductRatingModel] de prueba con valores por defecto.
ProductRatingModel createTestProductRatingModel({
  double rate = 4.5,
  int count = 120,
}) {
  return ProductRatingModel(rate: rate, count: count);
}

/// Crea un [Product] de prueba con valores por defecto.
///
/// Permite sobrescribir cualquier campo para casos de prueba específicos.
Product createTestProduct({
  int id = 1,
  String title = 'Producto de prueba',
  double price = 99.99,
  String description = 'Descripción del producto de prueba',
  String category = 'electronics',
  String image = 'https://example.com/image.jpg',
  ProductRating? rating,
}) {
  return Product(
    id: id,
    title: title,
    price: price,
    description: description,
    category: category,
    image: image,
    rating: rating ?? createTestProductRating(),
  );
}

/// Crea un [ProductModel] de prueba con valores por defecto.
///
/// Permite sobrescribir cualquier campo para casos de prueba específicos.
ProductModel createTestProductModel({
  int id = 1,
  String title = 'Producto de prueba',
  double price = 99.99,
  String description = 'Descripción del producto de prueba',
  String category = 'electronics',
  String image = 'https://example.com/image.jpg',
  ProductRatingModel? rating,
}) {
  return ProductModel(
    id: id,
    title: title,
    price: price,
    description: description,
    category: category,
    image: image,
    rating: rating ?? createTestProductRatingModel(),
  );
}

/// Crea una lista de [Product] de prueba.
List<Product> createTestProductList({int count = 2}) {
  return List.generate(
    count,
    (index) => createTestProduct(
      id: index + 1,
      title: 'Producto ${index + 1}',
      price: (index + 1) * 10.0,
    ),
  );
}

/// Crea una lista de [ProductModel] de prueba.
List<ProductModel> createTestProductModelList({int count = 2}) {
  return List.generate(
    count,
    (index) => createTestProductModel(
      id: index + 1,
      title: 'Producto ${index + 1}',
      price: (index + 1) * 10.0,
    ),
  );
}

/// Lista de categorías de prueba.
List<String> createTestCategories() {
  return ['electronics', 'jewelery', "men's clothing", "women's clothing"];
}
