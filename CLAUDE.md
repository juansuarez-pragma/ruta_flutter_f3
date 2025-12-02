# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) para trabajar con el código en este repositorio.

## Descripción del Proyecto

**fake_store_api_client** - Paquete Flutter para la [Fake Store API](https://fakestoreapi.com/) con Clean Architecture, patrón Ports & Adapters y manejo funcional de errores usando `Either<Failure, Success>`.

- Versión: 1.4.0
- SDK: Dart ^3.9.2, Flutter >=3.0.0
- Dependencias: Solo `http`
- Plataformas: iOS, Android, Windows, macOS, Linux (sin soporte Web aún)

## Comandos Esenciales

```bash
# Instalar dependencias
flutter pub get

# Ejecutar tests
flutter test
flutter test test/archivo_especifico_test.dart  # Un solo archivo

# Análisis estático (ejecutar antes de commits)
dart format . && dart analyze && flutter test

# Ejecutar app de ejemplo
cd example && flutter run

# Verificar puntuación pub.dev
pana .

# Publicar
dart pub publish --dry-run
dart pub publish
```

## Arquitectura (Clean Architecture + Ports & Adapters)

```
lib/
├── fake_store_api_client.dart    # Punto de entrada único (exports públicos)
└── src/
    ├── presentation/              # Patrón Ports & Adapters
    │   ├── contracts/             # Ports (interfaces de UI)
    │   │   ├── menu_option.dart   # Enum de opciones del menú
    │   │   ├── user_input.dart    # Contrato entrada de usuario
    │   │   ├── message_output.dart# Contrato salida de mensajes
    │   │   ├── product_output.dart# Contrato salida de productos
    │   │   ├── category_output.dart# Contrato salida de categorías
    │   │   └── user_interface.dart# Interfaz compuesta
    │   └── controller/
    │       └── application_controller.dart # Orquestador UI-Repository
    ├── domain/                    # Sin dependencias externas
    │   ├── entities/              # Clases de datos inmutables
    │   ├── failures/              # Jerarquía sealed class
    │   └── repositories/          # Contratos abstractos
    ├── data/                      # Capa de implementación
    │   ├── models/                # DTOs con parsing JSON (extienden entities)
    │   ├── datasources/           # Acceso HTTP
    │   └── repositories/          # Implementaciones de contratos
    └── core/
        ├── either/                # Tipo Either propio
        ├── errors/                # Excepciones internas
        ├── network/               # Manejo HTTP
        └── constants/             # Endpoints de API
```

## Patrón Ports & Adapters

El paquete implementa arquitectura hexagonal para permitir intercambiar interfaces de usuario:

- **Port**: `UserInterface` - contrato abstracto que define cómo interactuar con el usuario
- **Adapter**: Implementaciones concretas (ej: `FlutterUserInterface` en el ejemplo)
- **Core**: `ApplicationController` - orquesta la lógica sin conocer detalles de UI

```dart
// Crear adapter personalizado
class MiUserInterface implements UserInterface {
  // Implementar métodos del contrato...
}

// Usar con el controlador
final controller = ApplicationController(
  ui: MiUserInterface(),
  repository: ProductRepositoryImpl(datasource: datasource),
);

await controller.executeOption(MenuOption.getAllProducts);
```

## Uso Directo del Repositorio

Para casos donde no se necesita el patrón Ports & Adapters:

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:http/http.dart' as http;

final datasource = FakeStoreDatasource(
  apiClient: ApiClientImpl(
    client: http.Client(),
    baseUrl: 'https://fakestoreapi.com',
    timeout: Duration(seconds: 30),
    responseHandler: HttpResponseHandler(),
  ),
);
final repository = ProductRepositoryImpl(datasource: datasource);

// Usar directamente
final result = await repository.getAllProducts();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);
```

## AppStrings - Textos Centralizados

Los textos de UI están centralizados en `AppStrings` para facilitar mantenimiento e i18n:

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

// Constantes
AppStrings.loadingProducts      // 'Obteniendo productos...'
AppStrings.invalidIdError       // 'ID inválido.'
AppStrings.serverFailureMessage // 'Error en el servidor.'

// Métodos parametrizados
AppStrings.loadingProductById(5)           // 'Obteniendo producto #5...'
AppStrings.loadingProductsByCategory('x')  // 'Obteniendo productos de x...'
```

## Flujo de Manejo de Errores

```
HTTP Response → HttpResponseHandler (lanza Exception)
             → ApiClientImpl (captura, envuelve errores de red)
             → ProductRepositoryImpl._handleRequest (Exception → Failure)
             → Either<FakeStoreFailure, T> (retorna al cliente)
```

**Excepciones (capa data):** `ServerException`, `ClientException`, `ConnectionException`, `NotFoundException`

**Failures (capa domain, sealed):** `ServerFailure`, `InvalidRequestFailure`, `ConnectionFailure`, `NotFoundFailure`

## Patrones Clave

| Patrón | Ubicación |
|--------|-----------|
| **Repository** | Contratos abstractos en domain, implementaciones en data |
| **Strategy** | `HttpResponseHandler` - mapea códigos HTTP a excepciones |
| **Factory** | Métodos `*Model.fromJson()` |
| **Ports & Adapters** | `UserInterface` (port) + `ApplicationController` (core) |

## Agregar Nuevas Funcionalidades

| Tarea | Archivos a modificar |
|-------|----------------------|
| Nueva entidad | `domain/entities/` + barrel file |
| Nuevo endpoint | `core/constants/api_endpoints.dart` |
| Nuevo método API | `ProductRepository` (contrato) + `ProductRepositoryImpl` (impl) |
| Nuevo tipo de failure | `fake_store_failure.dart` (agregar a sealed class) |
| Nuevo manejo código HTTP | `HttpStatusCodes` + `HttpResponseHandler._strategies` |

## Convenciones de Código

- **Entities**: Inmutables, sin serialización, constructores `const`
- **Models**: Extienden entities, incluyen `fromJson`/`toEntity()`
- **Repositories**: Retornan `Either`, nunca lanzan excepciones
- **Documentación**: Comentarios `///` en toda la API pública

## Exports de API Pública

```dart
// lib/fake_store_api_client.dart exporta:
export 'src/core/either/either.dart';           // Either, Left, Right
export 'src/domain/entities/entities.dart';     // Product, ProductRating
export 'src/domain/failures/failures.dart';     // Subclases de FakeStoreFailure
export 'src/presentation/presentation.dart';    // UserInterface, MenuOption, ApplicationController
export 'src/domain/repositories/repositories.dart'; // ProductRepository
export 'src/data/datasources/datasources.dart'; // ApiClient, ApiClientImpl, FakeStoreDatasource
export 'src/data/repositories/repositories.dart'; // ProductRepositoryImpl
export 'src/core/network/network.dart';         // HttpResponseHandler, HttpStatusCodes
export 'src/core/constants/app_strings.dart';   // AppStrings
```

## Problema DNS en Emulador Android

Si ocurre `TimeoutException` solo en el emulador Android:

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

También asegurar que `AndroidManifest.xml` tenga `<uses-permission android:name="android.permission.INTERNET" />`.
