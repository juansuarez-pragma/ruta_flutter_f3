# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Unreleased]

- Soporte para Cart, Users y Login API

## [1.0.2] - 2025-12-03

### Agregado

- CI/CD con GitHub Actions
- Pre-commit hook para formateo automático de Dart

## [1.0.1] - 2025-12-03

### Cambiado

- Plataformas soportadas limitadas a Android, iOS y Web (removido Linux, macOS, Windows)

## [1.0.0] - 2025-12-02

### Agregado

- **`FakeStoreApi.createRepository()`**: Factory único para crear el repositorio
- **`ProductRepository`**: Contrato con métodos para la API
  - `getAllProducts()`, `getProductById()`, `getAllCategories()`, `getProductsByCategory()`
- **Entidades**: `Product`, `ProductRating` (inmutables, comparación por valor)
- **`Either<L, R>`**: Implementación propia para manejo funcional de errores
- **Failures**: `ConnectionFailure`, `ServerFailure`, `NotFoundFailure`, `InvalidRequestFailure`
- **App de ejemplo** en Flutter

### Características

- Clean Architecture (domain, data, core)
- URL fija a `https://fakestoreapi.com/`
- Soporte: Android, iOS, Web
