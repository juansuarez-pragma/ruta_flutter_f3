# Checkpoint: Mejores Prácticas para Librerías Dart/Flutter

> **Fecha de investigación:** 2025-11-27
> **Fuentes:** dart.dev, pub.dev, docs.flutter.dev, OWASP, Keep a Changelog

---

## 1. Estructura de Archivos y Directorios

### 1.1 Archivos Obligatorios

| Archivo | Propósito | Requisito pub.dev |
|---------|-----------|-------------------|
| `pubspec.yaml` | Manifiesto del paquete | Obligatorio |
| `LICENSE` | Licencia del código | OSI-approved recomendado (BSD-3) |
| `README.md` | Documentación principal | Requerido para puntos |
| `CHANGELOG.md` | Historial de cambios | Requerido para puntos |

### 1.2 Estructura de Directorios Recomendada

```
package_name/
├── lib/
│   ├── package_name.dart       # Entry point único (barrel file)
│   └── src/                    # Código privado de implementación
│       ├── feature_a/
│       └── feature_b/
├── test/
│   └── *_test.dart             # Tests unitarios
├── example/
│   └── lib/
│       └── main.dart           # Ejemplo ejecutable
├── doc/                        # Documentación adicional (opcional)
├── pubspec.yaml
├── LICENSE
├── README.md
├── CHANGELOG.md
└── analysis_options.yaml
```

### 1.3 Reglas de Importación

| Contexto | Regla |
|----------|-------|
| Dentro de `lib/` | Usar imports relativos |
| Fuera de `lib/` (tests, example) | Usar `package:` |
| Desde otros paquetes | NUNCA importar de `lib/src/` |

**Referencia:** [Package layout conventions](https://dart.dev/tools/pub/package-layout)

---

## 2. API Pública y Exports

### 2.1 Entry Point Único

- Crear UN archivo principal: `lib/<package_name>.dart`
- Exportar solo lo necesario para consumidores
- Ocultar implementación interna con `_` prefix o manteniéndola en `src/`

```dart
// lib/my_package.dart - Entry point
library;

// API Pública
export 'src/client/client.dart';
export 'src/models/models.dart';
export 'src/failures/failures.dart';

// NO exportar:
// - Implementaciones internas
// - Clases helper
// - Excepciones internas (solo Failures)
```

### 2.2 Principios de Diseño de API

| Principio | Descripción |
|-----------|-------------|
| **Minimizar superficie** | Exportar solo lo estrictamente necesario |
| **Nombres claros** | Usar nombres descriptivos y consistentes |
| **Inmutabilidad** | Preferir objetos inmutables en API pública |
| **Const constructors** | Usar cuando sea posible (compromiso de API) |
| **Evitar breaking changes** | Un `const` constructor no puede volverse no-const |

**Referencia:** [Effective Dart: Design](https://dart.dev/effective-dart/design)

---

## 3. Documentación

### 3.1 Requisitos de pub.dev

- **Mínimo 20%** de la API pública debe estar documentada
- Incluir **ejemplo ejecutable** en `example/`

### 3.2 Doc Comments (///)

```dart
/// Breve descripción en primera línea terminando en punto.
///
/// Descripción más detallada después de línea en blanco.
/// Puede incluir múltiples párrafos.
///
/// ## Ejemplo
///
/// ```dart
/// final client = MyClient();
/// final result = await client.getData();
/// ```
///
/// Lanza [NotFoundException] si el recurso no existe.
class MyClient {
  /// Obtiene datos del servidor.
  ///
  /// [id] es el identificador único del recurso.
  /// Retorna [Data] si tiene éxito.
  Future<Data> getData(int id) async { ... }
}
```

### 3.3 Reglas de Documentación

| Regla | Descripción |
|-------|-------------|
| Primera línea | Oración breve y completa con punto final |
| Verbos | Tercera persona para funciones ("Returns", "Throws") |
| Sustantivos | Para variables/getters ("The current user") |
| Referencias | Usar `[NombreClase]` para enlaces automáticos |
| Parámetros | Describir en prosa, no con `@param` |
| Ejemplos | Incluir código ejecutable cuando sea útil |

**Referencia:** [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)

---

## 4. Versionamiento Semántico

### 4.1 Formato: MAJOR.MINOR.PATCH

| Tipo | Cuándo incrementar | Ejemplo |
|------|-------------------|---------|
| **MAJOR** | Breaking changes | 1.2.3 → 2.0.0 |
| **MINOR** | Nueva funcionalidad (compatible) | 1.2.3 → 1.3.0 |
| **PATCH** | Bug fixes (compatible) | 1.2.3 → 1.2.4 |

### 4.2 Pre-1.0.0 (Desarrollo)

- `0.MINOR.PATCH` tiene semántica diferente
- `0.1.0 → 0.2.0` = Breaking change
- `0.1.0 → 0.1.1` = Nueva feature
- `0.1.0 → 0.1.0+1` = Bug fix

### 4.3 Dependencias

```yaml
# CORRECTO: Rangos amplios
dependencies:
  http: ^1.0.0  # >= 1.0.0 < 2.0.0

# EVITAR: Versiones fijas
dependencies:
  http: 1.2.3  # Causa conflictos
```

### 4.4 Lock File

| Tipo de proyecto | Commit `pubspec.lock`? |
|------------------|------------------------|
| Aplicación | SÍ |
| Librería/Paquete | NO |

**Referencia:** [Package versioning](https://dart.dev/tools/pub/versioning)

---

## 5. CHANGELOG.md

### 5.1 Formato Recomendado

```markdown
# Changelog

## [2.0.0] - 2025-01-15

### Breaking Changes
- Removed deprecated `oldMethod()` API

### Added
- New `newMethod()` for improved functionality

### Fixed
- Bug in parsing when input is null (#123)

## [1.2.0] - 2025-01-01

### Added
- Support for custom timeouts
```

### 5.2 Convenciones

| Aspecto | Convención |
|---------|------------|
| Nombre archivo | `CHANGELOG.md` (mayúsculas) |
| Formato fecha | ISO 8601: `YYYY-MM-DD` |
| Headings | Nivel 2 (`##`) para versiones |
| Categorías | Added, Changed, Deprecated, Removed, Fixed, Security |
| Orden | Más reciente primero |

**Referencia:** [Keep a Changelog](https://keepachangelog.com/)

---

## 6. Testing

### 6.1 Estructura de Tests

```
test/
├── unit/
│   ├── models/
│   │   └── product_test.dart
│   └── services/
│       └── api_client_test.dart
├── widget/                    # Solo si hay widgets
└── integration_test/          # Directorio separado
```

### 6.2 Convenciones de Naming

| Elemento | Convención |
|----------|------------|
| Archivo | `*_test.dart` |
| Grupo | `group('ClassName', () { ... })` |
| Test | `test('should do X when Y', () { ... })` |

### 6.3 Cobertura Recomendada

| Tipo | Cantidad | Propósito |
|------|----------|-----------|
| Unit tests | Muchos | Lógica de negocio |
| Widget tests | Moderados | UI components |
| Integration tests | Pocos | Flujos críticos |

```bash
# Generar reporte de cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 6.4 Mocking

- Usar `mocktail` o `mockito` para mocks
- Evitar over-mocking
- Testear comportamiento, no implementación

**Referencia:** [Testing Flutter apps](https://docs.flutter.dev/testing/overview)

---

## 7. Análisis Estático y Linting

### 7.1 analysis_options.yaml Recomendado

```yaml
include: package:flutter_lints/flutter.yaml
# O para paquetes Dart puros:
# include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    missing_return: error
    dead_code: warning

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_print
    - prefer_const_constructors
    - prefer_final_locals
    - sort_constructors_first
    - unawaited_futures
```

### 7.2 Comandos de Análisis

```bash
# Análisis estático
dart analyze
flutter analyze

# Formateo
dart format .
dart format --set-exit-if-changed .  # Para CI

# Verificar pub points localmente
dart pub global activate pana
pana .
```

**Referencia:** [Linter rules](https://dart.dev/tools/linter-rules)

---

## 8. Pub Points - Criterios de Puntuación

### 8.1 Categorías Evaluadas

| Categoría | Puntos | Requisitos |
|-----------|--------|------------|
| **Convenciones de archivo** | ~20 | pubspec.yaml, LICENSE, README.md, CHANGELOG.md |
| **Documentación** | ~20 | ≥20% API documentada + ejemplo |
| **Soporte de plataformas** | ~20 | Declarar plataformas soportadas |
| **Análisis estático** | ~30 | Sin errores, warnings mínimos |
| **Dependencias actualizadas** | ~20 | Compatible con SDKs y deps recientes |
| **Null safety** | ~10 | Migrado completamente |

### 8.2 Verificación Local

```bash
# Instalar pana
dart pub global activate pana

# Ejecutar análisis
pana --no-warning .

# Ver reporte detallado
pana . --json | jq '.scores'
```

**Referencia:** [Package scores & pub points](https://pub.dev/help/scoring)

---

## 9. Seguridad

### 9.1 Checklist de Seguridad para Librerías

| Item | Verificación |
|------|--------------|
| **Sin secretos hardcodeados** | No API keys, tokens, passwords en código |
| **HTTPS obligatorio** | Todas las URLs usan `https://` |
| **Dependencias auditadas** | Sin vulnerabilidades conocidas |
| **Input validation** | Validar todos los inputs externos |
| **Error handling seguro** | No exponer stack traces en producción |

### 9.2 Gestión de Dependencias

```bash
# Verificar dependencias desactualizadas
flutter pub outdated

# Auditar vulnerabilidades (usar herramientas externas)
# - Snyk
# - OWASP Dependency-Check
```

### 9.3 Principios OWASP para Librerías

| Principio | Aplicación |
|-----------|------------|
| **Supply Chain Security** | Verificar integridad de dependencias |
| **Least Privilege** | No pedir permisos innecesarios |
| **Defense in Depth** | Múltiples capas de validación |
| **Secure Defaults** | Configuración segura por defecto |

**Referencia:** [Flutter Security](https://docs.flutter.dev/security)

---

## 10. Arquitectura y Principios SOLID

### 10.1 Clean Architecture para Librerías

```
lib/src/
├── domain/           # Capa de dominio (sin dependencias)
│   ├── entities/     # Objetos de negocio inmutables
│   ├── failures/     # Tipos de error del dominio
│   └── repositories/ # Contratos abstractos
│
├── data/             # Capa de datos
│   ├── models/       # DTOs con serialización
│   ├── datasources/  # Acceso a datos (API, DB)
│   └── repositories/ # Implementaciones concretas
│
└── client/           # Capa de presentación/fachada
    └── my_client.dart # API pública
```

### 10.2 Principios SOLID

| Principio | Aplicación en Librerías |
|-----------|------------------------|
| **S** - Single Responsibility | Una clase, una razón para cambiar |
| **O** - Open/Closed | Extensible sin modificar código existente |
| **L** - Liskov Substitution | Subtipos intercambiables |
| **I** - Interface Segregation | Interfaces pequeñas y específicas |
| **D** - Dependency Inversion | Depender de abstracciones |

### 10.3 Patrones Recomendados

| Patrón | Uso |
|--------|-----|
| **Facade** | Simplificar API pública |
| **Repository** | Abstraer fuentes de datos |
| **Strategy** | Comportamientos intercambiables |
| **Factory** | Creación de objetos complejos |

---

## 11. Compatibilidad Multiplataforma

### 11.1 Declaración de Plataformas

```yaml
# pubspec.yaml
platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

### 11.2 Consideraciones por Plataforma

| Aspecto | Recomendación |
|---------|---------------|
| **dart:io** | Evitar en librerías web-compatible |
| **dart:html** | Solo para web |
| **Conditional imports** | Para código platform-specific |
| **Platform checks** | `kIsWeb`, `Platform.isAndroid`, etc. |

### 11.3 Ejemplo de Import Condicional

```dart
// Archivo: platform_client.dart
export 'platform_client_stub.dart'
    if (dart.library.io) 'platform_client_io.dart'
    if (dart.library.html) 'platform_client_web.dart';
```

---

## 12. Publicación

### 12.1 Checklist Pre-publicación

- [ ] `dart analyze` sin errores
- [ ] `dart format .` aplicado
- [ ] Tests pasando al 100%
- [ ] README.md completo con ejemplos
- [ ] CHANGELOG.md actualizado
- [ ] LICENSE presente
- [ ] Ejemplo en `example/`
- [ ] pubspec.yaml con metadata completa
- [ ] Version bump según semver
- [ ] `dart pub publish --dry-run` exitoso

### 12.2 Metadata de pubspec.yaml

```yaml
name: my_package
description: >-
  Descripción clara y concisa del paquete (60-180 caracteres).
  Debe explicar qué hace y por qué usarlo.
version: 1.0.0
repository: https://github.com/user/my_package
issue_tracker: https://github.com/user/my_package/issues
documentation: https://user.github.io/my_package/
topics:
  - api-client
  - http
  - networking

environment:
  sdk: ^3.0.0

dependencies:
  http: ^1.0.0

dev_dependencies:
  lints: ^3.0.0
  test: ^1.24.0
  mocktail: ^1.0.0
```

### 12.3 Comandos de Publicación

```bash
# Verificar antes de publicar
dart pub publish --dry-run

# Publicar (requiere autenticación)
dart pub publish
```

**Referencia:** [Publishing packages](https://dart.dev/tools/pub/publishing)

---

## Resumen: Checklist de Calidad

### Archivos y Estructura
- [ ] pubspec.yaml con metadata completa
- [ ] LICENSE (BSD-3 recomendado)
- [ ] README.md con documentación clara
- [ ] CHANGELOG.md con formato correcto
- [ ] analysis_options.yaml configurado
- [ ] Entry point único en `lib/<package>.dart`
- [ ] Código privado en `lib/src/`
- [ ] Ejemplo en `example/`

### Código y API
- [ ] API pública mínima y bien definida
- [ ] ≥20% de API documentada con `///`
- [ ] Nombres claros y consistentes
- [ ] Inmutabilidad preferida
- [ ] Sin warnings de análisis
- [ ] Formateo con `dart format`

### Testing
- [ ] Tests unitarios para lógica crítica
- [ ] Coverage reportado
- [ ] Tests pasan en CI

### Versionamiento
- [ ] Semantic versioning respetado
- [ ] CHANGELOG actualizado
- [ ] No commit de pubspec.lock

### Seguridad
- [ ] Sin secretos en código
- [ ] HTTPS para todas las URLs
- [ ] Dependencias actualizadas
- [ ] Input validation

---

**Fuentes:**
- [Effective Dart](https://dart.dev/effective-dart)
- [Package layout conventions](https://dart.dev/tools/pub/package-layout)
- [pub.dev Scoring](https://pub.dev/help/scoring)
- [Flutter Testing](https://docs.flutter.dev/testing/overview)
- [Keep a Changelog](https://keepachangelog.com/)
