import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';

/// DTO for Frankfurter v1 time-series responses.
///
/// Shape:
/// `{ "base": "USD", "start_date": "...", "end_date": "...",
///    "rates": { "2024-01-01": { "EUR": 0.92 }, ... } }`
class HistoricalSeriesModel {
  final String base;
  final String quote;
  final String startDate;
  final String endDate;
  final Map<String, double> datedRates;

  const HistoricalSeriesModel({
    required this.base,
    required this.quote,
    required this.startDate,
    required this.endDate,
    required this.datedRates,
  });

  /// Parses a Frankfurter time-series JSON, extracting [quote] rates.
  factory HistoricalSeriesModel.fromJson(
    Map<String, dynamic> json, {
    required String quote,
  }) {
    final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
    final dated = <String, double>{};
    rawRates.forEach((date, value) {
      if (value is Map) {
        final rate = value[quote];
        if (rate is num) {
          dated[date] = rate.toDouble();
        }
      }
    });
    return HistoricalSeriesModel(
      base: json['base'] as String? ?? 'EUR',
      quote: quote,
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      datedRates: dated,
    );
  }

  Map<String, dynamic> toJson() => {
        'base': base,
        'quote': quote,
        'start_date': startDate,
        'end_date': endDate,
        'rates': datedRates,
      };

  HistoricalSeries toDomain() {
    final points = datedRates.entries.map((e) {
      return HistoricalPoint(
        date: DateTime.tryParse(e.key) ?? DateTime.now(),
        rate: e.value,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return HistoricalSeries(
      base: base,
      quote: quote,
      start: DateTime.tryParse(startDate) ??
          (points.isNotEmpty ? points.first.date : DateTime.now()),
      end: DateTime.tryParse(endDate) ??
          (points.isNotEmpty ? points.last.date : DateTime.now()),
      points: points,
    );
  }
}
