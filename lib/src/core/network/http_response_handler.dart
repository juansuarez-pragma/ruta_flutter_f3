import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/core/network/http_status_codes.dart';
import 'package:http/http.dart' as http;

/// Mapea códigos de estado HTTP a excepciones tipadas.
class HttpResponseHandler {
  static final Map<int, void Function(http.Response)> _strategies = {
    HttpStatusCodes.badRequest: (_) => throw const ClientException(
      message: ErrorMessages.badRequest,
    ),
    HttpStatusCodes.unauthorized: (_) => throw const ClientException(
      message: ErrorMessages.unauthorized,
    ),
    HttpStatusCodes.forbidden: (_) => throw const ClientException(
      message: ErrorMessages.forbidden,
    ),
    HttpStatusCodes.notFound: (_) => throw const NotFoundException(),
    HttpStatusCodes.requestTimeout: (_) =>
        throw const ConnectionException(message: ErrorMessages.timeout),
    HttpStatusCodes.unprocessableEntity: (_) => throw const ClientException(
      message: ErrorMessages.unprocessableEntity,
    ),
    HttpStatusCodes.tooManyRequests: (_) => throw const ClientException(
      message: ErrorMessages.tooManyRequests,
    ),
    HttpStatusCodes.internalServerError: (_) => throw const ServerException(),
    HttpStatusCodes.badGateway: (_) => throw const ServerException(
      message: ErrorMessages.badGateway,
    ),
    HttpStatusCodes.serviceUnavailable: (_) => throw const ServerException(
      message: ErrorMessages.serviceUnavailable,
    ),
    HttpStatusCodes.gatewayTimeout: (_) => throw const ServerException(
      message: ErrorMessages.gatewayTimeout,
    ),
  };

  /// Procesa una respuesta HTTP y lanza excepciones según el código de estado.
  void handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (HttpStatusCodes.isSuccess(statusCode)) return;

    final strategy = _strategies[statusCode];
    if (strategy != null) {
      strategy(response);
      return;
    }

    if (HttpStatusCodes.isServerError(statusCode)) {
      throw ServerException(
        message: ErrorMessages.serverErrorWithDescription(
          HttpStatusCodes.getDescription(statusCode),
        ),
      );
    }

    if (HttpStatusCodes.isClientError(statusCode)) {
      throw ClientException(
        message: ErrorMessages.clientErrorWithDescription(
          HttpStatusCodes.getDescription(statusCode),
        ),
      );
    }

    throw ServerException(
      message: ErrorMessages.unexpectedStatusCode(statusCode),
    );
  }
}
