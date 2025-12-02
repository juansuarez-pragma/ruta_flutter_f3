import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() {
  group('Either', () {
    group('Left', () {
      test('fold ejecuta onLeft con el valor', () {
        const either = Left<String, int>('error');

        final result = either.fold(
          (left) => 'Left: $left',
          (right) => 'Right: $right',
        );

        expect(result, 'Left: error');
      });

      test('isLeft retorna true', () {
        const either = Left<String, int>('error');
        expect(either.isLeft, isTrue);
      });

      test('isRight retorna false', () {
        const either = Left<String, int>('error');
        expect(either.isRight, isFalse);
      });

      test('leftOrNull retorna el valor', () {
        const either = Left<String, int>('error');
        expect(either.leftOrNull, 'error');
      });

      test('rightOrNull retorna null', () {
        const either = Left<String, int>('error');
        expect(either.rightOrNull, isNull);
      });

      test('map no transforma y mantiene Left', () {
        const either = Left<String, int>('error');

        final result = either.map((right) => right * 2);

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, 'error');
      });

      test('mapLeft transforma el valor', () {
        const either = Left<String, int>('error');

        final result = either.mapLeft((left) => left.toUpperCase());

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, 'ERROR');
      });

      test('dos Left con mismo valor son iguales', () {
        const left1 = Left<String, int>('error');
        const left2 = Left<String, int>('error');

        expect(left1, equals(left2));
        expect(left1.hashCode, equals(left2.hashCode));
      });

      test('dos Left con diferente valor son diferentes', () {
        const left1 = Left<String, int>('error1');
        const left2 = Left<String, int>('error2');

        expect(left1, isNot(equals(left2)));
      });

      test('toString retorna representación correcta', () {
        const either = Left<String, int>('error');
        expect(either.toString(), 'Left(error)');
      });

      test('Left no es igual a Right con mismo valor', () {
        const left = Left<int, int>(42);
        const right = Right<int, int>(42);

        expect(left, isNot(equals(right)));
      });
    });

    group('Right', () {
      test('fold ejecuta onRight con el valor', () {
        const either = Right<String, int>(42);

        final result = either.fold(
          (left) => 'Left: $left',
          (right) => 'Right: $right',
        );

        expect(result, 'Right: 42');
      });

      test('isLeft retorna false', () {
        const either = Right<String, int>(42);
        expect(either.isLeft, isFalse);
      });

      test('isRight retorna true', () {
        const either = Right<String, int>(42);
        expect(either.isRight, isTrue);
      });

      test('leftOrNull retorna null', () {
        const either = Right<String, int>(42);
        expect(either.leftOrNull, isNull);
      });

      test('rightOrNull retorna el valor', () {
        const either = Right<String, int>(42);
        expect(either.rightOrNull, 42);
      });

      test('map transforma el valor', () {
        const either = Right<String, int>(21);

        final result = either.map((right) => right * 2);

        expect(result.isRight, isTrue);
        expect(result.rightOrNull, 42);
      });

      test('mapLeft no transforma y mantiene Right', () {
        const either = Right<String, int>(42);

        final result = either.mapLeft((left) => left.toUpperCase());

        expect(result.isRight, isTrue);
        expect(result.rightOrNull, 42);
      });

      test('dos Right con mismo valor son iguales', () {
        const right1 = Right<String, int>(42);
        const right2 = Right<String, int>(42);

        expect(right1, equals(right2));
        expect(right1.hashCode, equals(right2.hashCode));
      });

      test('dos Right con diferente valor son diferentes', () {
        const right1 = Right<String, int>(42);
        const right2 = Right<String, int>(43);

        expect(right1, isNot(equals(right2)));
      });

      test('toString retorna representación correcta', () {
        const either = Right<String, int>(42);
        expect(either.toString(), 'Right(42)');
      });
    });

    group('pattern matching', () {
      test('switch funciona con Left', () {
        const Either<String, int> either = Left('error');

        final result = switch (either) {
          Left(value: final v) => 'Error: $v',
          Right(value: final v) => 'Value: $v',
        };

        expect(result, 'Error: error');
      });

      test('switch funciona con Right', () {
        const Either<String, int> either = Right(42);

        final result = switch (either) {
          Left(value: final v) => 'Error: $v',
          Right(value: final v) => 'Value: $v',
        };

        expect(result, 'Value: 42');
      });
    });
  });
}
