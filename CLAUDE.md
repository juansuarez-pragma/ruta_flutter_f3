# CLAUDE.md - Guía para Asistentes de IA

## Descripción del Proyecto

Este es un **paquete Flutter** que proporciona un cliente para la [Fake Store API](https://fakestoreapi.com/). Está diseñado con Clean Architecture y usa manejo funcional de errores con el tipo `Either<Failure, Success>`.

## Comandos Esenciales

```bash
# Obtener dependencias
flutter pub get

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
dart format .

# Ejecutar ejemplo
cd example && flutter run
```

## Arquitectura del Paquete

```
lib/
├── fake_store_api_client.dart    # API pública (barrel file)
└── src/
    ├── client/                    # Capa de presentación pública
    │   ├── fake_store_client.dart # Fachada principal
    │   └── fake_store_config.dart # Configuración
    │
    ├── domain/                    # Capa de dominio (sin dependencias externas)
    │   ├── entities/              # Entidades inmutables
    │   │   ├── product.dart
    │   │   └── product_rating.dart
    │   ├── failures/              # Jerarquía de errores (sealed class)
    │   │   └── fake_store_failure.dart
    │   └── repositories/          # Contratos abstractos
    │       └── product_repository.dart
    │
    ├── data/                      # Capa de datos
    │   ├── models/                # Modelos con JSON parsing
    │   │   ├── product_model.dart
    │   │   └── product_rating_model.dart
    │   ├── datasources/           # Fuentes de datos
    │   │   ├── fake_store_datasource.dart
    │   │   └── api_client_impl.dart
    │   └── repositories/          # Implementaciones
    │       └── product_repository_impl.dart
    │
    └── core/                      # Utilidades compartidas
        ├── exceptions/            # Excepciones internas
        ├── network/               # Manejo de HTTP
        └── constants/             # Endpoints
```

## Patrones de Diseño Utilizados

1. **Facade Pattern**: `FakeStoreClient` es la fachada que oculta la complejidad interna
2. **Repository Pattern**: Abstracción entre dominio y datos
3. **Strategy Pattern**: `HttpResponseHandler` para manejar diferentes códigos HTTP
4. **Dependency Injection**: Constructor injection en todas las clases

## Convenciones de Código

### Manejo de Errores
```dart
// Siempre usar Either para operaciones que pueden fallar
Future<Either<FakeStoreFailure, T>> operation();

// Pattern matching para consumir el resultado
result.fold(
  (failure) => handleError(failure),
  (success) => handleSuccess(success),
);
```

### Sealed Classes para Failures
```dart
// Los failures usan sealed class para pattern matching exhaustivo
sealed class FakeStoreFailure extends Equatable {
  final String message;
  const FakeStoreFailure(this.message);
}

final class ConnectionFailure extends FakeStoreFailure { ... }
final class ServerFailure extends FakeStoreFailure { ... }
final class NotFoundFailure extends FakeStoreFailure { ... }
final class InvalidRequestFailure extends FakeStoreFailure { ... }
```

### Modelos vs Entidades
- **Entidades** (`Product`, `ProductRating`): Inmutables, sin lógica de serialización
- **Modelos** (`ProductModel`, `ProductRatingModel`): Extienden entidades, incluyen `fromJson`/`toJson`

### Barrel Files
Cada carpeta tiene un barrel file (`*.dart`) que exporta todos sus archivos públicos.

## API Pública

Solo se exporta lo necesario para el consumidor:

```dart
// Desde fake_store_api_client.dart
export 'package:dartz/dartz.dart' show Either, Left, Right;
export 'src/client/client.dart';           // FakeStoreClient, FakeStoreConfig
export 'src/domain/entities/entities.dart'; // Product, ProductRating
export 'src/domain/failures/failures.dart'; // Todos los Failures
```

## Estructura del Ejemplo

```
example/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart                # MaterialApp con soporte dark/light theme
│       ├── core/
│       │   ├── theme/              # AppTheme (puente al Design System)
│       │   └── di/                 # InjectionContainer
│       ├── shared/
│       │   └── widgets/            # Wrappers de widgets del Design System
│       └── features/
│           ├── home/               # Página principal
│           └── products/           # Lista y detalle de productos
```

## Integración con Design System

El ejemplo utiliza el paquete `fake_store_design_system` para mantener consistencia visual. Esta integración sigue el patrón de **composición sobre herencia**.

### Configuración del Tema

El archivo `app_theme.dart` actúa como puente entre la aplicación y el Design System:

```dart
import 'package:fake_store_design_system/fake_store_design_system.dart';

class AppTheme {
  AppTheme._();

  /// Tema claro de la aplicación.
  static ThemeData get lightTheme => FakeStoreTheme.light();

  /// Tema oscuro de la aplicación.
  static ThemeData get darkTheme => FakeStoreTheme.dark();

  /// Obtiene los tokens del sistema de diseño desde el contexto.
  static DSThemeData tokens(BuildContext context) => FakeStoreTheme.of(context);
}
```

### Uso de Tokens del Design System

Para acceder a los tokens de diseño en cualquier widget:

```dart
@override
Widget build(BuildContext context) {
  final tokens = context.tokens; // Extension method del Design System

  return Container(
    color: tokens.colorSurfacePrimary,
    padding: const EdgeInsets.all(DSSpacing.base),
    child: DSText(
      'Texto',
      variant: DSTextVariant.bodyMedium,
      color: tokens.colorTextPrimary,
    ),
  );
}
```

### Componentes del Design System Utilizados

| Componente DS | Componente Local | Uso |
|---------------|------------------|-----|
| `DSAppBar` | - | Barra de navegación |
| `DSButton` | - | Botones de acción |
| `DSIconButton` | - | Botones con iconos |
| `DSText` | - | Textos con tipografía consistente |
| `DSProductCard` | `ProductCard` | Tarjeta de producto (wrapper) |
| `DSProductGrid` | `ProductGrid` | Grid de productos (wrapper) |
| `DSFilterChip` | `CategoryChip` | Chips de categoría (wrapper) |
| `DSCircularLoader` | `LoadingIndicator` | Indicador de carga (wrapper) |
| `DSEmptyState` | `EmptyState` | Estado vacío (wrapper) |
| `DSErrorState` | `ErrorView` | Vista de error (wrapper) |
| `DSBadge` | - | Badges informativos |

### Constantes de Espaciado

El Design System provee constantes de espaciado consistentes:

```dart
// Usar constantes del DS en lugar de valores hardcodeados
const EdgeInsets.all(DSSpacing.base)    // 16.0
const EdgeInsets.all(DSSpacing.sm)      // 8.0
const EdgeInsets.all(DSSpacing.md)      // 12.0
const EdgeInsets.all(DSSpacing.lg)      // 20.0
const EdgeInsets.all(DSSpacing.xl)      // 24.0
const EdgeInsets.all(DSSpacing.xxl)     // 32.0
```

### Soporte de Tema Oscuro

La aplicación soporta tema claro y oscuro automáticamente basado en las preferencias del sistema:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // Automático según el sistema
  // ...
)
```

## Tests

Los tests están en `/test` y cubren:
- Entidades (igualdad, props)
- Failures (mensaje, tipo)
- Configuración (valores por defecto, personalizados)

```bash
# Ejecutar tests con coverage
flutter test --coverage
```

## Notas Importantes

1. **No usar code generation**: El parseo JSON es manual (sin json_serializable)
2. **Inmutabilidad**: Todas las entidades son inmutables con `final` fields
3. **Equatable**: Se usa para comparación por valor en entidades y failures
4. **Dispose**: Siempre llamar `client.dispose()` al terminar
5. **Sealed classes**: Los subtipos de `FakeStoreFailure` deben estar en el mismo archivo
6. **Design System**: El ejemplo usa `fake_store_design_system` - no usar widgets Material directamente, usar los componentes DS
7. **Tema oscuro**: La app soporta tema claro/oscuro automáticamente via `ThemeMode.system`
8. **Tokens de diseño**: Acceder vía `context.tokens` en lugar de hardcodear colores o espaciados

## Extensión del Paquete

Para agregar nuevas funcionalidades:

1. **Nueva entidad**: Agregar en `domain/entities/`, actualizar barrel file
2. **Nuevo endpoint**: Agregar constante en `core/constants/api_endpoints.dart`
3. **Nuevo método en cliente**: Agregar en `FakeStoreClient` y `ProductRepository`
4. **Nuevo tipo de error**: Agregar como subclase de `FakeStoreFailure` (mismo archivo)

## Dependencias

### Paquete Principal

| Paquete | Propósito |
|---------|-----------|
| `http` | Cliente HTTP |
| `dartz` | Tipo Either para manejo funcional |
| `equatable` | Comparación por valor |

### Ejemplo (example/)

| Paquete | Propósito |
|---------|-----------|
| `fake_store_api_client` | Cliente de la API (este paquete) |
| `fake_store_design_system` | Sistema de diseño con componentes y tokens |
| `cached_network_image` | Caché de imágenes de red |

## Troubleshooting

### Problema: TimeoutException en Android Emulator

**Síntomas:**
- La app muestra "Error inesperado: TimeoutException after 0:00:30.000000"
- Los productos no cargan en el emulador Android
- La app funciona correctamente en Chrome (web) y dispositivos físicos

**Causa raíz:**
El emulador Android no puede resolver nombres de dominio (DNS). Aunque el ping a IPs funciona (ej. `8.8.8.8`), no puede resolver `fakestoreapi.com`.

**Diagnóstico:**
```bash
# Verificar conectividad IP (funciona)
adb -s emulator-5554 shell ping -c 2 8.8.8.8

# Verificar resolución DNS (falla)
adb -s emulator-5554 shell ping -c 2 fakestoreapi.com
# Error: "ping: unknown host fakestoreapi.com"
```

**Solución:**
Iniciar el emulador con servidores DNS explícitos de Google:

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

Ejemplo completo:
```bash
# Con cold boot (reinicio limpio)
emulator -avd api33-040825 -dns-server 8.8.8.8,8.8.4.4 -no-snapshot-load
```

**Verificación:**
```bash
# Ahora debería funcionar
adb -s emulator-5556 shell ping -c 2 fakestoreapi.com
# PING fakestoreapi.com (172.67.194.129) ...
```

### Configuración de Android requerida

El ejemplo incluye la configuración necesaria en `AndroidManifest.xml`:

```xml
<manifest>
    <!-- Permiso de Internet -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config">
        ...
    </application>
</manifest>
```

Y el archivo `res/xml/network_security_config.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

## Recursos

- [Fake Store API Docs](https://fakestoreapi.com/docs)
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Either y Functional Error Handling](https://pub.dev/packages/dartz)
