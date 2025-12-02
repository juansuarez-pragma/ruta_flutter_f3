# Información del Proyecto para Gemini

Este documento proporciona un resumen del proyecto `fake_store_api_client` y su entorno, diseñado para ser utilizado como contexto instruccional para futuras interacciones con Gemini.

## 1. Descripción General del Proyecto

`fake_store_api_client` es un cliente de Flutter para interactuar con la [Fake Store API](https://fakestoreapi.com/). El proyecto sigue los principios de la Clean Architecture con patrón Ports & Adapters y se enfoca en el manejo funcional de errores utilizando `Either<Failure, Success>`.

### Características Principales:

*   **Clean Architecture:** Separación clara de capas (dominio, datos, presentación, core).
*   **Patrón Ports & Adapters:** Arquitectura hexagonal para UI intercambiable.
*   **Manejo Funcional de Errores:** Implementación propia de `Either` (sin dependencias externas).
*   **Modelos Inmutables:** Implementación manual de `==` y `hashCode` (sin equatable).
*   **Sin Generación de Código:** Parseo manual de JSON para los modelos de datos.

### Funcionalidades:

*   Obtener todos los productos.
*   Obtener un producto específico por ID.
*   Obtener todas las categorías de productos.
*   Obtener productos filtrados por categoría.

## 2. Construcción y Ejecución

### 2.1. Instalación del Paquete

Para usar este paquete en un proyecto Flutter, agrégalo a las dependencias de tu `pubspec.yaml`:

```yaml
dependencies:
  fake_store_api_client:
    git:
      url: https://github.com/usuario/fake_store_api_client.git
      ref: main
```

O si el paquete está en una ruta local:

```yaml
dependencies:
  fake_store_api_client:
    path: ../fake_store_api_client
```

Luego, ejecuta `flutter pub get` en tu proyecto.

### 2.2. Uso Básico

```dart
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:http/http.dart' as http;

void main() async {
  // Crear infraestructura
  final datasource = FakeStoreDatasource(
    apiClient: ApiClientImpl(
      client: http.Client(),
      baseUrl: 'https://fakestoreapi.com',
      timeout: Duration(seconds: 30),
      responseHandler: HttpResponseHandler(),
    ),
  );
  final repository = ProductRepositoryImpl(datasource: datasource);

  // Usar el repositorio
  final result = await repository.getAllProducts();

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (products) {
      print('Se encontraron ${products.length} productos');
      for (final product in products) {
        print('- ${product.title}: \$${product.price}');
      }
    },
  );
}
```

### 2.3. Ejecución del Ejemplo Completo

El proyecto incluye un directorio `example/` con una aplicación Flutter que demuestra el uso del cliente API con el patrón Ports & Adapters.

Para ejecutar el ejemplo:

1.  Navega al directorio `example`:
    ```bash
    cd example
    ```
2.  Instala las dependencias:
    ```bash
    flutter pub get
    ```
3.  Ejecuta la aplicación (por ejemplo, en Chrome):
    ```bash
    flutter run -d chrome
    ```

## 3. Convenciones de Desarrollo

### 3.1. Arquitectura

El paquete sigue una estructura de Clean Architecture con Ports & Adapters dentro de `lib/src/`:

*   **`presentation/`**: Patrón Ports & Adapters (contratos de UI y ApplicationController).
*   **`domain/`**: Contiene las entidades, failures y contratos de repositorio.
*   **`data/`**: Implementaciones de los repositorios, modelos y datasources.
*   **`core/`**: Utilidades compartidas, constantes, Either propio y manejo HTTP.

### 3.2. Manejo de Errores

Se utiliza una implementación propia de `Either<L, R>` para un manejo funcional de errores, devolviendo un tipo `Either<FakeStoreFailure, T>`. Los tipos de fallas incluyen `ConnectionFailure`, `ServerFailure`, `NotFoundFailure`, e `InvalidRequestFailure`.

### 3.3. Modelos de Datos

Los modelos de datos (`Product`, `ProductRating`) son inmutables con implementación manual de `==` y `hashCode`. El parseo de JSON se realiza manualmente en las capas de datos.

### 3.4. Análisis de Código

El proyecto utiliza `analysis_options.yaml` para definir las reglas de linting, asegurando la consistencia y calidad del código.

## 4. Troubleshooting

### Error de `TimeoutException` en Android Emulator

Si la aplicación experimenta un `TimeoutException` solo en el emulador de Android (mientras funciona en otros dispositivos o en Chrome), es probable que sea un problema de resolución DNS del emulador.

**Solución**: Inicia el emulador con los DNS de Google:

```bash
emulator -avd <nombre-avd> -dns-server 8.8.8.8,8.8.4.4
```

Para diagnosticar, puedes verificar la resolución DNS desde el emulador:

```bash
adb -s emulator-5554 shell ping -c 2 fakestoreapi.com
```

## 5. Dependencias Clave

*   **`http`**: Para realizar solicitudes HTTP.

> **Nota:** Este paquete usa implementaciones propias de `Either` y comparación por valor, sin depender de paquetes externos como `dartz` o `equatable`.
