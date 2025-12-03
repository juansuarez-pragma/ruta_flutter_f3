/// Tipo para manejo funcional de errores.
///
/// - [Left] representa un error/failure
/// - [Right] representa un valor exitoso
///
/// ```dart
/// result.fold(
///   (error) => print('Error: $error'),
///   (value) => print('Resultado: $value'),
/// );
/// ```
sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
  bool get isLeft;
  bool get isRight;
  L? get leftOrNull;
  R? get rightOrNull;
  Either<L, T> map<T>(T Function(R right) f);
  Either<T, R> mapLeft<T>(T Function(L left) f);
}

/// Representa el lado izquierdo (error/failure) de [Either].
final class Left<L, R> extends Either<L, R> {
  final L value;
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
  final R value;
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
