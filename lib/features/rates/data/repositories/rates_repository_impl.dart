import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/features/rates/data/datasources/local/rates_local_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/frankfurter_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/iran_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';
import 'package:currency_converter/features/rates/data/utils/irr_rate_overlay.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Concrete [RatesRepository] — single source of truth for rates + selection.
///
/// Online: Frankfurter for global FX, Drive JSON overlay for free-market IRR
/// (USD→IRR, other pairs triangulated), then cache → domain entities.
/// Offline: cached entities or failures.
///
/// Example: `repository.getLatestRates(base: 'USD')` returns a snapshot whose
/// `rates['IRR']` comes from the newest Drive feed update.
class RatesRepositoryImpl implements RatesRepository {
  final RatesRemoteDataSource remoteDataSource;
  final IranIrrRemoteDataSource iranIrrRemoteDataSource;
  final RatesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RatesRepositoryImpl({
    required this.remoteDataSource,
    required this.iranIrrRemoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, RateSnapshot>> getLatestRates({
    required String base,
    List<String>? symbols,
  }) async {
    final upperBase = base.toUpperCase();
    // Frankfurter has no IRT — fetch USD (then overlay IRR and rebase to Toman).
    final frankfurterBase =
        upperBase == AppConstants.iranianTomanCode ? 'USD' : upperBase;

    if (await networkInfo.isConnected) {
      try {
        // Ensure USD is present when we need a triangular Drive IRR bridge.
        final requestSymbols = _symbolsForIrrBridge(
          base: frankfurterBase,
          symbols: symbols,
        );
        final remote = await remoteDataSource.getLatestRates(
          base: frankfurterBase,
          symbols: requestSymbols,
        );
        // Drive feed is required for free-market IRR — do not fall back to
        // Frankfurter’s official ~1.36M IRR (shows as ~136k IRT).
        var overlayed = await _overlayLatestIrr(remote);
        // Always derive IRT = IRR / 10 when a free-market IRR row exists.
        overlayed = attachTomanFromRial(overlayed);
        // User asked for Toman as base — rebase the whole snapshot to 1 IRT.
        if (upperBase == AppConstants.iranianTomanCode) {
          overlayed = rebaseSnapshotToIrt(overlayed);
        }
        final now = DateTime.now();
        await localDataSource.cacheLatestRates(overlayed, now);
        return Right(overlayed.toDomain(fetchedAt: now));
      } on ServerException catch (e) {
        // Soft-fail to a *previous* successful cache (may already include Drive).
        final cached = await _cachedSnapshot();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(e.message));
      }
    }

    final cached = await _cachedSnapshot();
    if (cached != null) return Right(cached);
    return const Left(NetworkFailure());
  }

  /// Replaces Frankfurter IRR with free-market IRR from the Drive USD feed.
  ///
  /// Throws [ServerException] when the feed fails so we never stamp Frankfurter’s
  /// official IRR as bazaar (that is what looked like ~136600 IRT on Home).
  Future<RateSnapshotModel> _overlayLatestIrr(RateSnapshotModel frankfurter) async {
    final foreignToIrr = await iranIrrRemoteDataSource.getForeignToIrrRates();
    return overlayIrrOnSnapshot(
      frankfurter: frankfurter,
      foreignToIrr: foreignToIrr,
    );
  }

  /// Adds `USD` to [symbols] when the base is not USD/IRR/IRT and the caller
  /// filtered the quote list — needed for `base → USD → IRR` triangulation.
  List<String>? _symbolsForIrrBridge({
    required String base,
    List<String>? symbols,
  }) {
    if (symbols == null || symbols.isEmpty) return symbols;
    final upperBase = base.toUpperCase();
    if (upperBase == 'USD' ||
        upperBase == AppConstants.iranianRialCode ||
        upperBase == AppConstants.iranianTomanCode) {
      return symbols;
    }
    if (symbols.map((s) => s.toUpperCase()).contains('USD')) return symbols;
    return [...symbols, 'USD'];
  }

  Future<RateSnapshot?> _cachedSnapshot() async {
    try {
      final model = await localDataSource.getCachedLatestRates();
      if (model == null) return null;
      final fetchedAt = await localDataSource.getLastUpdatedAt();
      return model.toDomain(fetchedAt: fetchedAt ?? DateTime.now());
    } on CacheException {
      return null;
    }
  }

  @override
  Future<Either<Failure, HistoricalSeries>> getHistoricalSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  }) async {
    final startStr = _fmt(start);
    final endStr = _fmt(end);
    final upperBase = base.toUpperCase();
    final upperQuote = quote.toUpperCase();

    if (await networkInfo.isConnected) {
      try {
        final remote = await _historicalWithIrrOverlay(
          base: upperBase,
          quote: upperQuote,
          start: start,
          end: end,
        );
        await localDataSource.cacheHistoricalSeries(remote);
        return Right(remote.toDomain());
      } on ServerException catch (e) {
        final cached = await localDataSource.getCachedHistoricalSeries(
          base: upperBase,
          quote: upperQuote,
          startDate: startStr,
          endDate: endStr,
        );
        if (cached != null) return Right(cached.toDomain());
        return Left(ServerFailure(e.message));
      }
    }

    try {
      final cached = await localDataSource.getCachedHistoricalSeries(
        base: upperBase,
        quote: upperQuote,
        startDate: startStr,
        endDate: endStr,
      );
      if (cached != null) return Right(cached.toDomain());
      return const Left(NetworkFailure());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Prefers Drive USD→IRR history when either side is IRR/IRT; maps IRT ↔ IRR
  /// with the fixed ×10 rule before/after the network call.
  Future<HistoricalSeriesModel> _historicalWithIrrOverlay({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  }) async {
    // IRT is synthetic — always fetch the IRR leg, then scale by 10.
    final fetchBase =
        base == AppConstants.iranianTomanCode ? AppConstants.iranianRialCode : base;
    final fetchQuote =
        quote == AppConstants.iranianTomanCode ? AppConstants.iranianRialCode : quote;

    // Pure Rial ↔ Toman pair — no FX API needed (constant 10 or 0.1).
    if (fetchBase == AppConstants.iranianRialCode &&
        fetchQuote == AppConstants.iranianRialCode) {
      return _rialTomanConstantSeries(
        base: base,
        quote: quote,
        start: start,
        end: end,
      );
    }

    final involvesIrr = fetchBase == AppConstants.iranianRialCode ||
        fetchQuote == AppConstants.iranianRialCode;

    late final HistoricalSeriesModel fetched;
    if (!involvesIrr) {
      fetched = await remoteDataSource.getHistoricalSeries(
        base: fetchBase,
        quote: fetchQuote,
        start: start,
        end: end,
      );
    } else {
      final foreign =
          fetchBase == AppConstants.iranianRialCode ? fetchQuote : fetchBase;
      // Chart chips (1W / 6M / …) need daily points for the full window.
      // A sparse Drive feed (e.g. only 2 days) must not freeze every range.
      fetched = await _irrChartHistoryForRange(
        foreign: foreign,
        fetchBase: fetchBase,
        fetchQuote: fetchQuote,
        start: start,
        end: end,
      );
    }

    return scaleHistoryForToman(
      series: fetched,
      requestedBase: base,
      requestedQuote: quote,
      fetchedBase: fetchBase,
      fetchedQuote: fetchQuote,
    );
  }

  /// Builds an IRR-leg chart series for the selected [start]→[end] window.
  ///
  /// Prefers dense Drive bazaar history when it actually spans the range;
  /// otherwise uses Frankfurter daily history (so 1W ≠ 6M) and lifts the
  /// curve to the latest Drive free-market USD→IRR level when available.
  ///
  /// Example: user picks 6M with only 2 Drive samples → Frankfurter ~180 days,
  /// scaled so the last close ≈ today’s bazaar rate.
  Future<HistoricalSeriesModel> _irrChartHistoryForRange({
    required String foreign,
    required String fetchBase,
    required String fetchQuote,
    required DateTime start,
    required DateTime end,
  }) async {
    // Dense Drive history → use bazaar closes as-is for the chart window.
    try {
      final drive = await _foreignToIrrHistory(
        foreign: foreign,
        start: start,
        end: end,
      );
      if (_driveHistorySpansRange(drive.datedRates, start, end)) {
        return overlayIrrOnHistory(
          foreignToIrrHistory: drive,
          base: fetchBase,
          quote: fetchQuote,
          invertToIrrBase: fetchBase == AppConstants.iranianRialCode,
        );
      }
    } on ServerException {
      // Fall through to Frankfurter full-range history.
    }

    // Sparse / missing Drive → Frankfurter covers the selected chip range.
    var series = await remoteDataSource.getHistoricalSeries(
      base: fetchBase,
      quote: fetchQuote,
      start: start,
      end: end,
    );

    // Align official IRR level to the latest free-market USD→IRR when we can.
    try {
      final market = await iranIrrRemoteDataSource.getForeignToIrrRates();
      final usdMarket = market['USD'];
      if (usdMarket != null && usdMarket > 0) {
        series = await _alignIrrSeriesToMarket(
          series: series,
          fetchBase: fetchBase,
          fetchQuote: fetchQuote,
          usdMarket: usdMarket,
          start: start,
          end: end,
        );
      }
    } on ServerException {
      // Keep official Frankfurter series — chart range still changes.
    }

    return series;
  }

  /// Returns true when Drive daily closes are dense enough for [start]→[end].
  ///
  /// Two fixed samples always fail — that is what made every chip look identical.
  bool _driveHistorySpansRange(
    Map<String, double> dated,
    DateTime start,
    DateTime end,
  ) {
    if (dated.length < 2) return false;

    final daySpan = end.difference(start).inDays.abs() + 1;
    // Short windows need several points; longer windows need ~1 point / 3 days.
    final minPoints =
        daySpan <= 10 ? 5 : (daySpan / 3).floor().clamp(8, 120);
    if (dated.length < minPoints) return false;

    final dates = dated.keys.toList()..sort();
    final first = DateTime.tryParse(dates.first);
    if (first == null) return false;

    // First close must sit near the requested start (allow a week for weekends).
    if (first.isAfter(start.add(const Duration(days: 7)))) return false;
    return true;
  }

  /// Scales an official IRR-leg series so its level matches bazaar [usdMarket].
  Future<HistoricalSeriesModel> _alignIrrSeriesToMarket({
    required HistoricalSeriesModel series,
    required String fetchBase,
    required String fetchQuote,
    required double usdMarket,
    required DateTime start,
    required DateTime end,
  }) async {
    // USD↔IRR: align the last close directly to the Drive bazaar rate.
    if (fetchBase == 'USD' && fetchQuote == AppConstants.iranianRialCode) {
      return alignHistoryToLatestClose(series: series, latestClose: usdMarket);
    }
    if (fetchBase == AppConstants.iranianRialCode && fetchQuote == 'USD') {
      return alignHistoryToLatestClose(
        series: series,
        latestClose: 1.0 / usdMarket,
      );
    }

    // Other legs: apply the same bazaar/official USD→IRR premium ratio.
    // Example: EUR→IRR_official × (USD_bazaar / USD_official) ≈ EUR bazaar.
    final usdOfficialSeries = await remoteDataSource.getHistoricalSeries(
      base: 'USD',
      quote: AppConstants.iranianRialCode,
      start: start,
      end: end,
    );
    final usdDates = usdOfficialSeries.datedRates.keys.toList()..sort();
    if (usdDates.isEmpty || series.datedRates.isEmpty) return series;

    final usdOfficialLast = usdOfficialSeries.datedRates[usdDates.last];
    if (usdOfficialLast == null || usdOfficialLast <= 0) return series;

    final premium = usdMarket / usdOfficialLast;
    final seriesDates = series.datedRates.keys.toList()..sort();
    final lastClose = series.datedRates[seriesDates.last];
    if (lastClose == null || lastClose <= 0) return series;

    if (fetchQuote == AppConstants.iranianRialCode) {
      return alignHistoryToLatestClose(
        series: series,
        latestClose: lastClose * premium,
      );
    }
    if (fetchBase == AppConstants.iranianRialCode) {
      // Inverted pair: premium on IRR means the foreign quote shrinks.
      return alignHistoryToLatestClose(
        series: series,
        latestClose: lastClose / premium,
      );
    }
    return series;
  }

  /// Builds foreign→IRR history from Drive USD closes (+ Frankfurter cross).
  ///
  /// USD uses the feed directly. EUR/GBP/… = (foreign→USD) × (USD→IRR) per day.
  Future<HistoricalSeriesModel> _foreignToIrrHistory({
    required String foreign,
    required DateTime start,
    required DateTime end,
  }) async {
    final daySpan = end.difference(start).inDays.abs() + 1;
    final usdIrr = await iranIrrRemoteDataSource.getForeignToIrrHistory(
      foreignCode: 'USD',
      limit: daySpan,
      start: start,
      end: end,
    );

    final upper = foreign.toUpperCase();
    if (upper == 'USD') return usdIrr;

    final foreignUsd = await remoteDataSource.getHistoricalSeries(
      base: upper,
      quote: 'USD',
      start: start,
      end: end,
    );

    final dated = <String, double>{};
    final usdDates = usdIrr.datedRates.keys.toList()..sort();
    for (final entry in foreignUsd.datedRates.entries) {
      // Use the last known USD→IRR on or before this Frankfurter date.
      final usdClose = _closeOnOrBefore(usdDates, usdIrr.datedRates, entry.key);
      if (usdClose == null || usdClose <= 0 || entry.value <= 0) continue;
      dated[entry.key] = entry.value * usdClose;
    }

    if (dated.isEmpty) {
      throw const ServerException(
        'Could not triangulate foreign→IRR history from Drive USD feed',
      );
    }

    return HistoricalSeriesModel(
      base: upper,
      quote: 'IRR',
      startDate: _fmt(start),
      endDate: _fmt(end),
      datedRates: dated,
    );
  }

  /// Returns the rate for [date] or the nearest earlier day in [sortedDates].
  double? _closeOnOrBefore(
    List<String> sortedDates,
    Map<String, double> rates,
    String date,
  ) {
    if (rates.containsKey(date)) return rates[date];
    String? previous;
    for (final d in sortedDates) {
      if (d.compareTo(date) > 0) break;
      previous = d;
    }
    return previous == null ? null : rates[previous];
  }

  /// Builds a flat IRR↔IRT series using the fixed 10 Rial = 1 Toman rule.
  HistoricalSeriesModel _rialTomanConstantSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  }) {
    final rate = base == AppConstants.iranianTomanCode
        ? AppConstants.rialPerToman.toDouble()
        : 1.0 / AppConstants.rialPerToman;
    final startStr = _fmt(start);
    final endStr = _fmt(end);
    return HistoricalSeriesModel(
      base: base,
      quote: quote,
      startDate: startStr,
      endDate: endStr,
      datedRates: {
        startStr: rate,
        endStr: rate,
      },
    );
  }

  @override
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies() async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDataSource.getSupportedCurrencies();
        final withToman = _ensureTomanInCatalog(remote);
        await localDataSource.cacheCurrencies(withToman);
        return Right(withToman.map((m) => m.toDomain()).toList());
      } on ServerException catch (e) {
        final cached = await localDataSource.getCachedCurrencies();
        if (cached != null) {
          return Right(
            _ensureTomanInCatalog(cached).map((m) => m.toDomain()).toList(),
          );
        }
        return Left(ServerFailure(e.message));
      }
    }

    try {
      final cached = await localDataSource.getCachedCurrencies();
      if (cached != null) {
        return Right(
          _ensureTomanInCatalog(cached).map((m) => m.toDomain()).toList(),
        );
      }
      return const Left(NetworkFailure());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Inserts synthetic IRT into the Frankfurter catalog when missing.
  List<CurrencyModel> _ensureTomanInCatalog(List<CurrencyModel> catalog) {
    final hasIrt = catalog.any(
      (c) => c.code.toUpperCase() == AppConstants.iranianTomanCode,
    );
    if (hasIrt) return catalog;
    final next = [
      ...catalog,
      const CurrencyModel(
        code: AppConstants.iranianTomanCode,
        name: 'Iranian Toman',
      ),
    ]..sort((a, b) => a.code.compareTo(b.code));
    return next;
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> getSelectedCurrencies() async {
    try {
      final list = await localDataSource.getSelectedCurrencies();
      return Right(list);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> addSelectedCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final upper = code.toUpperCase();
      // Skip duplicates.
      if (current.any((c) => c.code == upper)) {
        return Right(current);
      }
      final updated = [
        ...current,
        SelectedCurrency(code: upper),
      ];
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> removeSelectedCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final upper = code.toUpperCase();
      // Never allow an empty list.
      if (current.length <= 1) {
        return const Left(
          ValidationFailure('Keep at least one currency selected'),
        );
      }
      var updated = current.where((c) => c.code != upper).toList();
      // If we removed the base, promote the first remaining item.
      if (!updated.any((c) => c.isBase) && updated.isNotEmpty) {
        updated = [
          updated.first.copyWith(isBase: true),
          ...updated.skip(1).map((c) => c.copyWith(isBase: false)),
        ];
      }
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SelectedCurrency>>> setBaseCurrency(
    String code,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      var upper = code.toUpperCase();
      // IRT is a quote only — never make Toman the baseline row.
      // Example: user taps IRT on Home → keep/set USD as base instead.
      if (upper == AppConstants.iranianTomanCode) {
        upper = AppConstants.defaultBaseCurrency;
      }
      var list = current;
      // Ensure the new base is in the list.
      if (!list.any((c) => c.code == upper)) {
        list = [...list, SelectedCurrency(code: upper)];
      }
      final updated = list
          .map((c) => SelectedCurrency(code: c.code, isBase: c.code == upper))
          .toList();
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Saves [orderedCodes] as the new Home-list order while keeping each
  /// currency's base flag. Rejects lists that are not a permutation of the
  /// current selection so we never silently drop or invent codes.
  ///
  /// Example: user drags EUR above USD → `['EUR', 'USD', 'GBP']`.
  @override
  Future<Either<Failure, List<SelectedCurrency>>> reorderSelectedCurrencies(
    List<String> orderedCodes,
  ) async {
    try {
      final current = await localDataSource.getSelectedCurrencies();
      final byCode = {
        for (final c in current) c.code: c,
      };
      final normalized = orderedCodes.map((c) => c.toUpperCase()).toList();

      // Same length + every code already selected = valid reorder permutation.
      // Useful so a stale UI cannot wipe the user's list with a partial order.
      if (normalized.length != current.length ||
          normalized.toSet().length != normalized.length ||
          !normalized.every(byCode.containsKey)) {
        return const Left(
          ValidationFailure('Invalid currency order'),
        );
      }

      final updated = normalized.map((code) => byCode[code]!).toList();
      final saved = await localDataSource.saveSelectedCurrencies(updated);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastUpdatedAt() async {
    try {
      return Right(await localDataSource.getLastUpdatedAt());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
