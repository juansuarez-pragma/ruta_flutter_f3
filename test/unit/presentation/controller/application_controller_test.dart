import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_helpers.dart';

/// Fake para Product para usar con registerFallbackValue.
class FakeProduct extends Fake implements Product {}

void main() {
  late ApplicationController controller;
  late MockUserInterface mockUI;
  late MockProductRepository mockRepository;
  late bool onExitCalled;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockUI = MockUserInterface();
    mockRepository = MockProductRepository();
    onExitCalled = false;

    controller = ApplicationController(
      ui: mockUI,
      repository: mockRepository,
      onExit: () => onExitCalled = true,
    );
  });

  group('ApplicationController', () {
    group('executeOption', () {
      group('getAllProducts', () {
        test('muestra loading, obtiene productos y los muestra', () async {
          // Arrange
          final products = <Product>[
            createTestProduct(),
            createTestProduct(id: 2, title: 'Product 2'),
          ];
          when(
            () => mockRepository.getAllProducts(),
          ).thenAnswer((_) async => Right(products));

          // Act
          await controller.executeOption(MenuOption.getAllProducts);

          // Assert
          verify(
            () => mockUI.showLoading(AppStrings.loadingProducts),
          ).called(1);
          verify(() => mockRepository.getAllProducts()).called(1);
          verify(() => mockUI.showProducts(products)).called(1);
          verifyNever(() => mockUI.showError(any()));
        });

        test('muestra error cuando el repositorio falla', () async {
          // Arrange
          const failure = ConnectionFailure('Sin conexión');
          when(
            () => mockRepository.getAllProducts(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          await controller.executeOption(MenuOption.getAllProducts);

          // Assert
          verify(
            () => mockUI.showLoading(AppStrings.loadingProducts),
          ).called(1);
          verify(() => mockRepository.getAllProducts()).called(1);
          verify(() => mockUI.showError('Sin conexión')).called(1);
          verifyNever(() => mockUI.showProducts(any()));
        });
      });

      group('getProductById', () {
        test('muestra loading, obtiene producto por ID y lo muestra', () async {
          // Arrange
          final product = createTestProduct(id: 5);
          when(() => mockUI.promptProductId()).thenAnswer((_) async => 5);
          when(
            () => mockRepository.getProductById(5),
          ).thenAnswer((_) async => Right(product));

          // Act
          await controller.executeOption(MenuOption.getProductById);

          // Assert
          verify(() => mockUI.promptProductId()).called(1);
          verify(
            () => mockUI.showLoading(AppStrings.loadingProductById(5)),
          ).called(1);
          verify(() => mockRepository.getProductById(5)).called(1);
          verify(() => mockUI.showProduct(product)).called(1);
          verifyNever(() => mockUI.showError(any()));
        });

        test('muestra error cuando el ID es null', () async {
          // Arrange
          when(() => mockUI.promptProductId()).thenAnswer((_) async => null);

          // Act
          await controller.executeOption(MenuOption.getProductById);

          // Assert
          verify(() => mockUI.promptProductId()).called(1);
          verify(() => mockUI.showError(AppStrings.invalidIdError)).called(1);
          verifyNever(() => mockRepository.getProductById(any()));
        });

        test('muestra error cuando el producto no existe', () async {
          // Arrange
          when(() => mockUI.promptProductId()).thenAnswer((_) async => 999);
          when(() => mockRepository.getProductById(999)).thenAnswer(
            (_) async => const Left(
              NotFoundFailure(AppStrings.notFoundProductFailureMessage),
            ),
          );

          // Act
          await controller.executeOption(MenuOption.getProductById);

          // Assert
          verify(
            () => mockUI.showError(AppStrings.notFoundProductFailureMessage),
          ).called(1);
          verifyNever(() => mockUI.showProduct(any()));
        });
      });

      group('getAllCategories', () {
        test('muestra loading, obtiene categorías y las muestra', () async {
          // Arrange
          final categories = ['electronics', 'jewelery', "men's clothing"];
          when(
            () => mockRepository.getAllCategories(),
          ).thenAnswer((_) async => Right(categories));

          // Act
          await controller.executeOption(MenuOption.getAllCategories);

          // Assert
          verify(
            () => mockUI.showLoading(AppStrings.loadingCategories),
          ).called(1);
          verify(() => mockRepository.getAllCategories()).called(1);
          verify(() => mockUI.showCategories(categories)).called(1);
          verifyNever(() => mockUI.showError(any()));
        });

        test('muestra error cuando el repositorio falla', () async {
          // Arrange
          const failure = ServerFailure(AppStrings.serverFailureMessage);
          when(
            () => mockRepository.getAllCategories(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          await controller.executeOption(MenuOption.getAllCategories);

          // Assert
          verify(
            () => mockUI.showError(AppStrings.serverFailureMessage),
          ).called(1);
          verifyNever(() => mockUI.showCategories(any()));
        });
      });

      group('getProductsByCategory', () {
        test(
          'obtiene categorías, solicita selección y muestra productos',
          () async {
            // Arrange
            final categories = ['electronics', 'jewelery'];
            final products = <Product>[
              createTestProduct(category: 'electronics'),
            ];

            when(
              () => mockRepository.getAllCategories(),
            ).thenAnswer((_) async => Right(categories));
            when(
              () => mockUI.promptCategory(categories),
            ).thenAnswer((_) async => 'electronics');
            when(
              () => mockRepository.getProductsByCategory('electronics'),
            ).thenAnswer((_) async => Right(products));

            // Act
            await controller.executeOption(MenuOption.getProductsByCategory);

            // Assert
            verify(() => mockRepository.getAllCategories()).called(1);
            verify(() => mockUI.promptCategory(categories)).called(1);
            verify(
              () => mockUI.showLoading(
                AppStrings.loadingProductsByCategory('electronics'),
              ),
            ).called(1);
            verify(
              () => mockRepository.getProductsByCategory('electronics'),
            ).called(1);
            verify(() => mockUI.showProducts(products)).called(1);
          },
        );

        test('muestra error cuando no hay categorías disponibles', () async {
          // Arrange
          const failure = ServerFailure('Error obteniendo categorías');
          when(
            () => mockRepository.getAllCategories(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          await controller.executeOption(MenuOption.getProductsByCategory);

          // Assert
          verify(
            () => mockUI.showError('Error obteniendo categorías'),
          ).called(1);
          verifyNever(() => mockUI.promptCategory(any()));
        });

        test(
          'muestra error cuando la categoría seleccionada es null',
          () async {
            // Arrange
            final categories = ['electronics', 'jewelery'];
            when(
              () => mockRepository.getAllCategories(),
            ).thenAnswer((_) async => Right(categories));
            when(
              () => mockUI.promptCategory(categories),
            ).thenAnswer((_) async => null);

            // Act
            await controller.executeOption(MenuOption.getProductsByCategory);

            // Assert
            verify(
              () => mockUI.showError(AppStrings.invalidCategoryError),
            ).called(1);
            verifyNever(() => mockRepository.getProductsByCategory(any()));
          },
        );
      });

      group('exit', () {
        test('ejecuta callback onExit cuando se selecciona salir', () async {
          // Act
          await controller.executeOption(MenuOption.exit);

          // Assert
          expect(onExitCalled, isTrue);
        });
      });
    });

    group('constructor', () {
      test('crea controlador sin callback onExit', () async {
        // Arrange
        final controllerWithoutCallback = ApplicationController(
          ui: mockUI,
          repository: mockRepository,
        );

        // Act
        await controllerWithoutCallback.executeOption(MenuOption.exit);

        // Assert - no debería lanzar error
        expect(onExitCalled, isFalse); // El callback no está configurado
      });
    });
  });
}
