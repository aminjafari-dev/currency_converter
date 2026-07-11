import 'package:equatable/equatable.dart';

/// Base failure returned on the Left side of Dartz [Either] results.
///
/// Map data-layer exceptions to these types inside repositories, then let
/// BLoCs convert [message] (or a localized key) for the UI.
///
/// Example:
/// ```dart
/// return const Left(ServerFailure('Unable to fetch rates'));
/// ```
abstract class Failure extends Equatable {
  /// Human-readable description (may later be mapped to l10n keys).
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Upstream API / HTTP failure.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Local cache miss or read/write failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Device is offline / no network route.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Domain or input validation failure.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}
