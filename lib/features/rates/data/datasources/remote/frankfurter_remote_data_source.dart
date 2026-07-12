import 'package:dio/dio.dart';

import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/api_client.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';

/// Remote contract for Frankfurter FX endpoints (v2 API).
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
/// Uses the v2 API (≈165 active currencies from 84 central banks):
/// - `GET /v2/rates?base=&quotes=` — latest (or historical with `from`/`to`)
/// - `GET /v2/currencies` — active currency catalog
///
/// v1 was ECB-only (~30 codes) and omitted IRR, AMD, OMR, etc.
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
      // v2 uses `quotes` (not v1's `symbols`) to filter target currencies.
      if (symbols != null && symbols.isNotEmpty) {
        query['quotes'] = symbols.join(',');
      }
      final response = await apiClient.get('/v2/rates', queryParameters: query);
      final rows = response.data as List<dynamic>;
      return RateSnapshotModel.fromV2List(rows);
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
      final startStr = _fmt(start);
      final endStr = _fmt(end);
      // Same `/v2/rates` resource; `from`/`to` unlock the time-series mode.
      final response = await apiClient.get(
        '/v2/rates',
        queryParameters: {
          'base': base,
          'quotes': quote,
          'from': startStr,
          'to': endStr,
        },
      );
      final rows = response.data as List<dynamic>;
      return HistoricalSeriesModel.fromV2List(
        rows,
        base: base,
        quote: quote,
        startDate: startStr,
        endDate: endStr,
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
      // Default scope is active currencies (~165). Pass `scope=all` for archived.
      final response = await apiClient.get('/v2/currencies');
      final list = response.data as List<dynamic>;
      return CurrencyModel.listFromV2List(list);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch currencies');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
