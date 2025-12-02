import 'package:fake_store_api_client/src/domain/entities/entities.dart';

/// Contrato para mostrar datos de productos.
///
/// Define los métodos para visualizar productos,
/// independientemente de la plataforma.
abstract class ProductOutput {
  /// Muestra una lista de productos.
  ///
  /// [products] es la lista de productos a visualizar.
  void showProducts(List<Product> products);

  /// Muestra un producto individual con todos sus detalles.
  ///
  /// [product] es el producto a visualizar.
  void showProduct(Product product);
}
