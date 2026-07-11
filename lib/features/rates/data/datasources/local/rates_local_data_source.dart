import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';

/// Local persistence for rate snapshots, catalogs, and selected currencies.
///
/// Example:
/// ```dart
/// await local.cacheLatestRates(model);
/// final cached = await local.getCachedLatestRates();
/// ```
abstract class RatesLocalDataSource {
  Future<void> cacheLatestRates(RateSnapshotModel model, DateTime fetchedAt);
  Future<RateSnapshotModel?> getCachedLatestRates();
  Future<DateTime?> getLastUpdatedAt();

  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
  Future<List<CurrencyModel>?> getCachedCurrencies();

  Future<void> cacheHistoricalSeries(HistoricalSeriesModel model);
  Future<HistoricalSeriesModel?> getCachedHistoricalSeries({
    required String base,
    required String quote,
    required String startDate,
    required String endDate,
  });

  Future<List<SelectedCurrency>> getSelectedCurrencies();
  Future<List<SelectedCurrency>> saveSelectedCurrencies(
    List<SelectedCurrency> list,
  );
}

/// [SharedPreferences]-backed implementation of [RatesLocalDataSource].
class RatesLocalDataSourceImpl implements RatesLocalDataSource {
  final SharedPreferences prefs;

  RatesLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheLatestRates(
    RateSnapshotModel model,
    DateTime fetchedAt,
  ) async {
    final payload = {
      ...model.toJson(),
      'fetchedAt': fetchedAt.toIso8601String(),
    };
    await prefs.setString(AppConstants.ratesCacheKey, jsonEncode(payload));
    await prefs.setString(
      AppConstants.ratesUpdatedAtKey,
      fetchedAt.toIso8601String(),
    );
  }

  @override
  Future<RateSnapshotModel?> getCachedLatestRates() async {
    final raw = prefs.getString(AppConstants.ratesCacheKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return RateSnapshotModel.fromJson(map);
    } catch (_) {
      throw const CacheException('Corrupt rate cache');
    }
  }

  @override
  Future<DateTime?> getLastUpdatedAt() async {
    final raw = prefs.getString(AppConstants.ratesUpdatedAtKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    final list = currencies.map((c) => c.toJson()).toList();
    await prefs.setString('cached_currencies', jsonEncode(list));
  }

  @override
  Future<List<CurrencyModel>?> getCachedCurrencies() async {
    final raw = prefs.getString('cached_currencies');
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException('Corrupt currency cache');
    }
  }

  String _historyKey(String base, String quote, String start, String end) =>
      'hist_${base}_${quote}_${start}_$end';

  @override
  Future<void> cacheHistoricalSeries(HistoricalSeriesModel model) async {
    await prefs.setString(
      _historyKey(model.base, model.quote, model.startDate, model.endDate),
      jsonEncode(model.toJson()),
    );
  }

  @override
  Future<HistoricalSeriesModel?> getCachedHistoricalSeries({
    required String base,
    required String quote,
    required String startDate,
    required String endDate,
  }) async {
    final raw = prefs.getString(_historyKey(base, quote, startDate, endDate));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final dated = <String, double>{};
      final rates = map['rates'] as Map<String, dynamic>? ?? {};
      rates.forEach((k, v) => dated[k] = (v as num).toDouble());
      return HistoricalSeriesModel(
        base: map['base'] as String,
        quote: map['quote'] as String,
        startDate: map['start_date'] as String,
        endDate: map['end_date'] as String,
        datedRates: dated,
      );
    } catch (_) {
      throw const CacheException('Corrupt historical cache');
    }
  }

  @override
  Future<List<SelectedCurrency>> getSelectedCurrencies() async {
    final codes = prefs.getStringList(AppConstants.selectedCurrenciesKey);
    final base =
        prefs.getString(AppConstants.baseCurrencyKey) ??
            AppConstants.defaultBaseCurrency;

    final list = codes ?? AppConstants.defaultSelectedCurrencies;
    // Ensure the base code is present in the list.
    final ensured = {...list, base}.toList();
    return ensured
        .map((c) => SelectedCurrency(code: c, isBase: c == base))
        .toList();
  }

  @override
  Future<List<SelectedCurrency>> saveSelectedCurrencies(
    List<SelectedCurrency> list,
  ) async {
    // Keep at least one currency so Home never becomes empty.
    if (list.isEmpty) {
      throw const CacheException('Cannot save empty currency list');
    }
    final base = list.firstWhere(
      (c) => c.isBase,
      orElse: () => list.first.copyWith(isBase: true),
    );
    final codes = list.map((c) => c.code).toList();
    await prefs.setStringList(AppConstants.selectedCurrenciesKey, codes);
    await prefs.setString(AppConstants.baseCurrencyKey, base.code);
    return list
        .map((c) => SelectedCurrency(code: c.code, isBase: c.code == base.code))
        .toList();
  }
}
