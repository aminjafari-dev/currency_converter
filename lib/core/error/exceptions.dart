/// Data-layer exceptions thrown by remote/local data sources.
///
/// Repositories catch these and map them to domain [Failure] types —
/// never leak exceptions past the data layer.
///
/// Example:
/// ```dart
/// throw const ServerException('HTTP 500');
/// ```
class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Server exception']);

  @override
  String toString() => 'ServerException($message)';
}

/// Thrown when local cache read/write fails or is empty.
class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache exception']);

  @override
  String toString() => 'CacheException($message)';
}

/// Thrown when the device has no connectivity.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network exception']);

  @override
  String toString() => 'NetworkException($message)';
}
