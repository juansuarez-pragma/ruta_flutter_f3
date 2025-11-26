import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Contenedor de inyección de dependencias simple.
///
/// En una aplicación real se usaría get_it o similar,
/// pero para el ejemplo mantenemos la simplicidad.
class InjectionContainer {
  InjectionContainer._();

  static FakeStoreClient? _client;

  /// Obtiene la instancia del cliente Fake Store.
  static FakeStoreClient get client {
    _client ??= FakeStoreClient();
    return _client!;
  }

  /// Libera los recursos.
  static void dispose() {
    _client?.dispose();
    _client = null;
  }
}
