import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/src/core/constants/constants.dart';
import 'package:fake_store_api_client/src/core/errors/errors.dart';
import 'package:fake_store_api_client/src/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_api_client/src/data/models/models.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late FakeStoreDatasource dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = FakeStoreDatasource(apiClient: mockApiClient);
  });

  group('FakeStoreDatasource', () {
    group('getProducts', () {
      test('llama a ApiClient.getList con endpoint correcto', () async {
        // Arrange
        final testModels = createTestProductModelList();
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: ApiEndpoints.products,
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => testModels);

        // Act
        await dataSource.getProducts();

        // Assert
        verify(
          () => mockApiClient.getList<ProductModel>(
            endpoint: ApiEndpoints.products,
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).called(1);
      });

      test('retorna lista de ProductModel desde ApiClient', () async {
        // Arrange
        final testModels = createTestProductModelList(count: 3);
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await dataSource.getProducts();

        // Assert
        expect(result, testModels);
        expect(result.length, 3);
      });

      test('propaga excepciones del ApiClient', () async {
        // Arrange
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenThrow(const ServerException());

        // Act & Assert
        expect(() => dataSource.getProducts(), throwsA(isA<ServerException>()));
      });

      test('retorna lista vacía cuando no hay productos', () async {
        // Arrange
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => <ProductModel>[]);

        // Act
        final result = await dataSource.getProducts();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getProductById', () {
      const testId = 42;

      test(
        'llama a ApiClient.get con endpoint correcto incluyendo ID',
        () async {
          // Arrange
          final testModel = createTestProductModel(id: testId);
          when(
            () => mockApiClient.get<ProductModel>(
              endpoint: ApiEndpoints.productById(testId),
              fromJson: any(named: 'fromJson'),
            ),
          ).thenAnswer((_) async => testModel);

          // Act
          await dataSource.getProductById(testId);

          // Assert
          verify(
            () => mockApiClient.get<ProductModel>(
              endpoint: '/products/$testId',
              fromJson: any(named: 'fromJson'),
            ),
          ).called(1);
        },
      );

      test('retorna ProductModel desde ApiClient', () async {
        // Arrange
        final testModel = createTestProductModel(id: testId);
        when(
          () => mockApiClient.get<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenAnswer((_) async => testModel);

        // Act
        final result = await dataSource.getProductById(testId);

        // Assert
        expect(result, testModel);
        expect(result.id, testId);
      });

      test(
        'construye endpoint dinámico correctamente para diferentes IDs',
        () async {
          // Arrange
          const id1 = 1;
          const id2 = 999;
          final model1 = createTestProductModel(id: id1);
          final model2 = createTestProductModel(id: id2);

          when(
            () => mockApiClient.get<ProductModel>(
              endpoint: '/products/$id1',
              fromJson: any(named: 'fromJson'),
            ),
          ).thenAnswer((_) async => model1);

          when(
            () => mockApiClient.get<ProductModel>(
              endpoint: '/products/$id2',
              fromJson: any(named: 'fromJson'),
            ),
          ).thenAnswer((_) async => model2);

          // Act
          await dataSource.getProductById(id1);
          await dataSource.getProductById(id2);

          // Assert
          verify(
            () => mockApiClient.get<ProductModel>(
              endpoint: '/products/$id1',
              fromJson: any(named: 'fromJson'),
            ),
          ).called(1);
          verify(
            () => mockApiClient.get<ProductModel>(
              endpoint: '/products/$id2',
              fromJson: any(named: 'fromJson'),
            ),
          ).called(1);
        },
      );

      test('propaga NotFoundException cuando producto no existe', () async {
        // Arrange
        when(
          () => mockApiClient.get<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenThrow(const NotFoundException());

        // Act & Assert
        expect(
          () => dataSource.getProductById(testId),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('getCategories', () {
      test(
        'llama a ApiClient.getPrimitiveList con endpoint correcto',
        () async {
          // Arrange
          final testCategories = createTestCategories();
          when(
            () => mockApiClient.getPrimitiveList<String>(
              endpoint: ApiEndpoints.categories,
            ),
          ).thenAnswer((_) async => testCategories);

          // Act
          await dataSource.getCategories();

          // Assert
          verify(
            () => mockApiClient.getPrimitiveList<String>(
              endpoint: ApiEndpoints.categories,
            ),
          ).called(1);
        },
      );

      test('retorna lista de categorías desde ApiClient', () async {
        // Arrange
        final testCategories = createTestCategories();
        when(
          () => mockApiClient.getPrimitiveList<String>(
            endpoint: any(named: 'endpoint'),
          ),
        ).thenAnswer((_) async => testCategories);

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, testCategories);
        expect(result.length, 4);
      });

      test('retorna lista vacía cuando no hay categorías', () async {
        // Arrange
        when(
          () => mockApiClient.getPrimitiveList<String>(
            endpoint: any(named: 'endpoint'),
          ),
        ).thenAnswer((_) async => <String>[]);

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, isEmpty);
      });

      test('propaga excepciones del ApiClient', () async {
        // Arrange
        when(
          () => mockApiClient.getPrimitiveList<String>(
            endpoint: any(named: 'endpoint'),
          ),
        ).thenThrow(const ServerException());

        // Act & Assert
        expect(
          () => dataSource.getCategories(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getProductsByCategory', () {
      const testCategory = 'electronics';

      test('llama a ApiClient.getList con endpoint de categoría', () async {
        // Arrange
        final testModels = createTestProductModelList();
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: ApiEndpoints.productsByCategory(testCategory),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => testModels);

        // Act
        await dataSource.getProductsByCategory(testCategory);

        // Assert
        verify(
          () => mockApiClient.getList<ProductModel>(
            endpoint: '/products/category/$testCategory',
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).called(1);
      });

      test('retorna lista de productos de la categoría', () async {
        // Arrange
        final testModels = createTestProductModelList(count: 2);
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await dataSource.getProductsByCategory(testCategory);

        // Assert
        expect(result, testModels);
        expect(result.length, 2);
      });

      test('retorna lista vacía cuando categoría no tiene productos', () async {
        // Arrange
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenAnswer((_) async => <ProductModel>[]);

        // Act
        final result = await dataSource.getProductsByCategory(testCategory);

        // Assert
        expect(result, isEmpty);
      });

      test('propaga excepciones del ApiClient', () async {
        // Arrange
        when(
          () => mockApiClient.getList<ProductModel>(
            endpoint: any(named: 'endpoint'),
            fromJsonList: any(named: 'fromJsonList'),
          ),
        ).thenThrow(const ConnectionException());

        // Act & Assert
        expect(
          () => dataSource.getProductsByCategory(testCategory),
          throwsA(isA<ConnectionException>()),
        );
      });
    });
  });
}
