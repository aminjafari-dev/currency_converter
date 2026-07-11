import 'package:dio/dio.dart';

import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/api_client.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';

/// Remote contract for Frankfurter FX endpoints (v1 API).
///
/// Example:
/// ```dart
/// final latest = await remote.getLatestRates(base: 'USD');
/// ```
abstract class RatesRemoteDataSource {
  Future<RateSnapshotModel> getLatestRates({
    required String base,
    List<String>? symbols,
  });

  Future<HistoricalSeriesModel> getHistoricalSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  });

  Future<List<CurrencyModel>> getSupportedCurrencies();
}

/// Frankfurter implementation of [RatesRemoteDataSource].
///
/// Uses the stable v1 API:
/// - `GET /v1/latest`
/// - `GET /v1/{start}..{end}`
/// - `GET /v1/currencies`
class FrankfurterRemoteDataSource implements RatesRemoteDataSource {
  final ApiClient apiClient;

  FrankfurterRemoteDataSource({required this.apiClient});

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  @override
  Future<RateSnapshotModel> getLatestRates({
    required String base,
    List<String>? symbols,
  }) async {
    try {
      final query = <String, dynamic>{'base': base};
      // Only send symbols when the caller wants a subset.
      if (symbols != null && symbols.isNotEmpty) {
        query['symbols'] = symbols.join(',');
      }
      final response = await apiClient.get('/v1/latest', queryParameters: query);
      return RateSnapshotModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch latest rates');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HistoricalSeriesModel> getHistoricalSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final path = '/v1/${_fmt(start)}..${_fmt(end)}';
      final response = await apiClient.get(
        path,
        queryParameters: {
          'base': base,
          'symbols': quote,
        },
      );
      return HistoricalSeriesModel.fromJson(
        response.data as Map<String, dynamic>,
        quote: quote,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch historical rates');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CurrencyModel>> getSupportedCurrencies() async {
    try {
      final response = await apiClient.get('/v1/currencies');
      final map = response.data as Map<String, dynamic>;
      return CurrencyModel.listFromCurrenciesMap(map);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch currencies');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
