import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';

/// Pure helpers that replace Frankfurter’s official IRR with free-market IRR.
///
/// [foreignToIrr] maps ISO code → IRR for 1 unit of that foreign currency.
/// The Drive feed typically supplies only `USD`; other bases triangulate via USD.
///
/// Example:
/// ```dart
/// final overlayed = overlayIrrOnSnapshot(
///   frankfurter: snapshot,
///   foreignToIrr: {'USD': 1816200},
/// );
/// ```
RateSnapshotModel overlayIrrOnSnapshot({
  required RateSnapshotModel frankfurter,
  required Map<String, double> foreignToIrr,
}) {
  final base = frankfurter.base.toUpperCase();
  final rates = Map<String, double>.from(frankfurter.rates);

  // When IRR is the base, rebuild every quote as 1 IRR → foreign.
  if (base == 'IRR') {
    for (final entry in foreignToIrr.entries) {
      final irrPerForeign = entry.value;
      if (irrPerForeign <= 0) continue;
      rates[entry.key] = 1.0 / irrPerForeign;
    }

    // Currencies not in the feed: bridge via USD using Frankfurter cross.
    // Useful so AMD/OMR/… still convert when the Home base is IRR.
    final usdIrr = foreignToIrr['USD'];
    final frankUsd = frankfurter.rates['USD'];
    if (usdIrr != null && usdIrr > 0 && frankUsd != null && frankUsd > 0) {
      for (final entry in frankfurter.rates.entries) {
        final code = entry.key.toUpperCase();
        if (code == 'IRR' || foreignToIrr.containsKey(code)) continue;
        // frank Q / frank USD = Q per 1 USD (cross), then scale by 1 IRR in USD.
        rates[code] = (entry.value / frankUsd) / usdIrr;
      }
    }

    rates.remove('IRR');
    return RateSnapshotModel(
      base: base,
      date: frankfurter.date,
      rates: rates,
    );
  }

  // Otherwise stamp rates['IRR'] = how many IRR equal 1 unit of [base].
  final irrPerBase = _irrPerOneUnitOf(
    base: base,
    rates: rates,
    foreignToIrr: foreignToIrr,
  );
  if (irrPerBase != null && irrPerBase > 0) {
    rates['IRR'] = irrPerBase;
  }

  return RateSnapshotModel(
    base: base,
    date: frankfurter.date,
    rates: rates,
  );
}

/// Builds a base↔IRR historical series from a foreign→IRR history feed.
///
/// When [invertToIrrBase] is true, each point is inverted (1 IRR = 1/close foreign).
HistoricalSeriesModel overlayIrrOnHistory({
  required HistoricalSeriesModel foreignToIrrHistory,
  required String base,
  required String quote,
  required bool invertToIrrBase,
}) {
  if (!invertToIrrBase) {
    return HistoricalSeriesModel(
      base: base.toUpperCase(),
      quote: quote.toUpperCase(),
      startDate: foreignToIrrHistory.startDate,
      endDate: foreignToIrrHistory.endDate,
      datedRates: foreignToIrrHistory.datedRates,
    );
  }

  final inverted = <String, double>{};
  foreignToIrrHistory.datedRates.forEach((date, rate) {
    if (rate > 0) inverted[date] = 1.0 / rate;
  });

  return HistoricalSeriesModel(
    base: base.toUpperCase(),
    quote: quote.toUpperCase(),
    startDate: foreignToIrrHistory.startDate,
    endDate: foreignToIrrHistory.endDate,
    datedRates: inverted,
  );
}

/// Returns IRR amount for 1 unit of [base], or `null` when it cannot be derived.
double? _irrPerOneUnitOf({
  required String base,
  required Map<String, double> rates,
  required Map<String, double> foreignToIrr,
}) {
  // Direct hit — feed lists this currency vs IRR (e.g. USD).
  final direct = foreignToIrr[base];
  if (direct != null && direct > 0) return direct;

  // Triangular: 1 base → USD (Frankfurter) → IRR (Drive feed).
  final usdIrr = foreignToIrr['USD'];
  if (usdIrr == null || usdIrr <= 0) return null;

  if (base == 'USD') return usdIrr;

  final usdPerBase = rates['USD'];
  if (usdPerBase == null || usdPerBase <= 0) return null;
  return usdPerBase * usdIrr;
}

/// Attaches synthetic **IRT** (Toman) rates using the fixed 10 Rial = 1 Toman rule.
///
/// Example: after IRR overlay, `rates['IRT'] = rates['IRR'] / 10`.
RateSnapshotModel attachTomanFromRial(RateSnapshotModel snapshot) {
  final base = snapshot.base.toUpperCase();
  final rates = Map<String, double>.from(snapshot.rates);
  const factor = AppConstants.rialPerToman;

  // Base is already Toman — nothing to attach.
  if (base == AppConstants.iranianTomanCode) {
    return snapshot;
  }

  // 1 IRR = 0.1 IRT
  if (base == AppConstants.iranianRialCode) {
    rates[AppConstants.iranianTomanCode] = 1.0 / factor;
    return RateSnapshotModel(
      base: base,
      date: snapshot.date,
      rates: rates,
    );
  }

  final irr = rates[AppConstants.iranianRialCode];
  // Only stamp IRT when we have a usable free-market IRR row.
  if (irr != null && irr > 0) {
    rates[AppConstants.iranianTomanCode] = irr / factor;
  }

  return RateSnapshotModel(
    base: base,
    date: snapshot.date,
    rates: rates,
  );
}

/// Rebases a non-IRT snapshot so **1 IRT** is the unit (Frankfurter has no IRT).
///
/// Example: USD snapshot with `IRT: 178200` → base IRT with `USD: 1/178200`.
RateSnapshotModel rebaseSnapshotToIrt(RateSnapshotModel snapshot) {
  final base = snapshot.base.toUpperCase();
  if (base == AppConstants.iranianTomanCode) return snapshot;

  final withToman = attachTomanFromRial(snapshot);
  final irtPerBase = base == AppConstants.iranianRialCode
      ? 1.0 / AppConstants.rialPerToman
      : withToman.rates[AppConstants.iranianTomanCode];

  // Without an IRT rate we cannot rebase — return the attached snapshot as-is.
  if (irtPerBase == null || irtPerBase <= 0) return withToman;

  final newRates = <String, double>{
    // 1 IRT = ? original base
    base: 1.0 / irtPerBase,
    // Fixed: 1 Toman = 10 Rial
    AppConstants.iranianRialCode: AppConstants.rialPerToman.toDouble(),
  };

  for (final entry in withToman.rates.entries) {
    final code = entry.key.toUpperCase();
    if (code == AppConstants.iranianTomanCode) continue;
    if (code == base) continue;
    // 1 base = entry.value quote → 1 IRT = entry.value / irtPerBase quote
    newRates[code] = entry.value / irtPerBase;
  }

  return RateSnapshotModel(
    base: AppConstants.iranianTomanCode,
    date: withToman.date,
    rates: newRates,
  );
}

/// Scales an IRR-leg history into an IRT-leg history (÷ or × 10).
///
/// Example: USD→IRR closes `/ 10` become USD→IRT closes.
HistoricalSeriesModel scaleHistoryForToman({
  required HistoricalSeriesModel series,
  required String requestedBase,
  required String requestedQuote,
  required String fetchedBase,
  required String fetchedQuote,
}) {
  var factor = 1.0;
  // Quote moved Rial → Toman: drop one zero.
  if (fetchedQuote == AppConstants.iranianRialCode &&
      requestedQuote == AppConstants.iranianTomanCode) {
    factor /= AppConstants.rialPerToman;
  }
  // Base moved Rial → Toman: each Toman buys 10× as much foreign.
  if (fetchedBase == AppConstants.iranianRialCode &&
      requestedBase == AppConstants.iranianTomanCode) {
    factor *= AppConstants.rialPerToman;
  }

  final dated = factor == 1.0
      ? series.datedRates
      : {
          for (final e in series.datedRates.entries) e.key: e.value * factor,
        };

  return HistoricalSeriesModel(
    base: requestedBase.toUpperCase(),
    quote: requestedQuote.toUpperCase(),
    startDate: series.startDate,
    endDate: series.endDate,
    datedRates: dated,
  );
}
