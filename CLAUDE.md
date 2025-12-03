# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Idioma

- **Respuestas, comentarios y documentación**: Español
- **Commits**: Inglés con [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`)

## Proyecto

Cliente Flutter exclusivo para [Fake Store API](https://fakestoreapi.com/). URL fija, no configurable.

## Comandos

```bash
flutter pub get                                    # Instalar dependencias
flutter test                                       # Ejecutar tests
dart format . && dart analyze && flutter test      # Pre-commit
cd example && flutter run                          # App de ejemplo
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

## API Pública

```dart
FakeStoreApi.createRepository()   // Factory principal
ProductRepository                 // Contrato
Product, ProductRating            // Entidades
Either, Left, Right               // Manejo de errores
FakeStoreFailure                  // ConnectionFailure, ServerFailure, NotFoundFailure, InvalidRequestFailure
```

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
