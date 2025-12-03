import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/core/network/http_response_handler.dart';
import 'package:fake_store_api_client/src/core/network/http_status_codes.dart';

void main() {
  late HttpResponseHandler handler;

  setUp(() {
    handler = HttpResponseHandler();
  });

  group('HttpResponseHandler', () {
    group('respuestas exitosas (2xx)', () {
      test('no hace nada para respuesta 200 OK', () {
        // Arrange
        final response = http.Response('{"data": "ok"}', 200);

        // Act & Assert - no debería lanzar excepción
        expect(() => handler.handleResponse(response), returnsNormally);
      });

      test('no hace nada para respuesta 201 Created', () {
        // Arrange
        final response = http.Response('{}', 201);

        // Act & Assert
        expect(() => handler.handleResponse(response), returnsNormally);
      });

      test('no hace nada para respuesta 204 No Content', () {
        // Arrange
        final response = http.Response('', 204);

        // Act & Assert
        expect(() => handler.handleResponse(response), returnsNormally);
      });

      test('no hace nada para cualquier código 2xx', () {
        // Arrange
        final response = http.Response('', 202);

        // Act & Assert
        expect(() => handler.handleResponse(response), returnsNormally);
      });
    });

    group('errores del cliente (4xx)', () {
      test('lanza NotFoundException para 404 Not Found', () {
        // Arrange
        final response = http.Response('Not Found', HttpStatusCodes.notFound);

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('lanza ClientException para 400 Bad Request', () {
        // Arrange
        final response = http.Response(
          'Bad Request',
          HttpStatusCodes.badRequest,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ClientException>()),
        );
      });

      test('lanza ClientException para 401 Unauthorized', () {
        // Arrange
        final response = http.Response(
          'Unauthorized',
          HttpStatusCodes.unauthorized,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ClientException>()),
        );
      });

      test('lanza ClientException para 403 Forbidden', () {
        // Arrange
        final response = http.Response('Forbidden', HttpStatusCodes.forbidden);

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ClientException>()),
        );
      });

      test(
        'lanza ClientException para código 4xx no mapeado explícitamente',
        () {
          // Arrange - 405 Method Not Allowed no está en el mapa
          final response = http.Response('Method Not Allowed', 405);

          // Act & Assert
          expect(
            () => handler.handleResponse(response),
            throwsA(isA<ClientException>()),
          );
        },
      );

      test('lanza ClientException para 429 Too Many Requests', () {
        // Arrange
        final response = http.Response(
          'Rate Limited',
          HttpStatusCodes.tooManyRequests,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ClientException>()),
        );
      });

      test('lanza ClientException para 422 Unprocessable Entity', () {
        // Arrange
        final response = http.Response(
          'Unprocessable Entity',
          HttpStatusCodes.unprocessableEntity,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ClientException>()),
        );
      });
    });

    group('errores del servidor (5xx)', () {
      test('lanza ServerException para 500 Internal Server Error', () {
        // Arrange
        final response = http.Response(
          'Server Error',
          HttpStatusCodes.internalServerError,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ServerException>()),
        );
      });

      test('lanza ServerException para 502 Bad Gateway', () {
        // Arrange
        final response = http.Response(
          'Bad Gateway',
          HttpStatusCodes.badGateway,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ServerException>()),
        );
      });

      test('lanza ServerException para 503 Service Unavailable', () {
        // Arrange
        final response = http.Response(
          'Service Unavailable',
          HttpStatusCodes.serviceUnavailable,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ServerException>()),
        );
      });

      test('lanza ServerException para 504 Gateway Timeout', () {
        // Arrange
        final response = http.Response(
          'Gateway Timeout',
          HttpStatusCodes.gatewayTimeout,
        );

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ServerException>()),
        );
      });

      test(
        'lanza ServerException para código 5xx no mapeado explícitamente',
        () {
          // Arrange - 505 HTTP Version Not Supported
          final response = http.Response('HTTP Version Not Supported', 505);

          // Act & Assert
          expect(
            () => handler.handleResponse(response),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });

    group('códigos no esperados', () {
      test('lanza ServerException para código inesperado', () {
        // Arrange - código 600 (no existe)
        final response = http.Response('Unknown', 600);

        // Act & Assert
        expect(
          () => handler.handleResponse(response),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });

  group('HttpStatusCodes', () {
    group('constantes', () {
      test('notFound es 404', () {
        expect(HttpStatusCodes.notFound, 404);
      });

      test('internalServerError es 500', () {
        expect(HttpStatusCodes.internalServerError, 500);
      });
    });

    group('isSuccess', () {
      test('retorna true para 200', () {
        expect(HttpStatusCodes.isSuccess(200), isTrue);
      });

      test('retorna true para 201', () {
        expect(HttpStatusCodes.isSuccess(201), isTrue);
      });

      test('retorna true para 299', () {
        expect(HttpStatusCodes.isSuccess(299), isTrue);
      });

      test('retorna false para 300', () {
        expect(HttpStatusCodes.isSuccess(300), isFalse);
      });

      test('retorna false para 400', () {
        expect(HttpStatusCodes.isSuccess(400), isFalse);
      });
    });

    group('isClientError', () {
      test('retorna true para 400', () {
        expect(HttpStatusCodes.isClientError(400), isTrue);
      });

      test('retorna true para 404', () {
        expect(HttpStatusCodes.isClientError(404), isTrue);
      });

      test('retorna true para 499', () {
        expect(HttpStatusCodes.isClientError(499), isTrue);
      });

      test('retorna false para 500', () {
        expect(HttpStatusCodes.isClientError(500), isFalse);
      });

      test('retorna false para 200', () {
        expect(HttpStatusCodes.isClientError(200), isFalse);
      });
    });

    group('isServerError', () {
      test('retorna true para 500', () {
        expect(HttpStatusCodes.isServerError(500), isTrue);
      });

      test('retorna true para 503', () {
        expect(HttpStatusCodes.isServerError(503), isTrue);
      });

      test('retorna true para 599', () {
        expect(HttpStatusCodes.isServerError(599), isTrue);
      });

      test('retorna false para 400', () {
        expect(HttpStatusCodes.isServerError(400), isFalse);
      });

      test('retorna false para 200', () {
        expect(HttpStatusCodes.isServerError(200), isFalse);
      });
    });

    group('getDescription', () {
      test('retorna descripción correcta para 404', () {
        expect(HttpStatusCodes.getDescription(404), 'Not Found');
      });

      test('retorna descripción correcta para 500', () {
        expect(HttpStatusCodes.getDescription(500), 'Internal Server Error');
      });

      test('retorna HTTP Error para código no mapeado', () {
        expect(HttpStatusCodes.getDescription(999), 'HTTP Error 999');
      });
    });
  });
}
