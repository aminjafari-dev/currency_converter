import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/iran_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';

/// Loads free-market USD→IRR rates from a public Google Drive JSON file.
///
/// Expected payload (append-only updates; newest `at` wins for live rates):
/// ```json
/// {
///   "base": "USD",
///   "quote": "IRR",
///   "updates": [
///     { "at": "2026-07-16T14:30:00Z", "rate": 1795000 }
///   ]
/// }
/// ```
///
/// Example:
/// ```dart
/// final rates = await DriveIrrRemoteDataSource().getForeignToIrrRates();
/// // rates['USD'] == 1886000
/// ```
class DriveIrrRemoteDataSource implements IranIrrRemoteDataSource {
  final Dio dio;
  final String feedUrl;

  /// Builds a client aimed at [AppConstants.usdIrrDriveFeedUrl] by default.
  DriveIrrRemoteDataSource({
    Dio? dio,
    String? feedUrl,
  })  : feedUrl = feedUrl ?? AppConstants.usdIrrDriveFeedUrl,
        dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 30),
                headers: const {
                  'Accept': '*/*',
                  // Some networks/WAF rules reject empty or bot-like agents.
                  'User-Agent': 'NerkhakCurrencyConverter/1.0',
                },
                followRedirects: true,
                maxRedirects: 8,
                // Drive serves `application/octet-stream` — decode UTF-8 ourselves.
                responseType: ResponseType.bytes,
                validateStatus: (status) => status != null && status < 500,
              ),
            );

  @override
  Future<Map<String, double>> getForeignToIrrRates() async {
    try {
      final root = await _fetchFeed();
      final latest = _latestUpdate(root);
      if (latest == null) {
        throw const ServerException('Drive IRR feed has no usable USD rate');
      }
      debugPrint('Drive IRR feed OK: 1 USD = ${latest.rate} IRR @ ${latest.at}');
      return {'USD': latest.rate};
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Drive IRR feed Dio error: $e');
      throw ServerException(e.message ?? 'Failed to fetch Drive IRR feed');
    } catch (e) {
      debugPrint('Drive IRR feed error: $e');
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
    // This feed only stores USD→IRR; other legs are triangulated upstream.
    if (code != 'USD') {
      throw ServerException('Drive IRR feed has no history for $code');
    }

    try {
      final root = await _fetchFeed();
      final daily = _dailyCloses(root);
      if (daily.isEmpty) {
        throw const ServerException('Drive IRR history was empty');
      }

      final startStr = _fmt(start);
      final endStr = _fmt(end);
      final inRange = <String, double>{};
      for (final entry in daily.entries) {
        // Keep points inside the requested chart window (inclusive).
        if (entry.key.compareTo(startStr) < 0) continue;
        if (entry.key.compareTo(endStr) > 0) continue;
        inRange[entry.key] = entry.value;
      }

      if (inRange.isEmpty) {
        throw const ServerException('Drive IRR history had no points in range');
      }

      final clamped = limit.clamp(1, 365);
      final sortedDates = inRange.keys.toList()..sort();
      // Prefer the newest days when the window is wider than [limit].
      final keptDates = sortedDates.length <= clamped
          ? sortedDates
          : sortedDates.sublist(sortedDates.length - clamped);

      return HistoricalSeriesModel(
        base: 'USD',
        quote: 'IRR',
        startDate: startStr,
        endDate: endStr,
        datedRates: {
          for (final d in keptDates) d: inRange[d]!,
        },
      );
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch Drive IRR history');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// GETs the Drive JSON bytes and decodes them into a root map.
  Future<Map<String, dynamic>> _fetchFeed() async {
    final response = await dio.get<List<int>>(feedUrl);
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const ServerException('Drive IRR feed returned an empty body');
    }

    final trimmed = utf8.decode(bytes).trim();
    // Useful when Drive serves an HTML interstitial / login page instead of JSON.
    if (trimmed.startsWith('<!') || trimmed.toLowerCase().startsWith('<html')) {
      throw const ServerException(
        'Drive IRR feed returned HTML — share the file publicly or check VPN',
      );
    }

    final decoded = jsonDecode(trimmed);
    if (decoded is! Map) {
      throw const ServerException('Unexpected Drive IRR feed payload');
    }
    return Map<String, dynamic>.from(decoded);
  }

  /// Newest update by `at` timestamp, or `null` when none parse.
  _IrrUpdate? _latestUpdate(Map<String, dynamic> root) {
    final updates = _parseUpdates(root);
    if (updates.isEmpty) return null;
    updates.sort((a, b) => a.at.compareTo(b.at));
    return updates.last;
  }

  /// One close per calendar day — last update that day wins.
  Map<String, double> _dailyCloses(Map<String, dynamic> root) {
    final updates = _parseUpdates(root);
    updates.sort((a, b) => a.at.compareTo(b.at));
    final daily = <String, double>{};
    for (final u in updates) {
      daily[_fmt(u.at.toUtc())] = u.rate;
    }
    return daily;
  }

  /// Parses `updates[]` into typed rows; skips malformed entries.
  List<_IrrUpdate> _parseUpdates(Map<String, dynamic> root) {
    final raw = root['updates'];
    if (raw is! List) {
      throw const ServerException('Drive IRR feed missing updates list');
    }

    final out = <_IrrUpdate>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final atRaw = item['at']?.toString();
      final rateRaw = item['rate'];
      if (atRaw == null) continue;
      final at = DateTime.tryParse(atRaw);
      final rate = rateRaw is num
          ? rateRaw.toDouble()
          : double.tryParse(rateRaw?.toString() ?? '');
      // Skip zero/negative so a bad edit cannot poison conversion.
      if (at == null || rate == null || rate <= 0) continue;
      out.add(_IrrUpdate(at: at.toUtc(), rate: rate));
    }
    return out;
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

/// One append-only USD→IRR sample from the Drive JSON.
class _IrrUpdate {
  final DateTime at;
  final double rate;

  const _IrrUpdate({required this.at, required this.rate});
}
