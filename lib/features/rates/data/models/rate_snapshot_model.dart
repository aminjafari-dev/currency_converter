import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';

/// DTO for Frankfurter v1 latest / single-day responses.
///
/// Shape: `{ "amount": 1.0, "base": "USD", "date": "2024-01-01", "rates": { "EUR": 0.92 } }`
///
/// Example:
/// ```dart
/// final model = RateSnapshotModel.fromJson(json);
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
