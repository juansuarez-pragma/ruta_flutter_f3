# GEMINI.md

Contexto para Gemini AI sobre este repositorio.

## Idioma

- **Respuestas, comentarios y documentación**: Español
- **Commits**: Inglés con Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`)

## Proyecto

Cliente Flutter exclusivo para [Fake Store API](https://fakestoreapi.com/). URL fija, no configurable.

## Comandos

```bash
flutter pub get                                    # Dependencias
flutter test                                       # Tests
dart format . && dart analyze && flutter test      # Pre-commit
cd example && flutter run                          # App ejemplo
```

## Estructura

```
lib/
├── fake_store_api_client.dart    # API pública (único export)
└── src/                          # Privado
    ├── fake_store_api.dart       # Factory: FakeStoreApi.createRepository()
    ├── domain/                   # Entidades, failures, contratos
    ├── data/                     # Implementaciones, models, datasources
    └── core/                     # Either, errores HTTP, constantes
```

## Uso

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';

final repository = FakeStoreApi.createRepository();
final result = await repository.getAllProducts();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (products) => print('Productos: ${products.length}'),
);
```

## API Pública

- `FakeStoreApi.createRepository()` - Factory principal
- `ProductRepository` - Contrato (getAllProducts, getProductById, getAllCategories, getProductsByCategory)
- `Product`, `ProductRating` - Entidades
- `Either`, `Left`, `Right` - Manejo funcional de errores
- `FakeStoreFailure` - ConnectionFailure, ServerFailure, NotFoundFailure, InvalidRequestFailure

## Agregar Funcionalidades

| Tarea | Archivos |
|-------|----------|
| Nueva entidad | `domain/entities/` |
| Nuevo endpoint | `core/constants/api_endpoints.dart` |
| Nuevo método | `ProductRepository` + `ProductRepositoryImpl` |
| Exponer clase | `lib/fake_store_api_client.dart` (export show) |

## Convenciones

- **Entities**: Inmutables, `const`
- **Models**: Extienden entities, `fromJson`
- **Repositories**: Retornan `Either`, nunca lanzan excepciones
- **Tests**: Pueden importar de `lib/src/`
