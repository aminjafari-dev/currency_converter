import 'package:dartz/dartz.dart';

/// Helpers for working with Dartz [Either] consistently across layers.
///
/// Prefer [when] / [fold] over throwing; never use `async`/`await` inside
/// [fold] callbacks — extract values first, then continue asynchronously.
///
/// Example:
/// ```dart
/// result.when(
///   failure: (f) => showError(f.message),
///   success: (data) => showData(data),
/// );
/// ```
extension EitherExtensions<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;

  L getLeft() => (this as Left<L, R>).value;

  T when<T>({
    required T Function(L failure) failure,
    required T Function(R data) success,
  }) {
    return fold(failure, success);
  }

  Either<L, T> flatMapEither<T>(Either<L, T> Function(R r) f) {
    return fold((l) => Left(l), (r) => f(r));
  }
}
