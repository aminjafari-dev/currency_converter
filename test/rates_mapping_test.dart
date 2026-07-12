import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/features/currency_detail/domain/entities/currency_stats.dart';
import 'package:currency_converter/features/rates/data/models/currency_model.dart';
import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';
import 'package:currency_converter/features/rates/data/models/rate_snapshot_model.dart';
import 'package:currency_converter/features/rates/data/utils/irr_rate_overlay.dart';
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

    test('fromV2List collapses quote rows and picks newest date', () {
      // Given: v2 latest rates with staggered observation dates
      final model = RateSnapshotModel.fromV2List([
        {
          'date': '2026-07-10',
          'base': 'USD',
          'quote': 'YER',
          'rate': 239.14,
        },
        {
          'date': '2026-07-11',
          'base': 'USD',
          'quote': 'IRR',
          'rate': 1372507,
        },
        {
          'date': '2026-07-11',
          'base': 'USD',
          'quote': 'AMD',
          'rate': 367.03,
        },
      ]);

      // When/Then: all quotes are present and date is the newest row
      expect(model.base, 'USD');
      expect(model.date, '2026-07-11');
      expect(model.rates['IRR'], 1372507);
      expect(model.rates['AMD'], 367.03);
      expect(model.rates['YER'], 239.14);
    });
  });

  group('HistoricalSeriesModel', () {
    test('fromV2List maps dated rates for a single quote', () {
      final model = HistoricalSeriesModel.fromV2List(
        [
          {
            'date': '2026-06-01',
            'base': 'USD',
            'quote': 'EUR',
            'rate': 0.85,
          },
          {
            'date': '2026-06-02',
            'base': 'USD',
            'quote': 'EUR',
            'rate': 0.86,
          },
        ],
        base: 'USD',
        quote: 'EUR',
        startDate: '2026-06-01',
        endDate: '2026-06-02',
      );

      expect(model.datedRates['2026-06-01'], 0.85);
      expect(model.datedRates['2026-06-02'], 0.86);
      final series = model.toDomain();
      expect(series.points.length, 2);
      expect(series.points.first.rate, 0.85);
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

    test('listFromV2List maps iso_code and sorts', () {
      final list = CurrencyModel.listFromV2List([
        {
          'iso_code': 'IRR',
          'name': 'Iranian Rial',
          'symbol': 'ریال',
        },
        {
          'iso_code': 'AMD',
          'name': 'Armenian Dram',
          'symbol': '֏',
        },
        {
          'iso_code': 'OMR',
          'name': 'Omani Rial',
          'symbol': 'ر.ع.',
        },
      ]);
      expect(list.map((c) => c.code).toList(), ['AMD', 'IRR', 'OMR']);
      expect(list.first.name, 'Armenian Dram');
    });
  });

  group('overlayIrrOnSnapshot', () {
    test('replaces IRR when base is USD using Oanor USD close', () {
      // Given: Frankfurter official IRR + Oanor free-market USD→IRR
      final frankfurter = RateSnapshotModel.fromJson({
        'base': 'USD',
        'date': '2026-07-12',
        'rates': {'EUR': 0.92, 'IRR': 1371354, 'GBP': 0.78},
      });

      // When: overlay bazaar IRR
      final overlayed = overlayIrrOnSnapshot(
        frankfurter: frankfurter,
        foreignToIrr: const {'USD': 1816200, 'EUR': 2076800},
      );

      // Then: IRR comes from Oanor; other quotes stay Frankfurter
      expect(overlayed.rates['IRR'], 1816200);
      expect(overlayed.rates['EUR'], 0.92);
    });

    test('uses direct Oanor EUR close when base is EUR', () {
      final frankfurter = RateSnapshotModel.fromJson({
        'base': 'EUR',
        'date': '2026-07-12',
        'rates': {'USD': 1.08, 'IRR': 1480000},
      });

      final overlayed = overlayIrrOnSnapshot(
        frankfurter: frankfurter,
        foreignToIrr: const {'USD': 1816200, 'EUR': 2076800},
      );

      expect(overlayed.rates['IRR'], 2076800);
    });

    test('bridges via USD when base is not listed by Oanor', () {
      // Given: AMD base — Oanor has no AMD row, so 1 AMD → USD → IRR
      final frankfurter = RateSnapshotModel.fromJson({
        'base': 'AMD',
        'date': '2026-07-12',
        'rates': {'USD': 0.0025, 'IRR': 3000},
      });

      final overlayed = overlayIrrOnSnapshot(
        frankfurter: frankfurter,
        foreignToIrr: const {'USD': 1816200},
      );

      expect(overlayed.rates['IRR'], closeTo(0.0025 * 1816200, 0.01));
    });

    test('inverts Oanor closes when base is IRR', () {
      final frankfurter = RateSnapshotModel.fromJson({
        'base': 'IRR',
        'date': '2026-07-12',
        'rates': {'USD': 0.0000007, 'EUR': 0.0000006},
      });

      final overlayed = overlayIrrOnSnapshot(
        frankfurter: frankfurter,
        foreignToIrr: const {'USD': 2000000, 'EUR': 2200000},
      );

      expect(overlayed.rates['USD'], closeTo(1 / 2000000, 1e-12));
      expect(overlayed.rates['EUR'], closeTo(1 / 2200000, 1e-12));
      expect(overlayed.rates.containsKey('IRR'), isFalse);
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
