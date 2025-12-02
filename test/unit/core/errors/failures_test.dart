import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() {
  group('FakeStoreFailure', () {
    group('ServerFailure', () {
      test('almacena el mensaje correctamente', () {
        const failure = ServerFailure('Error del servidor');
        expect(failure.message, 'Error del servidor');
      });

      test('tiene mensaje por defecto', () {
        const failure = ServerFailure();
        expect(failure.message, isNotEmpty);
      });

      test('dos failures con mismo mensaje son iguales', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1, equals(failure2));
      });

      test('dos failures con mismo mensaje tienen mismo hashCode', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });

    group('NotFoundFailure', () {
      test('almacena el mensaje correctamente', () {
        const failure = NotFoundFailure('Recurso no encontrado');
        expect(failure.message, 'Recurso no encontrado');
      });

      test('tiene mensaje por defecto', () {
        const failure = NotFoundFailure();
        expect(failure.message, isNotEmpty);
      });
    });

    group('InvalidRequestFailure', () {
      test('almacena el mensaje correctamente', () {
        const failure = InvalidRequestFailure('Error del cliente');
        expect(failure.message, 'Error del cliente');
      });

      test('tiene mensaje por defecto', () {
        const failure = InvalidRequestFailure();
        expect(failure.message, isNotEmpty);
      });
    });

    group('ConnectionFailure', () {
      test('almacena el mensaje correctamente', () {
        const failure = ConnectionFailure('Error de conexión');
        expect(failure.message, 'Error de conexión');
      });

      test('tiene mensaje por defecto', () {
        const failure = ConnectionFailure();
        expect(failure.message, isNotEmpty);
      });
    });

    group('igualdad entre tipos', () {
      test('diferentes tipos de Failure con mismo mensaje no son iguales', () {
        const serverFailure = ServerFailure('Error');
        const notFoundFailure = NotFoundFailure('Error');
        expect(serverFailure, isNot(equals(notFoundFailure)));
      });

      test('mismo tipo con diferente mensaje no son iguales', () {
        const failure1 = ServerFailure('Error 1');
        const failure2 = ServerFailure('Error 2');
        expect(failure1, isNot(equals(failure2)));
      });
    });

    group('toString', () {
      test('incluye tipo y mensaje', () {
        const failure = ServerFailure('Test error');
        final result = failure.toString();
        expect(result, contains('ServerFailure'));
        expect(result, contains('Test error'));
      });
    });
  });
}
