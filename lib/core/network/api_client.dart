import 'package:dio/dio.dart';

/// Thin Dio wrapper used by remote data sources.
///
/// Register once in the locator and inject into feature data sources.
/// Example:
/// ```dart
/// final response = await apiClient.get(
///   '/v2/rates',
///   queryParameters: {'base': 'USD'},
/// );
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
                // Long chart ranges (e.g. ALL) can return large v2 row lists.
                receiveTimeout: const Duration(seconds: 45),
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
