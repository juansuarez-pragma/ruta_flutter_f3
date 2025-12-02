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
      test('almacena mensaje correctamente', () {
        const exception = ServerException(message: 'Internal server error');
        expect(exception.message, 'Internal server error');
      });

      test('almacena statusCode opcional', () {
        const exception = ServerException(message: 'Error', statusCode: 500);
        expect(exception.statusCode, 500);
      });

      test('toString incluye statusCode cuando está presente', () {
        const exception = ServerException(message: 'Error', statusCode: 503);
        expect(exception.toString(), contains('503'));
      });

      test('tiene mensaje por defecto', () {
        const exception = ServerException();
        expect(exception.message, isNotEmpty);
      });

      test('withMessage constructor funciona', () {
        const exception = ServerException.withMessage('Custom message');
        expect(exception.message, 'Custom message');
        expect(exception.statusCode, isNull);
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
      test('almacena mensaje correctamente', () {
        const exception = ClientException(message: 'Bad request');
        expect(exception.message, 'Bad request');
      });

      test('almacena statusCode opcional', () {
        const exception = ClientException(message: 'Error', statusCode: 400);
        expect(exception.statusCode, 400);
      });

      test('toString incluye statusCode cuando está presente', () {
        const exception = ClientException(message: 'Error', statusCode: 422);
        expect(exception.toString(), contains('422'));
      });

      test('tiene mensaje por defecto', () {
        const exception = ClientException();
        expect(exception.message, isNotEmpty);
      });

      test('withMessage constructor funciona', () {
        const exception = ClientException.withMessage('Custom message');
        expect(exception.message, 'Custom message');
        expect(exception.statusCode, isNull);
      });
    });

    group('ConnectionException', () {
      test('almacena uri y originalError', () {
        final uri = Uri.parse('https://api.example.com/products');
        final exception = ConnectionException(
          uri: uri,
          originalError: 'Connection refused',
        );

        expect(exception.uri, uri);
        expect(exception.originalError, 'Connection refused');
      });

      test('toString incluye todos los campos cuando están presentes', () {
        final exception = ConnectionException(
          message: 'Connection failed',
          uri: Uri.parse('https://api.example.com'),
          originalError: 'Timeout',
        );

        final result = exception.toString();
        expect(result, contains('ConnectionException'));
        expect(result, contains('Connection failed'));
        expect(result, contains('api.example.com'));
      });

      test('toString muestra mensaje cuando no hay uri ni originalError', () {
        const exception = ConnectionException();
        final result = exception.toString();
        expect(result, contains('ConnectionException'));
      });

      test('tiene mensaje por defecto', () {
        const exception = ConnectionException();
        expect(exception.message, isNotEmpty);
      });

      test('withMessage constructor funciona', () {
        const exception = ConnectionException.withMessage('Custom message');
        expect(exception.message, 'Custom message');
        expect(exception.uri, isNull);
        expect(exception.originalError, isNull);
      });
    });
  });
}
