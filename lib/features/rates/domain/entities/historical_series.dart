import 'package:equatable/equatable.dart';

/// A single historical rate observation.
class HistoricalPoint extends Equatable {
  final DateTime date;
  final double rate;

  const HistoricalPoint({
    required this.date,
    required this.rate,
  });

  @override
  List<Object> get props => [date, rate];
}

/// Time series of rates for one base→quote pair over a date range.
///
/// Example:
/// ```dart
/// final high = series.points.map((p) => p.rate).reduce(max);
/// ```
class HistoricalSeries extends Equatable {
  final String base;
  final String quote;
  final DateTime start;
  final DateTime end;
  final List<HistoricalPoint> points;

  const HistoricalSeries({
    required this.base,
    required this.quote,
    required this.start,
    required this.end,
    required this.points,
  });

  @override
  List<Object> get props => [base, quote, start, end, points];
}
