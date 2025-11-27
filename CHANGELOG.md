# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2024-01-15

### Agregado

- **Cliente principal `FakeStoreClient`** con métodos para interactuar con la Fake Store API:
  - `getProducts()` - Obtener todos los productos
  - `getProductById(int id)` - Obtener producto por ID
  - `getCategories()` - Obtener todas las categorías
  - `getProductsByCategory(String category)` - Obtener productos por categoría

- **Entidades de dominio**:
  - `Product` - Modelo inmutable de producto con Equatable
  - `ProductRating` - Modelo inmutable de calificación

- **Sistema de manejo de errores funcional**:
  - `FakeStoreFailure` - Clase sellada base para errores
  - `ConnectionFailure` - Error de conexión de red
  - `ServerFailure` - Error del servidor (5xx)
  - `NotFoundFailure` - Recurso no encontrado (404)
  - `InvalidRequestFailure` - Solicitud inválida (4xx)

- **Configuración personalizable**:
  - `FakeStoreConfig` - Configuración de URL base y timeout

- **Aplicación de ejemplo** en Flutter que demuestra:
  - Listado de productos en grid responsivo
  - Filtrado por categorías
  - Vista de detalle de producto
  - Manejo de estados de carga y error
  - Animaciones Hero para transiciones

- **Documentación completa**:
  - README con ejemplos de uso
  - Documentación de código con dartdoc
  - CLAUDE.md para asistentes de IA

- **Tests unitarios** para:
  - Entidades (Product, ProductRating)
  - Failures
  - Configuración

### Arquitectura

- Clean Architecture con separación de capas:
  - **Domain**: Entidades, failures, contratos de repositorio
  - **Data**: Modelos, datasources, implementaciones
  - **Core**: Utilidades compartidas, manejo de errores
  - **Client**: Fachada pública (API)

### Dependencias

- `http: ^1.2.0` - Cliente HTTP
- `dartz: ^0.10.1` - Tipo Either para manejo funcional
- `equatable: ^2.0.5` - Comparación por valor

---

## [1.0.1] - 2025-11-27

### Cambiado

- **Ejemplo simplificado**: Reducido de 16 archivos a 1 solo archivo `main.dart`
- **Removida dependencia de Design System**: El ejemplo ahora usa solo widgets Material
- **Removida dependencia de cached_network_image**: Usa `Image.network` directamente
- **Documentación actualizada**: README del ejemplo y CLAUDE.md reflejan la nueva estructura

### Motivo

El ejemplo ahora sigue las buenas prácticas de paquetes Flutter publicados:
- Un solo archivo `main.dart` que demuestra todas las funcionalidades
- Sin dependencias externas innecesarias
- Código simple y fácil de entender

---

## [Unreleased]

### Planeado

- Soporte para carrito de compras (Cart API)
- Soporte para usuarios (Users API)
- Soporte para autenticación (Login API)
- Cache local con Hive o SharedPreferences
- Interceptores HTTP personalizables
- Soporte para cancelación de requests
