# Fake Store API Client

[![Pub Points](https://img.shields.io/badge/pub%20points-160%2F160-brightgreen)](https://pub.dev/packages/fake_store_api_client)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Cliente Flutter para la [Fake Store API](https://fakestoreapi.com/) con Clean Architecture, patrón Ports & Adapters y manejo funcional de errores.

## Características

- **API simplificada**: Un único punto de entrada con `FakeStoreApi`
- Obtener todos los productos
- Obtener un producto por ID
- Obtener todas las categorías
- Obtener productos por categoría
- Manejo funcional de errores con `Either<Failure, Success>`
- Patrón Ports & Adapters (Arquitectura Hexagonal)
- Soporte multiplataforma: iOS, Android, Windows, macOS, Linux

## Instalación

```yaml
dependencies:
  fake_store_api_client:
    git:
      url: https://github.com/usuario/fake_store_api_client.git
      ref: main
```

## Uso Rápido

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() async {
  // Crear el repositorio (una sola línea)
  final repository = FakeStoreApi.createRepository();

  // Usar el repositorio
  final result = await repository.getAllProducts();

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (products) => print('Productos: ${products.length}'),
  );
}
```

## API Pública

El paquete expone únicamente lo necesario:

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';
```

| Clase | Descripción |
|-------|-------------|
| `FakeStoreApi` | Factory para crear repositorio y controlador |
| `ProductRepository` | Contrato del repositorio |
| `Product`, `ProductRating` | Entidades de dominio |
| `Either`, `Left`, `Right` | Tipo para manejo de errores |
| `FakeStoreFailure` | Clase base de errores (sealed) |
| `ApplicationController` | Controlador para Ports & Adapters |
| `UserInterface` | Contrato de UI a implementar |
| `MenuOption` | Enum de opciones del menú |
| `AppStrings` | Textos centralizados |

## Configuración Personalizada

```dart
final repository = FakeStoreApi.createRepository(
  baseUrl: 'https://mi-api.com',
  timeout: Duration(seconds: 60),
);
```

## Métodos del Repositorio

```dart
// Obtener todos los productos
final products = await repository.getAllProducts();

// Obtener producto por ID
final product = await repository.getProductById(1);

// Obtener categorías
final categories = await repository.getAllCategories();

// Obtener productos por categoría
final electronics = await repository.getProductsByCategory('electronics');
```

## Manejo de Errores

```dart
final result = await repository.getProductById(1);

// Opción 1: fold
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (product) => print('Producto: ${product.title}'),
);

// Opción 2: Pattern matching
switch (result) {
  case Left(value: final failure):
    switch (failure) {
      case ConnectionFailure(): print('Sin conexión');
      case ServerFailure(): print('Error del servidor');
      case NotFoundFailure(): print('No encontrado');
      case InvalidRequestFailure(): print('Solicitud inválida');
    }
  case Right(value: final product):
    print('Producto: ${product.title}');
}
```

## Patrón Ports & Adapters

Para aplicaciones con UI:

```dart
// Implementar el adapter
class FlutterUI implements UserInterface {
  @override
  void showProducts(List<Product> products) {
    // Actualizar UI
  }
  // ... otros métodos
}

// Crear el controlador
final controller = FakeStoreApi.createController(
  ui: FlutterUI(),
);

// Ejecutar operaciones
await controller.executeOption(MenuOption.getAllProducts);
```

## Ejemplo Completo

```bash
cd example
flutter run
```

## Arquitectura

```
lib/
├── fake_store_api_client.dart  # API pública (único punto de entrada)
└── src/                         # Implementación privada
    ├── fake_store_api.dart      # Factory principal
    ├── presentation/            # Ports & Adapters
    ├── domain/                  # Entidades y contratos
    ├── data/                    # Implementaciones
    └── core/                    # Utilidades
```

> **Nota:** Todo el código en `lib/src/` es privado. Solo se expone lo definido en `lib/fake_store_api_client.dart`.

## Documentación

Ver [CLAUDE.md](CLAUDE.md) para arquitectura detallada y guía de desarrollo.

## Licencia

MIT License
