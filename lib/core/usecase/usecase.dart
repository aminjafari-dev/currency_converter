import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';

/// Base contract for every domain use case.
///
/// [Type] is the success payload; [Params] is the input (use [NoParams]
/// when none are needed). Always return [Either]<[Failure], [Type]>.
///
/// Example:
/// ```dart
/// class GetLatestRates implements UseCase<RateSnapshot, String> {
///   @override
///   Future<Either<Failure, RateSnapshot>> call(String base) => ...
/// }
/// ```
abstract class UseCase<ResultType, Params> {
  Future<Either<Failure, ResultType>> call(Params params);
}

/// Sentinel params object for use cases that take no arguments.
class NoParams {
  const NoParams();
}
