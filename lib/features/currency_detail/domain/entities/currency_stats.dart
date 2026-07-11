import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';

/// High / low / % change derived from a [HistoricalSeries].
///
/// Frankfurter does not provide these stats — we compute them locally.
class CurrencyStats extends Equatable {
  final double high;
  final double low;
  final double percentChange;

  const CurrencyStats({
    required this.high,
    required this.low,
    required this.percentChange,
  });

  /// Builds stats from series points. Returns zeros when empty.
  factory CurrencyStats.fromSeries(HistoricalSeries series) {
    if (series.points.isEmpty) {
      return const CurrencyStats(high: 0, low: 0, percentChange: 0);
    }
    final rates = series.points.map((p) => p.rate).toList();
    final high = rates.reduce(math.max);
    final low = rates.reduce(math.min);
    final first = rates.first;
    final last = rates.last;
    final percent = first == 0 ? 0.0 : ((last - first) / first) * 100;
    return CurrencyStats(high: high, low: low, percentChange: percent);
  }

  @override
  List<Object> get props => [high, low, percentChange];
}
