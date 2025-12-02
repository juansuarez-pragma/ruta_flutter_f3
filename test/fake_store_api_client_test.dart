import 'package:flutter_test/flutter_test.dart';

import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() {
  group('Product', () {
    test('debe crear una instancia con los valores correctos', () {
      const product = Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'Test description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: ProductRating(rate: 4.5, count: 100),
      );

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 29.99);
      expect(product.description, 'Test description');
      expect(product.category, 'electronics');
      expect(product.image, 'https://example.com/image.jpg');
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
    });

    test('debe ser igual a otro producto con los mismos valores', () {
      const product1 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img',
        rating: ProductRating(rate: 4.0, count: 50),
      );

      const product2 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img',
        rating: ProductRating(rate: 4.0, count: 50),
      );

      expect(product1, equals(product2));
    });
  });

  group('FakeStoreFailure', () {
    test('ConnectionFailure debe tener mensaje por defecto', () {
      const failure = ConnectionFailure();
      expect(failure.message, isNotEmpty);
    });

    test('ServerFailure debe tener mensaje por defecto', () {
      const failure = ServerFailure();
      expect(failure.message, isNotEmpty);
    });

    test('NotFoundFailure debe tener mensaje por defecto', () {
      const failure = NotFoundFailure();
      expect(failure.message, isNotEmpty);
    });

    test('InvalidRequestFailure debe tener mensaje por defecto', () {
      const failure = InvalidRequestFailure();
      expect(failure.message, isNotEmpty);
    });

    test('debe aceptar mensaje personalizado', () {
      const customMessage = 'Error personalizado';
      const failure = ServerFailure(customMessage);
      expect(failure.message, customMessage);
    });
  });

}
