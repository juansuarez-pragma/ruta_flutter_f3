import 'package:dartz/dartz.dart';

import '../../core/errors/errors.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

/// Implementación del repositorio de productos.
///
/// Coordina entre el datasource y la capa de dominio,
/// transformando modelos en entidades y excepciones en failures.
class ProductRepositoryImpl implements ProductRepository {
  final FakeStoreDatasource _datasource;

  /// Crea una nueva instancia de [ProductRepositoryImpl].
  ///
  /// [datasource] es el datasource para acceder a la API.
  ProductRepositoryImpl({required FakeStoreDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<FakeStoreFailure, List<Product>>> getAllProducts() async {
    return _handleRequest(() async {
      final models = await _datasource.getProducts();
      return _mapModelsToEntities(models);
    });
  }

  @override
  Future<Either<FakeStoreFailure, Product>> getProductById(int id) async {
    return _handleRequest(() async {
      final model = await _datasource.getProductById(id);
      return model.toEntity();
    });
  }

  @override
  Future<Either<FakeStoreFailure, List<String>>> getAllCategories() async {
    return _handleRequest(() async {
      return await _datasource.getCategories();
    });
  }

  @override
  Future<Either<FakeStoreFailure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    return _handleRequest(() async {
      final models = await _datasource.getProductsByCategory(category);
      return _mapModelsToEntities(models);
    });
  }

  /// Mapea una lista de modelos a entidades.
  List<Product> _mapModelsToEntities(List<ProductModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Ejecuta una operación y mapea excepciones a failures.
  ///
  /// Centraliza el manejo de errores para todas las operaciones
  /// del repositorio.
  Future<Either<FakeStoreFailure, T>> _handleRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ClientException catch (e) {
      return Left(InvalidRequestFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
