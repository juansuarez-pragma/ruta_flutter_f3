import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_api_client/src/data/models/models.dart';

import '../../../fixtures/product_fixtures.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('ProductModel', () {
    group('fromJson', () {
      test('crea modelo desde JSON válido', () {
        // Act
        final model = ProductModel.fromJson(validProductJson);

        // Assert
        expect(model.id, 1);
        expect(model.title, 'Producto de prueba');
        expect(model.price, 99.99);
        expect(model.description, 'Descripción del producto de prueba');
        expect(model.category, 'electronics');
        expect(model.image, 'https://example.com/image.jpg');
        expect(model.rating.rate, 4.5);
        expect(model.rating.count, 120);
      });

      test('convierte precio numérico entero a double', () {
        // Act
        final model = ProductModel.fromJson(productJsonWithIntPrice);

        // Assert
        expect(model.price, isA<double>());
        expect(model.price, 100.0);
      });

      test('lanza excepción cuando falta campo requerido', () {
        // Assert
        expect(
          () => ProductModel.fromJson(incompleteProductJson),
          throwsA(isA<TypeError>()),
        );
      });

      test('lanza excepción cuando el tipo es incorrecto', () {
        // Assert
        expect(
          () => ProductModel.fromJson(wrongTypeProductJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toEntity', () {
      test('convierte modelo a Product correctamente', () {
        // Arrange
        final model = createTestProductModel(
          id: 1,
          title: 'Test Product',
          price: 25.50,
          description: 'Test Description',
          category: 'test-category',
          image: 'https://test.com/image.png',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<Product>());
        expect(entity.id, model.id);
        expect(entity.title, model.title);
        expect(entity.price, model.price);
        expect(entity.description, model.description);
        expect(entity.category, model.category);
        expect(entity.image, model.image);
        expect(entity.rating.rate, model.rating.rate);
        expect(entity.rating.count, model.rating.count);
      });
    });

    group('constructor', () {
      test('crea instancia con valores correctos', () {
        // Act
        final model = createTestProductModel(
          id: 1,
          title: 'Test',
          price: 10.0,
          description: 'Desc',
          category: 'Cat',
          image: 'img.jpg',
        );

        // Assert
        expect(model.id, 1);
        expect(model.title, 'Test');
      });

      test('hereda de Product', () {
        // Arrange
        final model = createTestProductModel();

        // Assert
        expect(model, isA<Product>());
      });
    });
  });
}
