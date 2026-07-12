import 'package:dio/dio.dart';

import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/oanor_api_client.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';

/// Remote contract for Iran free-market (bazaar) IRR rates via Oanor.
///
/// Example:
/// ```dart
/// final map = await oanor.getForeignToIrrRates();
/// final usdIrr = map['USD']; // e.g. 1816200
/// ```
abstract class OanorIrrRemoteDataSource {
  /// Returns ISO code → IRR amount for **1 unit** of that foreign currency.
  ///
  /// Oanor quotes JPY as “per 100 yen”; this method normalizes to per-1-JPY.
  Future<Map<String, double>> getForeignToIrrRates();

  /// Daily close series for [foreignCode] priced in IRR (1 foreign = rate IRR).
  ///
  /// [limit] is clamped to 1…365 by Oanor.
  Future<HistoricalSeriesModel> getForeignToIrrHistory({
    required String foreignCode,
    required int limit,
    required DateTime start,
    required DateTime end,
  });
}

/// Oanor `irr-api` implementation of [OanorIrrRemoteDataSource].
///
/// Endpoints:
/// - `GET /v1/currencies` — all foreign currencies vs IRR
/// - `GET /v1/history?symbol=&limit=` — daily OHLC (we use `close`)
class OanorIrrRemoteDataSourceImpl implements OanorIrrRemoteDataSource {
  final OanorApiClient apiClient;

  OanorIrrRemoteDataSourceImpl({required this.apiClient});

  /// Oanor prices the yen as “JPY (100)” — divide by 100 so 1 JPY = rate IRR.
  static const Set<String> _perHundredCodes = {'JPY'};

  @override
  Future<Map<String, double>> getForeignToIrrRates() async {
    try {
      final response = await apiClient.get('/v1/currencies');
      return _parseCurrenciesPayload(response.data);
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      // HTTP 402 body is `{ "error": "subscription_required", ... }` — surface it.
      throw ServerException(_dioErrorMessage(e, fallback: 'Failed to fetch Oanor IRR rates'));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Parses `/v1/currencies` JSON into ISO → IRR (per 1 foreign unit).
  Map<String, double> _parseCurrenciesPayload(dynamic root) {
    // Fail loudly when the marketplace rejects the key (e.g. not subscribed).
    if (root is Map && (root['success'] == false || root['error'] != null)) {
      throw ServerException(
        root['message']?.toString() ??
            root['error']?.toString() ??
            'Oanor request failed',
      );
    }
    if (root is! Map) {
      throw const ServerException('Unexpected Oanor currencies payload');
    }

    final data = root['data'];
    if (data is! Map) {
      throw const ServerException('Missing Oanor currencies data');
    }

    final list = data['currencies'];
    if (list is! List) {
      throw const ServerException('Missing Oanor currencies list');
    }

    final rates = <String, double>{};
    for (final item in list) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      final symbol = (map['symbol'] as String?)?.toUpperCase();
      final close = map['close'];
      // Skip gold/crypto rows that sneak in without a usable close.
      if (symbol == null || close is! num || close <= 0) continue;
      rates[symbol] = _normalizeClose(symbol, close.toDouble());
    }

    if (rates.isEmpty) {
      throw const ServerException('Oanor returned no currency rates');
    }
    return rates;
  }

  /// Prefers Oanor’s JSON `message` / `error` over Dio’s generic status text.
  String _dioErrorMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message']?.toString();
      final error = data['error']?.toString();
      if (message != null && message.isNotEmpty) {
        // Useful when status is 402: "Subscribe to this API first."
        if (error != null && error.isNotEmpty) return '$error: $message';
        return message;
      }
      if (error != null && error.isNotEmpty) return error;
    }
    return e.message ?? fallback;
  }

  @override
  Future<HistoricalSeriesModel> getForeignToIrrHistory({
    required String foreignCode,
    required int limit,
    required DateTime start,
    required DateTime end,
  }) async {
    final code = foreignCode.toUpperCase();
    final clampedLimit = limit.clamp(1, 365);

    try {
      final response = await apiClient.get(
        '/v1/history',
        queryParameters: {
          'symbol': code.toLowerCase(),
          'limit': clampedLimit,
        },
      );
      final root = response.data;
      if (root is Map && root['success'] == false) {
        throw ServerException(
          root['message']?.toString() ?? 'Oanor history request failed',
        );
      }
      if (root is! Map) {
        throw const ServerException('Unexpected Oanor history payload');
      }

      final data = root['data'];
      if (data is! Map) {
        throw const ServerException('Missing Oanor history data');
      }

      final history = data['history'];
      if (history is! List) {
        throw const ServerException('Missing Oanor history list');
      }

      final dated = <String, double>{};
      for (final row in history) {
        if (row is! Map) continue;
        final map = Map<String, dynamic>.from(row);
        final rawDate = map['date'] as String?;
        final close = map['close'];
        if (rawDate == null || close is! num || close <= 0) continue;
        final isoDate = _toIsoDate(rawDate);
        dated[isoDate] = _normalizeClose(code, close.toDouble());
      }

      if (dated.isEmpty) {
        throw const ServerException('Oanor history was empty');
      }

      final startStr = _fmt(start);
      final endStr = _fmt(end);
      return HistoricalSeriesModel(
        base: code,
        quote: 'IRR',
        startDate: startStr,
        endDate: endStr,
        datedRates: dated,
      );
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        _dioErrorMessage(e, fallback: 'Failed to fetch Oanor IRR history'),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Converts Oanor instrument close into IRR per **1** unit of [code].
  double _normalizeClose(String code, double close) {
    // Useful when Oanor publishes a 100-unit quote (JPY) so converters stay
    // consistent with Frankfurter’s per-1-unit rate map.
    if (_perHundredCodes.contains(code.toUpperCase())) {
      return close / 100.0;
    }
    return close;
  }

  /// Converts `2026/07/11` → `2026-07-11` for chart / cache ISO dates.
  String _toIsoDate(String raw) {
    if (raw.contains('-') && raw.length >= 10) {
      return raw.substring(0, 10);
    }
    return raw.replaceAll('/', '-');
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
