# CLAUDE.md - Guía para Asistentes de IA

## Descripción del Proyecto

Este es un **paquete Flutter** que proporciona un cliente para la [Fake Store API](https://fakestoreapi.com/). Está diseñado con Clean Architecture y usa manejo funcional de errores con el tipo `Either<Failure, Success>`.

## Comandos Esenciales

```bash
# Obtener dependencias
flutter pub get

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
dart format .

# Ejecutar ejemplo
cd example && flutter run
```

## Arquitectura del Paquete

```
lib/
├── fake_store_api_client.dart    # API pública (barrel file)
└── src/
    ├── client/                    # Capa de presentación pública
    │   ├── fake_store_client.dart # Fachada principal
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
    │   ├── models/                # Modelos con JSON parsing
    │   │   ├── product_model.dart
    │   │   └── product_rating_model.dart
    │   ├── datasources/           # Fuentes de datos
    │   │   ├── fake_store_datasource.dart
    │   │   └── api_client_impl.dart
    │   └── repositories/          # Implementaciones
    │       └── product_repository_impl.dart
    │
    └── core/                      # Utilidades compartidas
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
```

## Patrones de Diseño Utilizados

1. **Facade Pattern**: `FakeStoreClient` es la fachada que oculta la complejidad interna
2. **Repository Pattern**: Abstracción entre dominio y datos
3. **Strategy Pattern**: `HttpResponseHandler` para manejar diferentes códigos HTTP
4. **Dependency Injection**: Constructor injection en todas las clases

## Manejo de Códigos HTTP

### HttpStatusCodes

Clase utilitaria con constantes para todos los códigos HTTP relevantes:

```dart
// Constantes disponibles
HttpStatusCodes.ok           // 200
HttpStatusCodes.created      // 201
HttpStatusCodes.badRequest   // 400
HttpStatusCodes.unauthorized // 401
HttpStatusCodes.forbidden    // 403
HttpStatusCodes.notFound     // 404
HttpStatusCodes.tooManyRequests // 429
HttpStatusCodes.internalServerError // 500
// ... y más

// Métodos utilitarios
HttpStatusCodes.isSuccess(200)      // true
HttpStatusCodes.isClientError(404)  // true
HttpStatusCodes.isServerError(500)  // true
HttpStatusCodes.getDescription(404) // 'Not Found'
```

### HttpResponseHandler

Implementa el patrón Strategy para mapear códigos HTTP a excepciones:

```dart
// Flujo de manejo de respuestas:
// 1. 2xx → Éxito (no lanza excepción)
// 2. Código específico → Estrategia mapeada
// 3. 4xx genérico → ClientException
// 4. 5xx genérico → ServerException
```

### Excepciones con Información de Diagnóstico

Las excepciones incluyen información útil para debugging:

```dart
// ConnectionException con URI y error original
throw ConnectionException(
  message: 'Sin conexión a internet',
  uri: uri,
  originalError: e.message,
);

// ServerException/ClientException con código HTTP
throw ServerException(
  message: 'Error interno del servidor',
  statusCode: 500,
);
```

## Convenciones de Código

### Manejo de Errores
```dart
// Siempre usar Either para operaciones que pueden fallar
Future<Either<FakeStoreFailure, T>> operation();

// Pattern matching para consumir el resultado
result.fold(
  (failure) => handleError(failure),
  (success) => handleSuccess(success),
);
```

### Sealed Classes para Failures
```dart
// Los failures usan sealed class para pattern matching exhaustivo
sealed class FakeStoreFailure {
  final String message;
  const FakeStoreFailure(this.message);

  // Igualdad manual (sin Equatable)
  @override
  bool operator ==(Object other) => ...;
  @override
  int get hashCode => message.hashCode;
}

final class ConnectionFailure extends FakeStoreFailure { ... }
final class ServerFailure extends FakeStoreFailure { ... }
final class NotFoundFailure extends FakeStoreFailure { ... }
final class InvalidRequestFailure extends FakeStoreFailure { ... }
```

### Modelos vs Entidades
- **Entidades** (`Product`, `ProductRating`): Inmutables, sin lógica de serialización
- **Modelos** (`ProductModel`, `ProductRatingModel`): Extienden entidades, incluyen `fromJson`/`toJson`

### Barrel Files
Cada carpeta tiene un barrel file (`*.dart`) que exporta todos sus archivos públicos.

## API Pública

Solo se exporta lo necesario para el consumidor:

```dart
// Desde fake_store_api_client.dart
export 'src/core/either/either.dart';       // Either, Left, Right (implementación propia)
export 'src/client/client.dart';            // FakeStoreClient, FakeStoreConfig
export 'src/domain/entities/entities.dart'; // Product, ProductRating
export 'src/domain/failures/failures.dart'; // Todos los Failures
```

## Estructura del Ejemplo

El ejemplo sigue las buenas prácticas de paquetes Flutter: un solo archivo `main.dart` que demuestra el uso del paquete.

```
example/
├── lib/
│   └── main.dart    # Aplicación completa de ejemplo
├── pubspec.yaml
└── README.md
```

### Contenido del Ejemplo

El archivo `main.dart` contiene:

- `MyApp`: Configuración de MaterialApp
- `ProductsPage`: Página principal con lista de productos y filtro por categorías
- `_ProductCard`: Widget de tarjeta de producto
- `ProductDetailPage`: Página de detalle de producto

### Demostración de Funcionalidades

El ejemplo demuestra:

1. **Crear el cliente**: `final client = FakeStoreClient();`
2. **Obtener productos**: `client.getProducts()`
3. **Obtener categorías**: `client.getCategories()`
4. **Filtrar por categoría**: `client.getProductsByCategory(category)`
5. **Manejar errores con Either**: `result.fold((failure) => ..., (success) => ...)`
6. **Liberar recursos**: `client.dispose()`

## Tests

Los tests están en `/test` y cubren:
- Entidades (igualdad, props)
- Failures (mensaje, tipo)
- Configuración (valores por defecto, personalizados)

```bash
# Ejecutar tests con coverage
flutter test --coverage
```

## Notas Importantes

1. **No usar code generation**: El parseo JSON es manual (sin json_serializable)
2. **Inmutabilidad**: Todas las entidades son inmutables con `final` fields
3. **Igualdad manual**: Se implementa `==` y `hashCode` manualmente (sin Equatable)
4. **Either propio**: Implementación propia del tipo Either (sin dartz)
5. **Dispose**: Siempre llamar `client.dispose()` al terminar
6. **Sealed classes**: Los subtipos de `FakeStoreFailure` deben estar en el mismo archivo
7. **Ejemplo simple**: El ejemplo usa solo widgets Material para máxima simplicidad
8. **Mínimas dependencias**: Solo `http` como dependencia externa

## Extensión del Paquete

Para agregar nuevas funcionalidades:

1. **Nueva entidad**: Agregar en `domain/entities/`, actualizar barrel file
2. **Nuevo endpoint**: Agregar constante en `core/constants/api_endpoints.dart`
3. **Nuevo método en cliente**: Agregar en `FakeStoreClient` y `ProductRepository`
4. **Nuevo tipo de error**: Agregar como subclase de `FakeStoreFailure` (mismo archivo)
5. **Nuevo código HTTP**: Agregar constante en `HttpStatusCodes` y estrategia en `HttpResponseHandler`

## Dependencias

### Paquete Principal

| Paquete | Propósito |
|---------|-----------|
| `http` | Cliente HTTP |

### Ejemplo (example/)

| Paquete | Propósito |
|---------|-----------|
| `fake_store_api_client` | Cliente de la API (este paquete) |

## Troubleshooting

### Problema: TimeoutException en Android Emulator

**Síntomas:**
- La app muestra "Error inesperado: TimeoutException after 0:00:30.000000"
- Los productos no cargan en el emulador Android
- La app funciona correctamente en Chrome (web) y dispositivos físicos

**Causa raíz:**
El emulador Android no puede resolver nombres de dominio (DNS). Aunque el ping a IPs funciona (ej. `8.8.8.8`), no puede resolver `fakestoreapi.com`.

**Diagnóstico:**
```bash
# Verificar conectividad IP (funciona)
adb -s emulator-5554 shell ping -c 2 8.8.8.8

# Verificar resolución DNS (falla)
adb -s emulator-5554 shell ping -c 2 fakestoreapi.com
# Error: "ping: unknown host fakestoreapi.com"
```

**Solución:**
Iniciar el emulador con servidores DNS explícitos de Google:

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

Ejemplo completo:
```bash
# Con cold boot (reinicio limpio)
emulator -avd api33-040825 -dns-server 8.8.8.8,8.8.4.4 -no-snapshot-load
```

**Verificación:**
```bash
# Ahora debería funcionar
adb -s emulator-5556 shell ping -c 2 fakestoreapi.com
# PING fakestoreapi.com (172.67.194.129) ...
```

### Configuración de Android requerida

El ejemplo incluye la configuración necesaria en `AndroidManifest.xml`:

```xml
<manifest>
    <!-- Permiso de Internet -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config">
        ...
    </application>
</manifest>
```

Y el archivo `res/xml/network_security_config.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

## Recursos

- [Fake Store API Docs](https://fakestoreapi.com/docs)
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
