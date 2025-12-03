import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/core/network/network.dart';
import 'package:fake_store_api_client/src/data/datasources/api_client.dart';
import 'package:http/http.dart' as http;

/// Implementación del cliente HTTP para la API.
///
/// Centraliza la lógica HTTP común: manejo de errores, headers,
/// timeout y parseo de JSON.
///
/// Esto permite que los DataSources específicos solo se enfoquen en
/// definir endpoints y mapear respuestas a modelos.
class ApiClientImpl implements ApiClient {
  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;
  final HttpResponseHandler _responseHandler;

  /// Crea una nueva instancia de [ApiClientImpl].
  ///
  /// [client] es el cliente HTTP a usar.
  /// [baseUrl] es la URL base de la API.
  /// [timeout] es el tiempo máximo de espera para las peticiones.
  /// [responseHandler] maneja las respuestas HTTP.
  ApiClientImpl({
    required http.Client client,
    required String baseUrl,
    required Duration timeout,
    required HttpResponseHandler responseHandler,
  }) : _client = client,
       _baseUrl = baseUrl,
       _timeout = timeout,
       _responseHandler = responseHandler;

  /// Headers comunes para todas las peticiones.
  Map<String, String> get _headers => {
    HttpHeaders.contentType: HttpHeaders.jsonContentType,
    HttpHeaders.accept: HttpHeaders.jsonContentType,
  };

  @override
  Future<T> get<T>({
    required String endpoint,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);
      _responseHandler.handleResponse(response);
      final decodedJson = json.decode(response.body);
      return fromJson(decodedJson);
    } on TimeoutException {
      throw const ConnectionException(message: ErrorMessages.timeout);
    } on SocketException {
      throw const ConnectionException(message: ErrorMessages.noInternet);
    } on http.ClientException {
      throw const ConnectionException(message: ErrorMessages.connectionError);
    } on FormatException catch (e) {
      throw ServerException(
        message: ErrorMessages.invalidResponseWithDetail(e.message),
      );
    }
  }

  @override
  Future<List<T>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJsonList,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);
      _responseHandler.handleResponse(response);
      final List<dynamic> decodedJson =
          json.decode(response.body) as List<dynamic>;
      return decodedJson
          .map((item) => fromJsonList(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw const ConnectionException(message: ErrorMessages.timeout);
    } on SocketException {
      throw const ConnectionException(message: ErrorMessages.noInternet);
    } on http.ClientException {
      throw const ConnectionException(message: ErrorMessages.connectionError);
    } on FormatException catch (e) {
      throw ServerException(
        message: ErrorMessages.invalidResponseWithDetail(e.message),
      );
    }
  }

  @override
  Future<List<T>> getPrimitiveList<T>({required String endpoint}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);
      _responseHandler.handleResponse(response);
      final List<dynamic> decodedJson =
          json.decode(response.body) as List<dynamic>;
      return decodedJson.cast<T>();
    } on TimeoutException {
      throw const ConnectionException(message: ErrorMessages.timeout);
    } on SocketException {
      throw const ConnectionException(message: ErrorMessages.noInternet);
    } on http.ClientException {
      throw const ConnectionException(message: ErrorMessages.connectionError);
    } on FormatException catch (e) {
      throw ServerException(
        message: ErrorMessages.invalidResponseWithDetail(e.message),
      );
    }
  }
}

/// Constantes para headers HTTP.
abstract class HttpHeaders {
  HttpHeaders._();

  /// Header Content-Type.
  static const String contentType = 'Content-Type';

  /// Header Accept.
  static const String accept = 'Accept';

  /// Valor para JSON content type.
  static const String jsonContentType = 'application/json';
}
