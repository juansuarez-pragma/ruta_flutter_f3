/// Fixtures de productos para testing.
///
/// Proporciona datos de prueba consistentes para todos los tests
/// relacionados con productos.
library;

/// JSON válido de un rating.
const Map<String, dynamic> validRatingJson = {'rate': 4.5, 'count': 120};

/// JSON válido de un segundo rating.
const Map<String, dynamic> validRatingJson2 = {'rate': 3.8, 'count': 85};

/// JSON con rate como entero.
const Map<String, dynamic> ratingJsonWithIntRate = {'rate': 4, 'count': 100};

/// JSON válido de un producto.
const Map<String, dynamic> validProductJson = {
  'id': 1,
  'title': 'Producto de prueba',
  'price': 99.99,
  'description': 'Descripción del producto de prueba',
  'category': 'electronics',
  'image': 'https://example.com/image.jpg',
  'rating': validRatingJson,
};

/// JSON válido de un segundo producto para listas.
const Map<String, dynamic> validProductJson2 = {
  'id': 2,
  'title': 'Segundo producto',
  'price': 49.50,
  'description': 'Descripción del segundo producto',
  'category': 'clothing',
  'image': 'https://example.com/image2.jpg',
  'rating': validRatingJson2,
};

/// JSON con precio como entero (debe convertirse a double).
const Map<String, dynamic> productJsonWithIntPrice = {
  'id': 3,
  'title': 'Producto con precio entero',
  'price': 100,
  'description': 'Precio es un entero, no un double',
  'category': 'electronics',
  'image': 'https://example.com/image3.jpg',
  'rating': ratingJsonWithIntRate,
};

/// JSON incompleto (falta campo requerido).
const Map<String, dynamic> incompleteProductJson = {
  'id': 1,
  'title': 'Producto incompleto',
  // Falta 'price', 'description', 'category', 'image', 'rating'
};

/// JSON con tipo incorrecto para el campo id.
const Map<String, dynamic> wrongTypeProductJson = {
  'id': 'no-es-un-numero',
  'title': 'Producto con tipo incorrecto',
  'price': 99.99,
  'description': 'El id debería ser int',
  'category': 'electronics',
  'image': 'https://example.com/image.jpg',
  'rating': validRatingJson,
};

/// Lista de JSONs de productos válidos.
const List<Map<String, dynamic>> validProductListJson = [
  validProductJson,
  validProductJson2,
];

/// Lista de categorías de prueba.
const List<String> validCategoriesList = [
  'electronics',
  'jewelery',
  "men's clothing",
  "women's clothing",
];
