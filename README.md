# Fake Store API Client

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-green.svg)]()

Cliente Flutter para [Fake Store API](https://fakestoreapi.com/) con manejo funcional de errores.

## Instalación

```yaml
dependencies:
  fake_store_api_client: ^1.0.0
```

O ejecuta:

```bash
flutter pub add fake_store_api_client
```

## Uso

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

final repository = FakeStoreApi.createRepository();

final result = await repository.getAllProducts();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('${products.length} productos'),
);
```

## API

| Método | Retorno |
|--------|---------|
| `getAllProducts()` | `Either<Failure, List<Product>>` |
| `getProductById(id)` | `Either<Failure, Product>` |
| `getAllCategories()` | `Either<Failure, List<String>>` |
| `getProductsByCategory(cat)` | `Either<Failure, List<Product>>` |

## Manejo de Errores

```dart
switch (result) {
  case Left(value: ConnectionFailure()): // Sin conexión
  case Left(value: ServerFailure()):     // Error 5xx
  case Left(value: NotFoundFailure()):   // Error 404
  case Left(value: InvalidRequestFailure()): // Error 4xx
  case Right(value: final data):         // Éxito
}
```

## Ejemplo

```bash
cd example && flutter run
```

## Licencia

MIT
