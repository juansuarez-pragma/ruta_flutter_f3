/// Configuración para el cliente Fake Store.
///
/// Permite personalizar el comportamiento del cliente
/// como la URL base y el tiempo de espera.
///
/// ## Uso básico
///
/// ```dart
/// // Usar configuración por defecto
/// final client = FakeStoreClient();
///
/// // Configuración personalizada
/// final client = FakeStoreClient(
///   config: FakeStoreConfig(
///     baseUrl: 'https://mi-api.com',
///     timeout: Duration(seconds: 60),
///   ),
/// );
/// ```
class FakeStoreConfig {
  /// URL base de la API.
  ///
  /// Por defecto: 'https://fakestoreapi.com'
  final String baseUrl;

  /// Tiempo máximo de espera para solicitudes HTTP.
  ///
  /// Por defecto: 30 segundos
  final Duration timeout;

  /// Crea una nueva instancia de [FakeStoreConfig].
  ///
  /// Todos los parámetros son opcionales y tienen valores por defecto.
  const FakeStoreConfig({
    this.baseUrl = 'https://fakestoreapi.com',
    this.timeout = const Duration(seconds: 30),
  });

  /// Configuración por defecto.
  static const FakeStoreConfig defaultConfig = FakeStoreConfig();

  @override
  String toString() => 'FakeStoreConfig(baseUrl: $baseUrl, timeout: $timeout)';
}
