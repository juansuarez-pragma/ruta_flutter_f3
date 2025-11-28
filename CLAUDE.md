# CLAUDE.md - Guía Completa para Agentes de IA

> **Propósito:** Este documento proporciona TODO el contexto necesario para que un agente de IA pueda trabajar con este paquete siguiendo las mejores prácticas de la industria.

---

## 1. Descripción del Proyecto

**fake_store_api_client** es un paquete Flutter que proporciona un cliente para la [Fake Store API](https://fakestoreapi.com/).

| Aspecto | Detalle |
|---------|---------|
| **Versión** | 1.2.0 |
| **Licencia** | MIT |
| **SDK Dart** | ^3.9.2 |
| **Flutter** | >=3.0.0 |
| **Dependencias** | Solo `http` |
| **Pub Points** | 160/160 |

### Características Principales

- Clean Architecture con separación de capas
- Manejo funcional de errores con `Either<Failure, Success>`
- Sealed classes para pattern matching exhaustivo
- Sin dependencias externas innecesarias (sin dartz, sin equatable)
- Soporte multiplataforma: iOS, Android, Windows, macOS, Linux

---

## 2. Comandos Esenciales

```bash
# Dependencias
flutter pub get

# Tests
flutter test
flutter test --coverage

# Análisis estático
flutter analyze
dart analyze

# Formateo (SIEMPRE ejecutar antes de commit)
dart format .

# Verificar pub points localmente
dart pub global activate pana
pana .

# Ejecutar ejemplo
cd example && flutter run

# Publicar (dry-run primero)
dart pub publish --dry-run
dart pub publish
```

---

## 3. Arquitectura del Paquete

```
lib/
├── fake_store_api_client.dart    # Entry point único (API pública)
└── src/
    ├── client/                    # Capa de presentación (Fachada)
    │   ├── fake_store_client.dart # Cliente público
    │   └── fake_store_config.dart # Configuración
    │
    ├── domain/                    # Capa de dominio (sin dependencias externas)
    │   ├── entities/              # Entidades inmutables
    │   │   ├── product.dart
    │   │   └── product_rating.dart
    │   ├── failures/              # Jerarquía de errores (sealed class)
    │   │   └── fake_store_failure.dart
    │   └── repositories/          # Contratos abstractos
    │       └── product_repository.dart
    │
    ├── data/                      # Capa de datos
    │   ├── models/                # DTOs con JSON parsing
    │   │   ├── product_model.dart
    │   │   └── product_rating_model.dart
    │   ├── datasources/           # Acceso a datos
    │   │   ├── api_client.dart        # Contrato
    │   │   ├── api_client_impl.dart   # Implementación HTTP
    │   │   └── fake_store_datasource.dart
    │   └── repositories/          # Implementaciones de contratos
    │       └── product_repository_impl.dart
    │
    └── core/                      # Utilidades compartidas
        ├── either/                # Tipo Either propio
        │   └── either.dart
        ├── errors/                # Excepciones internas
        │   ├── app_exception.dart
        │   ├── client_exception.dart
        │   ├── connection_exception.dart
        │   ├── not_found_exception.dart
        │   └── server_exception.dart
        ├── network/               # Manejo de HTTP
        │   ├── http_response_handler.dart
        │   └── http_status_codes.dart
        └── constants/             # Endpoints
            └── api_endpoints.dart
```

---

## 4. Patrones de Diseño Implementados

| Patrón | Implementación | Archivo |
|--------|---------------|---------|
| **Facade** | `FakeStoreClient` oculta complejidad interna | `fake_store_client.dart` |
| **Repository** | Abstracción entre dominio y datos | `product_repository.dart` |
| **Strategy** | Manejo de códigos HTTP | `http_response_handler.dart` |
| **Factory** | Creación de objetos desde JSON | `*_model.dart` |
| **Dependency Injection** | Constructor injection | Todas las clases |

### Principios SOLID Aplicados

| Principio | Aplicación |
|-----------|------------|
| **S** - Single Responsibility | Cada clase tiene una única responsabilidad |
| **O** - Open/Closed | `HttpResponseHandler` extensible via mapa de estrategias |
| **L** - Liskov Substitution | Modelos sustituyen entidades |
| **I** - Interface Segregation | Interfaces pequeñas (`ApiClient`, `ProductRepository`) |
| **D** - Dependency Inversion | Repositorio depende de abstracción, no de implementación |

---

## 5. Manejo de Errores

### Flujo de Errores (Data → Domain)

```
HTTP Response
     ↓
HttpResponseHandler (lanza Exception)
     ↓
ApiClientImpl (captura, puede re-lanzar ConnectionException)
     ↓
ProductRepositoryImpl._handleRequest (convierte Exception → Failure)
     ↓
Either<FakeStoreFailure, T> (retorna al cliente)
```

### Excepciones (Capa Data)

```dart
// Base
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

// Tipos específicos con información de diagnóstico
class ConnectionException extends AppException {
  final Uri? uri;           // URI que falló
  final String? originalError; // Error original
}

class ServerException extends AppException {
  final int? statusCode;    // Código HTTP
}

class ClientException extends AppException {
  final int? statusCode;    // Código HTTP
}

class NotFoundException extends AppException { }
```

### Failures (Capa Domain)

```dart
// Sealed class para pattern matching exhaustivo
sealed class FakeStoreFailure {
  final String message;
  const FakeStoreFailure(this.message);
}

final class ConnectionFailure extends FakeStoreFailure { }
final class ServerFailure extends FakeStoreFailure { }
final class NotFoundFailure extends FakeStoreFailure { }
final class InvalidRequestFailure extends FakeStoreFailure { }
```

### Mapeo Exception → Failure

```dart
// En ProductRepositoryImpl._handleRequest
try {
  return Right(await action());
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} on ConnectionException catch (e) {
  return Left(ConnectionFailure(e.message));
} on NotFoundException catch (e) {
  return Left(NotFoundFailure(e.message));
} on ClientException catch (e) {
  return Left(InvalidRequestFailure(e.message));
} catch (e) {
  return Left(ServerFailure('Error inesperado: $e'));
}
```

---

## 6. HttpStatusCodes y HttpResponseHandler

### HttpStatusCodes

```dart
// Constantes
HttpStatusCodes.ok                  // 200
HttpStatusCodes.created             // 201
HttpStatusCodes.badRequest          // 400
HttpStatusCodes.unauthorized        // 401
HttpStatusCodes.forbidden           // 403
HttpStatusCodes.notFound            // 404
HttpStatusCodes.tooManyRequests     // 429
HttpStatusCodes.internalServerError // 500
HttpStatusCodes.badGateway          // 502
HttpStatusCodes.serviceUnavailable  // 503
HttpStatusCodes.gatewayTimeout      // 504

// Métodos utilitarios
HttpStatusCodes.isSuccess(code)     // 200-299
HttpStatusCodes.isClientError(code) // 400-499
HttpStatusCodes.isServerError(code) // 500-599
HttpStatusCodes.getDescription(404) // 'Not Found'
```

### HttpResponseHandler (Patrón Strategy)

```dart
// Flujo de manejo:
// 1. 2xx → Éxito (no lanza excepción)
// 2. Código específico → Estrategia del mapa
// 3. 4xx genérico → ClientException
// 4. 5xx genérico → ServerException

static final Map<int, void Function(http.Response)> _strategies = {
  HttpStatusCodes.badRequest: (_) => throw ClientException(...),
  HttpStatusCodes.notFound: (_) => throw NotFoundException(),
  HttpStatusCodes.internalServerError: (_) => throw ServerException(...),
  // ... más estrategias
};
```

---

## 7. API Pública (Exports)

```dart
// lib/fake_store_api_client.dart
export 'src/core/either/either.dart';       // Either, Left, Right
export 'src/client/client.dart';            // FakeStoreClient, FakeStoreConfig
export 'src/domain/entities/entities.dart'; // Product, ProductRating
export 'src/domain/failures/failures.dart'; // FakeStoreFailure y subclases
```

### Uso del Cliente

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

final client = FakeStoreClient();

// Obtener productos
final result = await client.getProducts();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);

// Pattern matching con switch
switch (result) {
  case Left(value: final failure):
    switch (failure) {
      case ConnectionFailure(): print('Sin conexión');
      case ServerFailure(): print('Error servidor');
      case NotFoundFailure(): print('No encontrado');
      case InvalidRequestFailure(): print('Request inválido');
    }
  case Right(value: final products):
    print('OK: ${products.length} productos');
}

// Liberar recursos
client.dispose();
```

---

## 8. Mejores Prácticas para Desarrollo

### Al Agregar Nuevas Funcionalidades

| Tarea | Archivos a modificar |
|-------|---------------------|
| Nueva entidad | `domain/entities/` + barrel file |
| Nuevo endpoint | `core/constants/api_endpoints.dart` |
| Nuevo método API | `ProductRepository` (contrato) + `ProductRepositoryImpl` (impl) + `FakeStoreClient` |
| Nuevo failure | `fake_store_failure.dart` (mismo archivo, sealed) |
| Nuevo código HTTP | `HttpStatusCodes` + `HttpResponseHandler._strategies` |

### Convenciones de Código

```dart
// 1. Entidades: inmutables, sin serialización
class Product {
  final int id;
  final String title;
  const Product({required this.id, required this.title});
}

// 2. Modelos: extienden entidad, incluyen fromJson/toJson
class ProductModel extends Product {
  const ProductModel({required super.id, required super.title});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
  Product toEntity() => Product(id: id, title: title);
}

// 3. Repositories: retornan Either, nunca lanzan excepciones
Future<Either<FakeStoreFailure, List<Product>>> getAllProducts();

// 4. Doc comments: siempre en API pública
/// Obtiene todos los productos de la tienda.
///
/// Retorna [Right] con lista de [Product] si es exitoso.
/// Retorna [Left] con [FakeStoreFailure] si hay error.
Future<Either<FakeStoreFailure, List<Product>>> getProducts();
```

### Checklist Pre-Commit

- [ ] `dart analyze` sin errores ni warnings
- [ ] `dart format .` aplicado
- [ ] Tests pasando: `flutter test`
- [ ] Documentación actualizada si hay cambios de API
- [ ] CHANGELOG.md actualizado
- [ ] Version bump en pubspec.yaml si es release

---

## 9. Testing

### Estructura de Tests

```
test/
└── fake_store_api_client_test.dart  # Tests actuales
```

### Tests Existentes

- Entidades: Product, ProductRating (igualdad, valores)
- Failures: mensajes por defecto y personalizados
- Configuración: valores por defecto y personalizados

### Tests Pendientes (Oportunidades)

| Área | Prioridad | Descripción |
|------|-----------|-------------|
| ApiClientImpl | Alta | Mock HTTP, probar manejo de errores |
| ProductRepositoryImpl | Alta | Mock datasource, verificar mapeo |
| HttpResponseHandler | Media | Verificar todas las estrategias |
| Either | Baja | fold, map, mapLeft |

### Ejemplo de Test con Mock

```dart
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

test('debe lanzar ConnectionException en timeout', () async {
  final mockClient = MockHttpClient();
  when(() => mockClient.get(any(), headers: any(named: 'headers')))
      .thenThrow(TimeoutException('timeout'));

  final apiClient = ApiClientImpl(
    client: mockClient,
    baseUrl: 'https://test.com',
    timeout: Duration(seconds: 1),
    responseHandler: HttpResponseHandler(),
  );

  expect(
    () => apiClient.get(endpoint: '/test', fromJson: (j) => j),
    throwsA(isA<ConnectionException>()),
  );
});
```

---

## 10. Publicación en pub.dev

### Requisitos Cumplidos

| Requisito | Estado |
|-----------|--------|
| pubspec.yaml válido | Si |
| LICENSE (OSI-approved) | MIT |
| README.md | Completo |
| CHANGELOG.md | Formato correcto |
| Ejemplo en example/ | Si |
| ≥20% API documentada | 97.3% |
| dart format | Aplicado |
| dart analyze | Sin errores |

### Puntuación Actual: 160/160

| Categoría | Puntos |
|-----------|--------|
| Convenciones de archivo | 30/30 |
| Documentación | 20/20 |
| Soporte de plataformas | 20/20 |
| Análisis estático | 50/50 |
| Dependencias actualizadas | 40/40 |

### Plataformas Soportadas

| Plataforma | Estado | Nota |
|------------|--------|------|
| Android | Si | - |
| iOS | Si | - |
| Windows | Si | - |
| macOS | Si | - |
| Linux | Si | - |
| Web | No | Requiere import condicional de dart:io |

---

## 11. Troubleshooting

### TimeoutException en Android Emulator

**Causa:** DNS del emulador no resuelve dominios.

**Solución:**
```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

### Configuración Android Requerida

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<application
    android:usesCleartextTraffic="true"
    android:networkSecurityConfig="@xml/network_security_config">
```

```xml
<!-- res/xml/network_security_config.xml -->
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

---

## 12. Versionamiento (Semantic Versioning)

### Formato: MAJOR.MINOR.PATCH

| Tipo | Cuándo | Ejemplo |
|------|--------|---------|
| MAJOR | Breaking changes | 1.2.0 → 2.0.0 |
| MINOR | Nueva funcionalidad compatible | 1.2.0 → 1.3.0 |
| PATCH | Bug fixes | 1.2.0 → 1.2.1 |

### Historial de Versiones

- **1.2.0**: HttpStatusCodes, diagnóstico en excepciones, LICENSE MIT
- **1.1.0**: Either propio, eliminadas dartz y equatable
- **1.0.1**: Ejemplo simplificado a un solo main.dart
- **1.0.0**: Release inicial

---

## 13. Extensión Futura (Roadmap)

### Planeado

- [ ] Soporte para plataforma Web (import condicional dart:io)
- [ ] Cart API (carrito de compras)
- [ ] Users API (usuarios)
- [ ] Login API (autenticación)
- [ ] Cache local
- [ ] Interceptores HTTP personalizables
- [ ] Cancelación de requests

### Para Agregar Soporte Web

```dart
// Crear: lib/src/data/datasources/api_client_io.dart
// Crear: lib/src/data/datasources/api_client_web.dart
// Modificar: lib/src/data/datasources/api_client_impl.dart

export 'api_client_stub.dart'
    if (dart.library.io) 'api_client_io.dart'
    if (dart.library.html) 'api_client_web.dart';
```

---

## 14. Referencias

- [Fake Store API Docs](https://fakestoreapi.com/docs)
- [Effective Dart](https://dart.dev/effective-dart)
- [Package layout conventions](https://dart.dev/tools/pub/package-layout)
- [pub.dev Scoring](https://pub.dev/help/scoring)
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

---

## 15. Guía Rápida para Agentes de IA

### Antes de Hacer Cambios

1. Leer este archivo completo
2. Ejecutar `flutter analyze` para verificar estado actual
3. Ejecutar `flutter test` para verificar tests

### Al Hacer Cambios

1. Seguir la arquitectura existente (Clean Architecture)
2. Mantener separación Exception (data) vs Failure (domain)
3. Documentar con `///` toda API pública
4. Usar `const` constructors donde sea posible
5. Mantener inmutabilidad en entidades

### Después de Hacer Cambios

1. `dart format .`
2. `dart analyze`
3. `flutter test`
4. Actualizar CHANGELOG.md
5. Bump version si es release

### Comandos de Verificación Rápida

```bash
# Todo en uno
dart format . && dart analyze && flutter test

# Verificar pub points
pana .
```
