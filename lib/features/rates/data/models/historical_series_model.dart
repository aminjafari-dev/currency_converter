import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';

/// DTO for a base→quote historical time series.
///
/// **Local cache shape:**
/// `{ "base", "quote", "start_date", "end_date", "rates": { "2024-01-01": 0.92 } }`
///
/// **Frankfurter v2** returns flat rows:
/// `[{ "date": "2024-01-01", "base": "USD", "quote": "EUR", "rate": 0.92 }, ...]`
/// Use [HistoricalSeriesModel.fromV2List] for remote responses.
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

  /// Parses a legacy / nested time-series JSON (v1-style `rates` map).
  ///
  /// Kept so older cache entries or tests that still use the nested map
  /// continue to work during the v1 → v2 migration.
  factory HistoricalSeriesModel.fromJson(
    Map<String, dynamic> json, {
    required String quote,
  }) {
    final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
    final dated = <String, double>{};

    // Nested map: date → { quote: rate } (v1). Flat map: date → rate (cache).
    rawRates.forEach((date, value) {
      if (value is Map) {
        final rate = value[quote];
        if (rate is num) {
          dated[date] = rate.toDouble();
        }
      } else if (value is num) {
        dated[date] = value.toDouble();
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

  /// Builds a series from Frankfurter v2 `/v2/rates?from=&to=` rows.
  ///
  /// Example:
  /// ```dart
  /// HistoricalSeriesModel.fromV2List(
  ///   response.data as List,
  ///   base: 'USD',
  ///   quote: 'EUR',
  ///   startDate: '2026-01-01',
  ///   endDate: '2026-06-01',
  /// );
  /// ```
  factory HistoricalSeriesModel.fromV2List(
    List<dynamic> rows, {
    required String base,
    required String quote,
    required String startDate,
    required String endDate,
  }) {
    final dated = <String, double>{};

    for (final row in rows) {
      if (row is! Map) continue;
      final map = Map<String, dynamic>.from(row);
      final date = map['date'] as String?;
      final rate = map['rate'];
      // Skip malformed rows so one bad entry cannot break the whole chart.
      if (date != null && rate is num) {
        dated[date] = rate.toDouble();
      }
    }

    return HistoricalSeriesModel(
      base: base,
      quote: quote,
      startDate: startDate,
      endDate: endDate,
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
