import 'package:dio/dio.dart';

/// Thin Dio wrapper used by remote data sources.
///
/// Register once in the locator and inject into feature data sources.
/// Example:
/// ```dart
/// final response = await apiClient.get('/v1/latest', queryParameters: {'base': 'USD'});
/// ```
class ApiClient {
  /// Underlying Dio instance (configured with Frankfurter base URL).
  final Dio dio;

  ApiClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.frankfurter.dev',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                headers: const {
                  'Accept': 'application/json',
                },
              ),
            );

  /// Performs a GET request against [path].
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<dynamic>(path, queryParameters: queryParameters);
  }
}
