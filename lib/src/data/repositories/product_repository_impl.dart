import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/either/either.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/data/datasources/datasources.dart';
import 'package:fake_store_api_client/src/data/models/models.dart';
import 'package:fake_store_api_client/src/domain/domain.dart';

/// Implementación de [ProductRepository].
class ProductRepositoryImpl implements ProductRepository {
  final FakeStoreDatasource _datasource;

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

  List<Product> _mapModelsToEntities(List<ProductModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

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
      return Left(ServerFailure(ErrorMessages.unexpectedError(e)));
    }
  }
}
