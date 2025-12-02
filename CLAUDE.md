# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) para trabajar con el código en este repositorio.

## Descripción del Proyecto

**fake_store_api_client** - Paquete Flutter para la [Fake Store API](https://fakestoreapi.com/) con Clean Architecture, patrón Ports & Adapters y manejo funcional de errores usando `Either<Failure, Success>`.

- Versión: 1.5.0
- SDK: Dart ^3.9.2, Flutter >=3.0.0
- Dependencias: Solo `http`
- Plataformas: iOS, Android, Windows, macOS, Linux (sin soporte Web aún)

## Comandos Esenciales

```bash
# Instalar dependencias
flutter pub get

# Ejecutar tests
flutter test

# Análisis estático (ejecutar antes de commits)
dart format . && dart analyze && flutter test

# Ejecutar app de ejemplo
cd example && flutter run
```

## Arquitectura

### Principio: Un Único Punto de Entrada

Siguiendo las [mejores prácticas de Dart](https://dart.dev/guides/libraries/create-packages):

- **`lib/fake_store_api_client.dart`**: Único archivo de API pública
- **`lib/src/`**: Todo es privado (implementación interna)
- Se usa `export ... show` para exponer solo lo necesario

```
lib/
├── fake_store_api_client.dart    # API pública (único import necesario)
└── src/                           # Privado - no importar directamente
    ├── fake_store_api.dart        # Factory principal
    ├── presentation/              # Patrón Ports & Adapters
    ├── domain/                    # Entidades y contratos
    ├── data/                      # Implementaciones
    └── core/                      # Utilidades
```

### API Pública Expuesta

```dart
// Lo que el consumidor puede usar:
FakeStoreApi          // Factory para crear repositorio/controlador
ProductRepository     // Contrato del repositorio
Product              // Entidad de producto
ProductRating        // Entidad de rating
Either, Left, Right  // Manejo funcional de errores
FakeStoreFailure     // Clase base de errores (sealed)
  ├── ConnectionFailure
  ├── ServerFailure
  ├── NotFoundFailure
  └── InvalidRequestFailure
ApplicationController // Para Ports & Adapters
UserInterface        // Contrato de UI
MenuOption           // Enum de opciones
AppStrings           // Textos centralizados
```

## Uso de la Librería

### Uso Simple (Recomendado)

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

// Una sola línea para obtener el repositorio
final repository = FakeStoreApi.createRepository();

final result = await repository.getAllProducts();
```

### Con Patrón Ports & Adapters

```dart
final controller = FakeStoreApi.createController(
  ui: MiFlutterUserInterface(),
);

await controller.executeOption(MenuOption.getAllProducts);
```

### Con Configuración Personalizada

```dart
final repository = FakeStoreApi.createRepository(
  baseUrl: 'https://mi-api.com',
  timeout: Duration(seconds: 60),
);
```

## Flujo de Manejo de Errores

```
HTTP Response → HttpResponseHandler (lanza Exception)
             → ApiClientImpl (captura, envuelve errores de red)
             → ProductRepositoryImpl._handleRequest (Exception → Failure)
             → Either<FakeStoreFailure, T> (retorna al consumidor)
```

## Patrones Clave

| Patrón | Ubicación |
|--------|-----------|
| **Factory** | `FakeStoreApi` - crea repositorio/controlador |
| **Repository** | Contratos en domain, implementaciones en data |
| **Strategy** | `HttpResponseHandler` - mapea códigos HTTP |
| **Ports & Adapters** | `UserInterface` (port) + `ApplicationController` |

## Agregar Nuevas Funcionalidades

| Tarea | Archivos a modificar |
|-------|----------------------|
| Nueva entidad | `domain/entities/` |
| Nuevo endpoint | `core/constants/api_endpoints.dart` |
| Nuevo método API | `ProductRepository` + `ProductRepositoryImpl` + `FakeStoreApi` |
| Nuevo tipo de failure | `fake_store_failure.dart` |
| Exponer nueva clase | `lib/fake_store_api_client.dart` (agregar export show) |

## Convenciones de Código

- **Entities**: Inmutables, constructores `const`
- **Models**: Extienden entities, incluyen `fromJson`/`toEntity()`
- **Repositories**: Retornan `Either`, nunca lanzan excepciones
- **Exports**: Usar `show` para control explícito de API pública

## Tests

Los tests unitarios importan directamente de `lib/src/` para probar implementaciones internas. Esto es correcto según las mejores prácticas.

```dart
// En tests (permitido importar src/)
import 'package:fake_store_api_client/src/data/repositories/product_repository_impl.dart';
```

## Problema DNS en Emulador Android

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```
