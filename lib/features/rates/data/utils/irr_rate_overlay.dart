import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';

/// Pure helpers that replace Frankfurter’s official IRR with Oanor bazaar IRR.
///
/// [foreignToIrr] maps ISO code → IRR for 1 unit of that foreign currency
/// (already JPY-normalized by the Oanor data source).
///
/// Example:
/// ```dart
/// final overlayed = overlayIrrOnSnapshot(
///   frankfurter: snapshot,
///   foreignToIrr: {'USD': 1816200, 'EUR': 2076800},
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

    // Currencies Oanor does not list: bridge via USD using Frankfurter cross.
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

/// Builds a base↔IRR historical series from an Oanor foreign→IRR history.
///
/// When [baseIsIrr] is true, each point is inverted (1 IRR = 1/close foreign).
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
  // Direct hit — Oanor lists this currency vs IRR.
  final direct = foreignToIrr[base];
  if (direct != null && direct > 0) return direct;

  // Triangular: 1 base → USD (Frankfurter) → IRR (Oanor).
  final usdIrr = foreignToIrr['USD'];
  if (usdIrr == null || usdIrr <= 0) return null;

  if (base == 'USD') return usdIrr;

  final usdPerBase = rates['USD'];
  if (usdPerBase == null || usdPerBase <= 0) return null;
  return usdPerBase * usdIrr;
}
