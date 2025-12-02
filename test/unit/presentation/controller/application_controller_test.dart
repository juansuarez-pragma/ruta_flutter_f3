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
          verify(() => mockUI.showLoading('Obteniendo productos...')).called(1);
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
          verify(() => mockUI.showLoading('Obteniendo productos...')).called(1);
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
            () => mockUI.showLoading('Obteniendo producto #5...'),
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
          verify(() => mockUI.showError('ID inválido.')).called(1);
          verifyNever(() => mockRepository.getProductById(any()));
        });

        test('muestra error cuando el producto no existe', () async {
          // Arrange
          when(() => mockUI.promptProductId()).thenAnswer((_) async => 999);
          when(() => mockRepository.getProductById(999)).thenAnswer(
            (_) async => const Left(NotFoundFailure('Producto no encontrado')),
          );

          // Act
          await controller.executeOption(MenuOption.getProductById);

          // Assert
          verify(() => mockUI.showError('Producto no encontrado')).called(1);
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
            () => mockUI.showLoading('Obteniendo categorías...'),
          ).called(1);
          verify(() => mockRepository.getAllCategories()).called(1);
          verify(() => mockUI.showCategories(categories)).called(1);
          verifyNever(() => mockUI.showError(any()));
        });

        test('muestra error cuando el repositorio falla', () async {
          // Arrange
          const failure = ServerFailure('Error del servidor');
          when(
            () => mockRepository.getAllCategories(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          await controller.executeOption(MenuOption.getAllCategories);

          // Assert
          verify(() => mockUI.showError('Error del servidor')).called(1);
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
                'Obteniendo productos de "electronics"...',
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
            verify(() => mockUI.showError('Categoría inválida.')).called(1);
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

      group('invalid', () {
        test('muestra mensaje de error para opción inválida', () async {
          // Act
          await controller.executeOption(MenuOption.invalid);

          // Assert
          verify(() => mockUI.showError('Opción inválida.')).called(1);
        });
      });
    });

    group('run', () {
      test('muestra bienvenida, ejecuta menú y muestra despedida', () async {
        // Arrange
        when(
          () => mockUI.showMainMenu(),
        ).thenAnswer((_) async => MenuOption.exit);

        // Act
        await controller.run();

        // Assert
        verify(() => mockUI.showWelcome('Bienvenido a Fake Store')).called(1);
        verify(() => mockUI.showMainMenu()).called(1);
        verify(() => mockUI.showGoodbye()).called(1);
        expect(onExitCalled, isTrue);
      });

      test('ejecuta múltiples opciones hasta seleccionar exit', () async {
        // Arrange
        var callCount = 0;
        final products = <Product>[createTestProduct()];
        final categories = ['electronics'];

        when(() => mockUI.showMainMenu()).thenAnswer((_) async {
          callCount++;
          switch (callCount) {
            case 1:
              return MenuOption.getAllProducts;
            case 2:
              return MenuOption.getAllCategories;
            default:
              return MenuOption.exit;
          }
        });

        when(
          () => mockRepository.getAllProducts(),
        ).thenAnswer((_) async => Right(products));
        when(
          () => mockRepository.getAllCategories(),
        ).thenAnswer((_) async => Right(categories));

        // Act
        await controller.run();

        // Assert
        verify(() => mockUI.showMainMenu()).called(3);
        verify(() => mockUI.showProducts(products)).called(1);
        verify(() => mockUI.showCategories(categories)).called(1);
        verify(() => mockUI.showGoodbye()).called(1);
      });

      test('maneja opción inválida y continúa el bucle', () async {
        // Arrange
        var callCount = 0;
        when(() => mockUI.showMainMenu()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) return MenuOption.invalid;
          return MenuOption.exit;
        });

        // Act
        await controller.run();

        // Assert
        verify(
          () => mockUI.showError('Opción inválida. Intenta de nuevo.'),
        ).called(1);
        verify(() => mockUI.showMainMenu()).called(2);
        verify(() => mockUI.showGoodbye()).called(1);
      });
    });

    group('constructor', () {
      test('crea controlador sin callback onExit', () async {
        // Arrange
        final controllerWithoutCallback = ApplicationController(
          ui: mockUI,
          repository: mockRepository,
        );

        when(
          () => mockUI.showMainMenu(),
        ).thenAnswer((_) async => MenuOption.exit);

        // Act & Assert - no debería lanzar error
        await controllerWithoutCallback.run();
        verify(() => mockUI.showGoodbye()).called(1);
      });
    });
  });
}
