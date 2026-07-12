import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/oanor_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';

/// Tries **Oanor first**, then falls back to **TGJU** (Oanor’s documented upstream).
///
/// Useful while the Oanor key returns HTTP 402 `subscription_required` — the
/// Home list still gets a real free-market IRR (~1.78M+) instead of Frankfurter.
///
/// Example (DI):
/// ```dart
/// OanorIrrRemoteDataSource(
///   // registered as CascadingIranIrrRemoteDataSource
/// )
/// ```
class CascadingIranIrrRemoteDataSource implements OanorIrrRemoteDataSource {
  final OanorIrrRemoteDataSource primary;
  final OanorIrrRemoteDataSource fallback;

  CascadingIranIrrRemoteDataSource({
    required this.primary,
    required this.fallback,
  });

  @override
  Future<Map<String, double>> getForeignToIrrRates() async {
    try {
      return await primary.getForeignToIrrRates();
    } on ServerException {
      // Oanor not subscribed / unreachable — use TGJU bazaar closes.
      return fallback.getForeignToIrrRates();
    }
  }

  @override
  Future<HistoricalSeriesModel> getForeignToIrrHistory({
    required String foreignCode,
    required int limit,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      return await primary.getForeignToIrrHistory(
        foreignCode: foreignCode,
        limit: limit,
        start: start,
        end: end,
      );
    } on ServerException {
      return fallback.getForeignToIrrHistory(
        foreignCode: foreignCode,
        limit: limit,
        start: start,
        end: end,
      );
    }
  }
}
