import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('ProductRating', () {
    test('crea instancia con datos válidos', () {
      // Arrange & Act
      final rating = createTestProductRating();

      // Assert
      expect(rating.rate, 4.5);
      expect(rating.count, 120);
    });

    test('dos ratings con mismas propiedades son iguales', () {
      // Arrange
      final rating1 = createTestProductRating(rate: 4.5, count: 100);
      final rating2 = createTestProductRating(rate: 4.5, count: 100);

      // Act & Assert
      expect(rating1, equals(rating2));
      expect(rating1.hashCode, equals(rating2.hashCode));
    });

    test('dos ratings con diferentes propiedades no son iguales', () {
      // Arrange
      final rating1 = createTestProductRating(rate: 4.5, count: 100);
      final rating2 = createTestProductRating(rate: 3.0, count: 100);

      // Act & Assert
      expect(rating1, isNot(equals(rating2)));
    });

    test('rating es inmutable al usar const constructor', () {
      // Arrange & Act
      const rating1 = ProductRating(rate: 4.5, count: 100);
      const rating2 = ProductRating(rate: 4.5, count: 100);

      // Assert - const instances are identical
      expect(identical(rating1, rating2), isTrue);
    });

    test('toString incluye rate y count', () {
      // Arrange
      const rating = ProductRating(rate: 4.5, count: 100);

      // Act
      final result = rating.toString();

      // Assert
      expect(result, contains('4.5'));
      expect(result, contains('100'));
      expect(result, contains('ProductRating'));
    });

    test('diferentes counts hacen ratings diferentes', () {
      // Arrange
      final rating1 = createTestProductRating(rate: 4.5, count: 100);
      final rating2 = createTestProductRating(rate: 4.5, count: 200);

      // Act & Assert
      expect(rating1, isNot(equals(rating2)));
    });
  });
}
