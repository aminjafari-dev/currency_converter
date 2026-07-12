import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';

/// DTO for a latest-rates snapshot.
///
/// **Local cache / domain shape** stays map-based:
/// `{ "base": "USD", "date": "2024-01-01", "rates": { "EUR": 0.92 } }`
///
/// **Frankfurter v2** returns a row list instead:
/// `[{ "date": "...", "base": "USD", "quote": "EUR", "rate": 0.92 }, ...]`
/// Use [RateSnapshotModel.fromV2List] for remote responses and [fromJson]
/// for SharedPreferences cache.
///
/// Example:
/// ```dart
/// final model = RateSnapshotModel.fromV2List(apiRows);
/// final entity = model.toDomain();
/// ```
class RateSnapshotModel {
  final String base;
  final String date;
  final Map<String, double> rates;

  const RateSnapshotModel({
    required this.base,
    required this.date,
    required this.rates,
  });

  /// Parses the internal / cached JSON map shape.
  factory RateSnapshotModel.fromJson(Map<String, dynamic> json) {
    final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
    final rates = <String, double>{};
    rawRates.forEach((key, value) {
      rates[key] = (value as num).toDouble();
    });
    return RateSnapshotModel(
      base: json['base'] as String? ?? 'EUR',
      date: json['date'] as String? ?? '',
      rates: rates,
    );
  }

  /// Collapses Frankfurter v2 `/v2/rates` rows into one snapshot.
  ///
  /// Useful when quotes publish on slightly different calendar days: we keep
  /// every quote's latest row and stamp [date] with the newest observation.
  ///
  /// Example: `GET /v2/rates?base=USD` → list of `{date, base, quote, rate}`.
  factory RateSnapshotModel.fromV2List(List<dynamic> rows) {
    // Empty payload — return a safe empty snapshot rather than throwing.
    if (rows.isEmpty) {
      return const RateSnapshotModel(base: 'EUR', date: '', rates: {});
    }

    final rates = <String, double>{};
    var base = 'EUR';
    var date = '';

    for (final row in rows) {
      if (row is! Map) continue;
      final map = Map<String, dynamic>.from(row);
      base = map['base'] as String? ?? base;

      final rowDate = map['date'] as String? ?? '';
      // YYYY-MM-DD strings compare lexicographically in chronological order.
      if (rowDate.compareTo(date) > 0) {
        date = rowDate;
      }

      final quote = map['quote'] as String?;
      final rate = map['rate'];
      if (quote != null && rate is num) {
        rates[quote] = rate.toDouble();
      }
    }

    return RateSnapshotModel(base: base, date: date, rates: rates);
  }

  Map<String, dynamic> toJson() => {
        'base': base,
        'date': date,
        'rates': rates,
      };

  /// Maps this DTO to a domain [RateSnapshot].
  RateSnapshot toDomain({DateTime? fetchedAt}) {
    return RateSnapshot(
      base: base,
      date: date,
      rates: rates,
      fetchedAt: fetchedAt ?? DateTime.now(),
    );
  }

  factory RateSnapshotModel.fromDomain(RateSnapshot snapshot) {
    return RateSnapshotModel(
      base: snapshot.base,
      date: snapshot.date,
      rates: snapshot.rates,
    );
  }
}
