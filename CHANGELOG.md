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

## [1.1.0] - 2025-11-27

### Cambiado

- **Eliminada dependencia `dartz`**: Implementación propia del tipo `Either<L, R>` en `lib/src/core/either/either.dart`
- **Eliminada dependencia `equatable`**: Implementación manual de `==` y `hashCode` en entidades y failures
- **Dependencias reducidas**: De 3 dependencias (http, dartz, equatable) a solo 1 (http)

### Agregado

- **`Either<L, R>`**: Tipo propio con soporte completo para manejo funcional de errores:
  - `fold()` para pattern matching
  - `map()` y `mapLeft()` para transformaciones
  - `isLeft`, `isRight`, `leftOrNull`, `rightOrNull` para inspección
  - Clases `Left<L, R>` y `Right<L, R>` con igualdad por valor

### Motivo

Al ser un paquete publicable, minimizar dependencias externas:
- Reduce el tamaño del paquete
- Evita conflictos de versiones con otros paquetes
- Mayor control sobre la implementación

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

## [1.2.0] - 2025-11-27

### Agregado

- **`HttpStatusCodes`**: Nueva clase con constantes documentadas para códigos HTTP
  - Métodos utilitarios: `isSuccess()`, `isClientError()`, `isServerError()`
  - Método `getDescription()` para obtener descripción legible del código
- **Información de diagnóstico en excepciones**:
  - `ConnectionException`: Campos `uri` y `originalError` para debugging
  - `ServerException` y `ClientException`: Campo `statusCode` para diagnóstico

### Cambiado

- **`HttpResponseHandler`**: Refactorizado para usar `HttpStatusCodes` en lugar de números mágicos
- **`ApiClientImpl`**: Ahora incluye información de diagnóstico en excepciones

### Documentación

- Agregada documentación a constructores de `Left` y `Right`
- Creado `LIBRARY_BEST_PRACTICES_CHECKPOINT.md` con guía de mejores prácticas
- Creado `AUDIT_REPORT.md` con auditoría completa del paquete
- Actualizado `CLAUDE.md` con documentación de nuevas clases

### Corregido

- Archivo `LICENSE` ahora contiene licencia MIT válida (antes era placeholder)
- Formato de código aplicado con `dart format`

---

## [1.3.0] - 2025-12-02

### Agregado

- **Patrón Ports & Adapters (Arquitectura Hexagonal)**:
  - `UserInterface`: Contrato abstracto para interfaces de usuario
  - `UserInput`: Contrato para entrada de usuario
  - `MessageOutput`: Contrato para mensajes de salida
  - `ProductOutput`: Contrato para mostrar productos
  - `CategoryOutput`: Contrato para mostrar categorías
  - `MenuOption`: Enum con opciones del menú de la aplicación
  - `ApplicationController`: Orquestador que coordina UI y repositorio

- **Exports públicos ampliados**:
  - `presentation.dart`: Contratos y controlador
  - `repositories.dart`: Contrato e implementación de repositorio
  - `datasources.dart`: ApiClient, ApiClientImpl, FakeStoreDatasource
  - `network.dart`: HttpResponseHandler, HttpStatusCodes

- **Ejemplo refactorizado**:
  - `FlutterUserInterface`: Adapter que implementa `UserInterface` para Flutter
  - Uso de `ApplicationController` con inyección de dependencias
  - Diálogo informativo sobre la arquitectura hexagonal

- **Tests nuevos**:
  - 16 tests para `ApplicationController`
  - Tests de integración con mocks para `UserInterface`

### Cambiado

- Ejemplo ahora demuestra el patrón Ports & Adapters en acción
- Documentación actualizada en CLAUDE.md

---

## [Unreleased]

### Planeado

- Soporte para carrito de compras (Cart API)
- Soporte para usuarios (Users API)
- Soporte para autenticación (Login API)
- Cache local con Hive o SharedPreferences
- Interceptores HTTP personalizables
- Soporte para cancelación de requests
- Soporte para plataforma Web (import condicional de dart:io)
