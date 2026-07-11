import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/features/currency_detail/domain/entities/currency_stats.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';

void main() {
  group('RateSnapshotModel', () {
    test('fromJson maps rates and toDomain preserves values', () {
      final model = RateSnapshotModel.fromJson({
        'base': 'USD',
        'date': '2026-07-11',
        'rates': {'EUR': 0.92, 'GBP': 0.78},
      });
      expect(model.base, 'USD');
      expect(model.rates['EUR'], 0.92);
      final entity = model.toDomain(fetchedAt: DateTime(2026, 7, 11));
      expect(entity.rateFor('EUR'), 0.92);
      expect(entity.fetchedAt, DateTime(2026, 7, 11));
    });
  });

  group('CurrencyModel', () {
    test('listFromCurrenciesMap sorts by code', () {
      final list = CurrencyModel.listFromCurrenciesMap({
        'EUR': 'Euro',
        'USD': 'US Dollar',
        'AMD': 'Armenian Dram',
      });
      expect(list.first.code, 'AMD');
      expect(list.last.code, 'USD');
      expect(list.first.toDomain().name, 'Armenian Dram');
    });
  });

  group('CurrencyStats', () {
    test('computes high low and percent change', () {
      final series = HistoricalSeries(
        base: 'USD',
        quote: 'EUR',
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 3),
        points: [
          HistoricalPoint(date: DateTime(2026, 1, 1), rate: 1.0),
          HistoricalPoint(date: DateTime(2026, 1, 2), rate: 1.1),
          HistoricalPoint(date: DateTime(2026, 1, 3), rate: 0.9),
        ],
      );
      final stats = CurrencyStats.fromSeries(series);
      expect(stats.high, 1.1);
      expect(stats.low, 0.9);
      expect(stats.percentChange, closeTo(-10.0, 0.01));
    });

    test('empty series returns zeros', () {
      final stats = CurrencyStats.fromSeries(
        HistoricalSeries(
          base: 'USD',
          quote: 'EUR',
          start: DateTime(2026, 1, 1),
          end: DateTime(2026, 1, 1),
          points: const [],
        ),
      );
      expect(stats.high, 0);
      expect(stats.low, 0);
      expect(stats.percentChange, 0);
    });
  });
}
