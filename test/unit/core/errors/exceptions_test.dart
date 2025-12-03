import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';

void main() {
  group('Exceptions', () {
    group('AppException', () {
      test('toString retorna el mensaje con el tipo', () {
        const exception = ServerException(message: 'Error message');
        expect(exception.toString(), contains('Error message'));
        expect(exception.toString(), contains('ServerException'));
      });
    });

    group('ServerException', () {
      test('tiene mensaje por defecto', () {
        const exception = ServerException();
        expect(exception.message, isNotEmpty);
      });

      test('permite mensaje personalizado', () {
        const exception = ServerException(message: 'Custom error');
        expect(exception.message, 'Custom error');
      });
    });

    group('NotFoundException', () {
      test('almacena mensaje opcional', () {
        const exception = NotFoundException('Resource not found');
        expect(exception.message, 'Resource not found');
      });

      test('tiene mensaje por defecto', () {
        const exception = NotFoundException();
        expect(exception.message, isNotEmpty);
      });
    });

    group('ClientException', () {
      test('tiene mensaje por defecto', () {
        const exception = ClientException();
        expect(exception.message, isNotEmpty);
      });

      test('permite mensaje personalizado', () {
        const exception = ClientException(message: 'Custom error');
        expect(exception.message, 'Custom error');
      });
    });

    group('ConnectionException', () {
      test('tiene mensaje por defecto', () {
        const exception = ConnectionException();
        expect(exception.message, isNotEmpty);
      });

      test('permite mensaje personalizado', () {
        const exception = ConnectionException(message: 'Custom error');
        expect(exception.message, 'Custom error');
      });
    });
  });
}
