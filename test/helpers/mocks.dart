/// Mocks para testing usando mocktail.
///
/// Proporciona mocks para todas las dependencias necesarias en tests.
library;

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:fake_store_api_client/src/core/network/http_response_handler.dart';
import 'package:fake_store_api_client/src/data/datasources/api_client.dart';
import 'package:fake_store_api_client/src/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_api_client/src/domain/repositories/product_repository.dart';
import 'package:fake_store_api_client/src/presentation/contracts/user_interface.dart';

/// Mock del cliente HTTP.
class MockHttpClient extends Mock implements http.Client {}

/// Mock del manejador de respuestas HTTP.
class MockHttpResponseHandler extends Mock implements HttpResponseHandler {}

/// Mock del cliente de API.
class MockApiClient extends Mock implements ApiClient {}

/// Mock del datasource de Fake Store.
class MockFakeStoreDatasource extends Mock implements FakeStoreDatasource {}

/// Mock del repositorio de productos.
class MockProductRepository extends Mock implements ProductRepository {}

/// Mock de la interfaz de usuario.
class MockUserInterface extends Mock implements UserInterface {}

/// Clase para registrar fallback values.
class FakeUri extends Fake implements Uri {}

/// Clase para registrar fallback values de Response.
class FakeResponse extends Fake implements http.Response {}
