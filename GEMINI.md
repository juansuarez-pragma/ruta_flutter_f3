# Información del Proyecto para Gemini

Este documento proporciona un resumen del proyecto `fake_store_api_client` y su entorno, diseñado para ser utilizado como contexto instruccional para futuras interacciones con Gemini.

## 1. Descripción General del Proyecto

`fake_store_api_client` es un cliente de Flutter para interactuar con la [Fake Store API](https://fakestoreapi.com/). El proyecto sigue los principios de la Clean Architecture y se enfoca en el manejo funcional de errores utilizando `Either<Failure, Success>`. No utiliza generación de código para el parseo de JSON, realizándolo de forma manual.

### Características Principales:

*   **Clean Architecture:** Separación clara de capas (dominio, datos, cliente, core).
*   **Manejo Funcional de Errores:** Implementación con `dartz` para un manejo robusto de errores.
*   **Modelos Inmutables:** Uso de `equatable` para comparación de objetos por valor.
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

void main() async {
  final client = FakeStoreClient();

  final result = await client.getProducts();

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (products) {
      print('Se encontraron ${products.length} productos');
      for (final product in products) {
        print('- ${product.title}: \$${product.price}');
      }
    },
  );

  client.dispose();
}
```

### 2.3. Ejecución del Ejemplo Completo

El proyecto incluye un directorio `example/` con una aplicación Flutter que demuestra el uso del cliente API.

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

El paquete sigue una estructura de Clean Architecture con las siguientes capas principales dentro de `lib/src/`:

*   **`client/`**: La fachada pública del cliente API.
*   **`domain/`**: Contiene las entidades, casos de uso (si los hubiera) y contratos de repositorio.
*   **`data/`**: Implementaciones de los repositorios y fuentes de datos (datasources).
*   **`core/`**: Utilidades compartidas, constantes y manejo de errores.

### 3.2. Manejo de Errores

Se utiliza el paquete `dartz` para un manejo funcional de errores, devolviendo un tipo `Either<FakeStoreFailure, T>`. Los tipos de fallas incluyen `ConnectionFailure`, `ServerFailure`, `NotFoundFailure`, e `InvalidRequestFailure`.

### 3.3. Modelos de Datos

Los modelos de datos (`Product`, `ProductRating`) son inmutables y utilizan `equatable` para simplificar la comparación de instancias. El parseo de JSON se realiza manualmente en las capas de datos.

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
*   **`dartz`**: Proporciona el tipo `Either` para el manejo funcional de errores.
*   **`equatable`**: Facilita la comparación de objetos de valor.
