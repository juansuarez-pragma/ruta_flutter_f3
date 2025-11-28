/// Tipo que representa un valor que puede ser de dos tipos: [Left] o [Right].
///
/// Se usa para manejo funcional de errores donde:
/// - [Left] representa un error/failure
/// - [Right] representa un valor exitoso
///
/// ## Ejemplo
///
/// ```dart
/// Either<String, int> divide(int a, int b) {
///   if (b == 0) {
///     return Left('No se puede dividir por cero');
///   }
///   return Right(a ~/ b);
/// }
///
/// final result = divide(10, 2);
/// result.fold(
///   (error) => print('Error: $error'),
///   (value) => print('Resultado: $value'),
/// );
/// ```
sealed class Either<L, R> {
  const Either();

  /// Ejecuta [onLeft] si es [Left] o [onRight] si es [Right].
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  /// Retorna `true` si es [Left].
  bool get isLeft;

  /// Retorna `true` si es [Right].
  bool get isRight;

  /// Obtiene el valor de [Left] o `null` si es [Right].
  L? get leftOrNull;

  /// Obtiene el valor de [Right] o `null` si es [Left].
  R? get rightOrNull;

  /// Transforma el valor de [Right] usando [f].
  Either<L, T> map<T>(T Function(R right) f);

  /// Transforma el valor de [Left] usando [f].
  Either<T, R> mapLeft<T>(T Function(L left) f);
}

/// Representa el lado izquierdo (error/failure) de [Either].
final class Left<L, R> extends Either<L, R> {
  /// El valor del error.
  final L value;

  /// Crea una instancia de [Left] con el valor de error dado.
  ///
  /// [value] es el valor que representa el error o failure.
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L? get leftOrNull => value;

  @override
  R? get rightOrNull => null;

  @override
  Either<L, T> map<T>(T Function(R right) f) => Left(value);

  @override
  Either<T, R> mapLeft<T>(T Function(L left) f) => Left(f(value));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Left<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Representa el lado derecho (éxito) de [Either].
final class Right<L, R> extends Either<L, R> {
  /// El valor exitoso.
  final R value;

  /// Crea una instancia de [Right] con el valor exitoso dado.
  ///
  /// [value] es el valor que representa el resultado exitoso.
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L? get leftOrNull => null;

  @override
  R? get rightOrNull => value;

  @override
  Either<L, T> map<T>(T Function(R right) f) => Right(f(value));

  @override
  Either<T, R> mapLeft<T>(T Function(L left) f) => Right(value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Right<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
