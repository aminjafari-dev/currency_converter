import 'package:equatable/equatable.dart';

/// Snapshot of latest FX rates for a single [base] currency.
///
/// [rates] maps target currency code → multiplier (1 base = rate target).
///
/// Example:
/// ```dart
/// final eur = snapshot.rates['EUR']; // 0.92 when base is USD
/// ```
class RateSnapshot extends Equatable {
  /// Base currency ISO code.
  final String base;

  /// Observation date from the provider (YYYY-MM-DD).
  final String date;

  /// Map of quote code → rate.
  final Map<String, double> rates;

  /// Local device time when this snapshot was cached / received.
  final DateTime fetchedAt;

  const RateSnapshot({
    required this.base,
    required this.date,
    required this.rates,
    required this.fetchedAt,
  });

  /// Returns the rate for [code], or `null` when missing.
  double? rateFor(String code) => rates[code.toUpperCase()];

  @override
  List<Object> get props => [base, date, rates, fetchedAt];
}
