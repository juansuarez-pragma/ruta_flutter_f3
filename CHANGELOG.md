# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [1.0.0] - 2025-12-02

### Agregado

- **`FakeStoreApi.createRepository()`**: Factory único para crear el repositorio
- **`ProductRepository`**: Contrato con métodos para la API
  - `getAllProducts()`, `getProductById()`, `getAllCategories()`, `getProductsByCategory()`
- **Entidades**: `Product`, `ProductRating` (inmutables, comparación por valor)
- **`Either<L, R>`**: Implementación propia para manejo funcional de errores
- **Failures**: `ConnectionFailure`, `ServerFailure`, `NotFoundFailure`, `InvalidRequestFailure`
- **Diagnóstico en excepciones**: `uri`, `statusCode`, `originalError`
- **App de ejemplo** en Flutter

### Características

- Clean Architecture (domain, data, core)
- Sin dependencias externas excepto `http`
- URL fija a `https://fakestoreapi.com/`
- Soporte: iOS, Android, Windows, macOS, Linux

## [Unreleased]

- Soporte para Cart, Users y Login API
- Soporte para plataforma Web
