import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/data/repositories/product_repository_impl.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockFakeStoreDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockFakeStoreDatasource();
    repository = ProductRepositoryImpl(datasource: mockDatasource);
  });

  group('ProductRepositoryImpl', () {
    group('getAllProducts', () {
      test(
        'retorna Right con lista de productos cuando datasource tiene éxito',
        () async {
          // Arrange
          final testModels = createTestProductModelList(count: 3);
          when(
            () => mockDatasource.getProducts(),
          ).thenAnswer((_) async => testModels);

          // Act
          final result = await repository.getAllProducts();

          // Assert
          result.fold(
            (failure) => fail('No debería retornar failure'),
            (products) {
              expect(products.length, 3);
              expect(products[0].id, testModels[0].id);
              expect(products[0].title, testModels[0].title);
            },
          );
          verify(() => mockDatasource.getProducts()).called(1);
        },
      );

      test(
        'retorna Left ServerFailure cuando datasource lanza ServerException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProducts(),
          ).thenThrow(const ServerException());

          // Act
          final result = await repository.getAllProducts();

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test(
        'retorna Left ConnectionFailure cuando datasource lanza ConnectionException',
        () async {
          // Arrange
          when(() => mockDatasource.getProducts()).thenThrow(
            const ConnectionException(),
          );

          // Act
          final result = await repository.getAllProducts();

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ConnectionFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test('convierte modelos a entidades correctamente', () async {
        // Arrange
        final testModels = [
          createTestProductModel(id: 1, title: 'Producto 1', price: 10.0),
          createTestProductModel(id: 2, title: 'Producto 2', price: 20.0),
        ];
        when(
          () => mockDatasource.getProducts(),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await repository.getAllProducts();

        // Assert
        result.fold((failure) => fail('No debería retornar failure'), (
          products,
        ) {
          for (var i = 0; i < products.length; i++) {
            expect(products[i].id, testModels[i].id);
            expect(products[i].title, testModels[i].title);
            expect(products[i].price, testModels[i].price);
          }
        });
      });

      test('retorna Right con lista vacía cuando no hay productos', () async {
        // Arrange
        when(() => mockDatasource.getProducts()).thenAnswer((_) async => []);

        // Act
        final result = await repository.getAllProducts();

        // Assert
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (products) => expect(products, isEmpty),
        );
      });
    });

    group('getProductById', () {
      const testId = 1;

      test(
        'retorna Right con producto cuando datasource tiene éxito',
        () async {
          // Arrange
          final testModel = createTestProductModel(id: testId);
          when(
            () => mockDatasource.getProductById(testId),
          ).thenAnswer((_) async => testModel);

          // Act
          final result = await repository.getProductById(testId);

          // Assert
          result.fold(
            (failure) => fail('No debería retornar failure'),
            (product) {
              expect(product.id, testId);
              expect(product.title, testModel.title);
            },
          );
          verify(() => mockDatasource.getProductById(testId)).called(1);
        },
      );

      test(
        'retorna Left NotFoundFailure cuando datasource lanza NotFoundException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductById(testId),
          ).thenThrow(const NotFoundException());

          // Act
          final result = await repository.getProductById(testId);

          // Assert
          result.fold(
            (failure) => expect(failure, isA<NotFoundFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test(
        'retorna Left ServerFailure cuando datasource lanza ServerException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductById(testId),
          ).thenThrow(const ServerException());

          // Act
          final result = await repository.getProductById(testId);

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test('pasa el ID correcto al datasource', () async {
        // Arrange
        const specificId = 42;
        final testModel = createTestProductModel(id: specificId);
        when(
          () => mockDatasource.getProductById(specificId),
        ).thenAnswer((_) async => testModel);

        // Act
        await repository.getProductById(specificId);

        // Assert
        verify(() => mockDatasource.getProductById(specificId)).called(1);
      });

      test(
        'retorna Left InvalidRequestFailure cuando datasource lanza ClientException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductById(testId),
          ).thenThrow(const ClientException());

          // Act
          final result = await repository.getProductById(testId);

          // Assert
          result.fold(
            (failure) => expect(failure, isA<InvalidRequestFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );
    });

    group('getAllCategories', () {
      test(
        'retorna Right con lista de categorías cuando datasource tiene éxito',
        () async {
          // Arrange
          final testCategories = createTestCategories();
          when(
            () => mockDatasource.getCategories(),
          ).thenAnswer((_) async => testCategories);

          // Act
          final result = await repository.getAllCategories();

          // Assert
          result.fold(
            (failure) => fail('No debería retornar failure'),
            (categories) => expect(categories, testCategories),
          );
          verify(() => mockDatasource.getCategories()).called(1);
        },
      );

      test(
        'retorna Left ServerFailure cuando datasource lanza ServerException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getCategories(),
          ).thenThrow(const ServerException());

          // Act
          final result = await repository.getAllCategories();

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test('retorna Right con lista vacía cuando no hay categorías', () async {
        // Arrange
        when(
          () => mockDatasource.getCategories(),
        ).thenAnswer((_) async => <String>[]);

        // Act
        final result = await repository.getAllCategories();

        // Assert
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (categories) => expect(categories, isEmpty),
        );
      });
    });

    group('getProductsByCategory', () {
      const testCategory = 'electronics';

      test('retorna Right con lista de productos de la categoría', () async {
        // Arrange
        final testModels = createTestProductModelList(count: 2);
        when(
          () => mockDatasource.getProductsByCategory(testCategory),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await repository.getProductsByCategory(testCategory);

        // Assert
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (products) {
            expect(products.length, 2);
            expect(products[0], isA<Product>());
          },
        );
        verify(
          () => mockDatasource.getProductsByCategory(testCategory),
        ).called(1);
      });

      test(
        'retorna Right con lista vacía cuando categoría está vacía',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductsByCategory(testCategory),
          ).thenAnswer((_) async => []);

          // Act
          final result = await repository.getProductsByCategory(testCategory);

          // Assert
          result.fold(
            (failure) => fail('No debería retornar failure'),
            (products) => expect(products, isEmpty),
          );
        },
      );

      test(
        'retorna Left ServerFailure cuando datasource lanza ServerException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductsByCategory(testCategory),
          ).thenThrow(const ServerException());

          // Act
          final result = await repository.getProductsByCategory(testCategory);

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );

      test(
        'retorna Left ConnectionFailure cuando datasource lanza ConnectionException',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProductsByCategory(testCategory),
          ).thenThrow(const ConnectionException());

          // Act
          final result = await repository.getProductsByCategory(testCategory);

          // Assert
          result.fold(
            (failure) => expect(failure, isA<ConnectionFailure>()),
            (_) => fail('No debería retornar Right'),
          );
        },
      );
    });

    group('manejo de errores inesperados', () {
      test(
        'retorna Left ServerFailure para excepciones desconocidas',
        () async {
          // Arrange
          when(
            () => mockDatasource.getProducts(),
          ).thenThrow(Exception('Error inesperado'));

          // Act
          final result = await repository.getAllProducts();

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.message, contains('Error inesperado'));
            },
            (_) => fail('No debería retornar Right'),
          );
        },
      );
    });
  });
}
