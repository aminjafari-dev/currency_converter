import 'package:dio/dio.dart';

import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/oanor_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';

/// TGJU free-market IRR fallback (same upstream Oanor documents as `tgju.org`).
///
/// Used when the Oanor marketplace key is not subscribed yet (HTTP 402) so the
/// Home list never shows Frankfurter’s official ~1.37M IRR by mistake.
///
/// Example:
/// ```dart
/// final rates = await TgjuIrrRemoteDataSource(dio: Dio()).getForeignToIrrRates();
/// // rates['USD'] ≈ 1782000
/// ```
class TgjuIrrRemoteDataSource implements OanorIrrRemoteDataSource {
  final Dio dio;

  /// ISO → TGJU indicator slug under `/v1/market/indicator/summary-table-data/`.
  static const Map<String, String> _slugs = {
    'USD': 'price_dollar_rl',
    'EUR': 'price_eur',
    'GBP': 'price_gbp',
    'AED': 'price_aed',
    'TRY': 'price_try',
    'CAD': 'price_cad',
    'AUD': 'price_aud',
    'CHF': 'price_chf',
    'CNY': 'price_cny',
    'JPY': 'price_jpy',
    'RUB': 'price_rub',
  };

  /// Builds a client aimed at `api.tgju.org`.
  TgjuIrrRemoteDataSource({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.tgju.org',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
                headers: const {
                  'Accept': 'application/json',
                  'User-Agent': 'NerkhakCurrencyConverter/1.0',
                },
              ),
            );

  @override
  Future<Map<String, double>> getForeignToIrrRates() async {
    try {
      // Fetch every listed currency in parallel — one row each (latest close).
      final entries = await Future.wait(
        _slugs.entries.map((e) async {
          final close = await _latestClose(e.value);
          if (close == null) return null;
          return MapEntry(e.key, _normalizeClose(e.key, close));
        }),
      );

      final rates = <String, double>{
        for (final e in entries)
          if (e != null) e.key: e.value,
      };

      if (rates.isEmpty || !rates.containsKey('USD')) {
        throw const ServerException('TGJU returned no USD/IRR rate');
      }
      return rates;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch TGJU IRR rates');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HistoricalSeriesModel> getForeignToIrrHistory({
    required String foreignCode,
    required int limit,
    required DateTime start,
    required DateTime end,
  }) async {
    final code = foreignCode.toUpperCase();
    final slug = _slugs[code];
    // Unknown foreign legs cannot be charted from TGJU with this mapping.
    if (slug == null) {
      throw ServerException('TGJU has no history slug for $code');
    }

    final clamped = limit.clamp(1, 365);
    try {
      final response = await dio.get<dynamic>(
        '/v1/market/indicator/summary-table-data/$slug',
        queryParameters: {'length': clamped},
      );
      final root = response.data;
      if (root is! Map) {
        throw const ServerException('Unexpected TGJU history payload');
      }
      final rows = root['data'];
      if (rows is! List || rows.isEmpty) {
        throw const ServerException('TGJU history was empty');
      }

      final dated = <String, double>{};
      for (final row in rows) {
        if (row is! List || row.length < 7) continue;
        final close = _parseNumber(row[3]);
        final rawDate = row[6]?.toString();
        if (close == null || close <= 0 || rawDate == null) continue;
        dated[_toIsoDate(rawDate)] = _normalizeClose(code, close);
      }

      if (dated.isEmpty) {
        throw const ServerException('TGJU history had no usable closes');
      }

      return HistoricalSeriesModel(
        base: code,
        quote: 'IRR',
        startDate: _fmt(start),
        endDate: _fmt(end),
        datedRates: dated,
      );
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch TGJU IRR history');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Reads the newest close from a one-row TGJU summary table.
  Future<double?> _latestClose(String slug) async {
    final response = await dio.get<dynamic>(
      '/v1/market/indicator/summary-table-data/$slug',
      queryParameters: const {'length': 1},
    );
    final root = response.data;
    if (root is! Map) return null;
    final rows = root['data'];
    if (rows is! List || rows.isEmpty) return null;
    final row = rows.first;
    if (row is! List || row.length < 4) return null;
    return _parseNumber(row[3]);
  }

  /// Parses `"1,782,000"` / `1782000` into a double.
  double? _parseNumber(Object? raw) {
    if (raw is num) return raw.toDouble();
    if (raw is! String) return null;
    final cleaned = raw.replaceAll(',', '').replaceAll(' ', '').trim();
    return double.tryParse(cleaned);
  }

  /// TGJU mirrors Oanor’s “JPY (100)” convention — normalize to 1 JPY.
  double _normalizeClose(String code, double close) {
    if (code.toUpperCase() == 'JPY') return close / 100.0;
    return close;
  }

  String _toIsoDate(String raw) {
    if (raw.contains('-') && raw.length >= 10) return raw.substring(0, 10);
    return raw.replaceAll('/', '-');
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
