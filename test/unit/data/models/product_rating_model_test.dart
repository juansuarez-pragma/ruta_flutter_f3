import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_api_client/src/data/models/models.dart';

import '../../../fixtures/product_fixtures.dart';

void main() {
  group('ProductRatingModel', () {
    group('fromJson', () {
      test('crea modelo desde JSON válido', () {
        // Act
        final model = ProductRatingModel.fromJson(validRatingJson);

        // Assert
        expect(model.rate, 4.5);
        expect(model.count, 120);
      });

      test('convierte rate numérico entero a double', () {
        // Act
        final model = ProductRatingModel.fromJson(ratingJsonWithIntRate);

        // Assert
        expect(model.rate, isA<double>());
        expect(model.rate, 4.0);
      });

      test('lanza excepción cuando falta campo requerido', () {
        // Arrange
        const incompleteJson = <String, dynamic>{'rate': 4.5};

        // Assert
        expect(
          () => ProductRatingModel.fromJson(incompleteJson),
          throwsA(isA<TypeError>()),
        );
      });

      test('lanza excepción cuando el tipo es incorrecto', () {
        // Arrange
        const wrongTypeJson = <String, dynamic>{
          'rate': 'no-es-un-numero',
          'count': 100,
        };

        // Assert
        expect(
          () => ProductRatingModel.fromJson(wrongTypeJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('convierte modelo a JSON correctamente', () {
        // Arrange
        const model = ProductRatingModel(rate: 4.5, count: 120);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['rate'], 4.5);
        expect(json['count'], 120);
      });
    });

    group('toEntity', () {
      test('convierte modelo a ProductRating correctamente', () {
        // Arrange
        const model = ProductRatingModel(rate: 4.5, count: 120);

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<ProductRating>());
        expect(entity.rate, model.rate);
        expect(entity.count, model.count);
      });
    });

    group('constructor', () {
      test('crea instancia con const constructor', () {
        // Act
        const model = ProductRatingModel(rate: 4.5, count: 100);

        // Assert
        expect(model.rate, 4.5);
        expect(model.count, 100);
      });

      test('dos modelos const con mismos valores son idénticos', () {
        // Arrange
        const model1 = ProductRatingModel(rate: 4.5, count: 100);
        const model2 = ProductRatingModel(rate: 4.5, count: 100);

        // Assert
        expect(identical(model1, model2), isTrue);
      });
    });
  });
}
