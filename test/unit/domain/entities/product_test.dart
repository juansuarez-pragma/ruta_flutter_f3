import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Product', () {
    test('crea instancia con datos válidos', () {
      // Arrange & Act
      final product = createTestProduct();

      // Assert
      expect(product.id, 1);
      expect(product.title, 'Producto de prueba');
      expect(product.price, 99.99);
      expect(product.description, 'Descripción del producto de prueba');
      expect(product.category, 'electronics');
      expect(product.image, 'https://example.com/image.jpg');
      expect(product.rating, isA<ProductRating>());
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 120);
    });

    test('dos entidades con mismas propiedades son iguales', () {
      // Arrange
      final product1 = createTestProduct(id: 1, title: 'Test');
      final product2 = createTestProduct(id: 1, title: 'Test');

      // Act & Assert
      expect(product1, equals(product2));
      expect(product1.hashCode, equals(product2.hashCode));
    });

    test('dos entidades con diferentes propiedades no son iguales', () {
      // Arrange
      final product1 = createTestProduct(id: 1);
      final product2 = createTestProduct(id: 2);

      // Act & Assert
      expect(product1, isNot(equals(product2)));
    });

    test('entidad es inmutable al usar const constructor', () {
      // Arrange & Act
      const rating = ProductRating(rate: 4.5, count: 100);
      const product1 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'Cat',
        image: 'img.jpg',
        rating: rating,
      );

      const product2 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'Cat',
        image: 'img.jpg',
        rating: rating,
      );

      // Assert - const instances are identical
      expect(identical(product1, product2), isTrue);
    });

    test('toString incluye id, title y price', () {
      // Arrange
      final product = createTestProduct(
        id: 1,
        title: 'Test Product',
        price: 25.50,
      );

      // Act
      final result = product.toString();

      // Assert
      expect(result, contains('1'));
      expect(result, contains('Test Product'));
      expect(result, contains('25.5'));
      expect(result, contains('Product'));
    });

    test('diferentes ratings hacen productos diferentes', () {
      // Arrange
      final rating1 = createTestProductRating(rate: 4.5, count: 100);
      final rating2 = createTestProductRating(rate: 3.0, count: 50);

      final product1 = createTestProduct(id: 1, rating: rating1);
      final product2 = createTestProduct(id: 1, rating: rating2);

      // Act & Assert
      expect(product1, isNot(equals(product2)));
    });

    test('productos iguales tienen mismo hashCode', () {
      // Arrange
      final product1 = createTestProduct(
        id: 1,
        title: 'Same',
        price: 10.0,
        description: 'Same desc',
        category: 'same-cat',
        image: 'same.jpg',
      );
      final product2 = createTestProduct(
        id: 1,
        title: 'Same',
        price: 10.0,
        description: 'Same desc',
        category: 'same-cat',
        image: 'same.jpg',
      );

      // Act & Assert
      expect(product1.hashCode, equals(product2.hashCode));
    });
  });
}
