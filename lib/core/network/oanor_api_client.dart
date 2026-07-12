import 'package:dio/dio.dart';

import 'package:currency_converter/core/constants/app_constants.dart';

/// Dio wrapper for the Oanor Iran Rial Market API (free-market / bazaar rates).
///
/// Used only to override IRR — Frankfurter remains the source for other FX.
///
/// Example:
/// ```dart
/// final response = await oanorApiClient.get('/v1/currencies');
/// ```
class OanorApiClient {
  /// Underlying Dio instance pointed at `api.oanor.com/irr-api`.
  final Dio dio;

  /// Builds a client with the project [AppConstants.oanorApiKey].
  ///
  /// Useful when registering a singleton in GetIt:
  /// `locator.registerLazySingleton(() => OanorApiClient());`
  OanorApiClient({Dio? dio, String? apiKey})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.oanorBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
                headers: {
                  'Accept': 'application/json',
                  // Oanor authenticates every call with this marketplace header.
                  'x-oanor-key': apiKey ?? AppConstants.oanorApiKey,
                },
              ),
            );

  /// Performs a GET against an irr-api path (e.g. `/v1/currencies`).
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<dynamic>(path, queryParameters: queryParameters);
  }
}
