import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';

/// Domain contract for FX rates + user currency selection.
///
/// Implemented by [RatesRepositoryImpl] in the data layer. Presentation
/// never imports the implementation — only this interface / use cases.
abstract class RatesRepository {
  /// Latest rates for [base], optionally limited to [symbols].
  Future<Either<Failure, RateSnapshot>> getLatestRates({
    required String base,
    List<String>? symbols,
  });

  /// Historical series for [base]→[quote] between [start] and [end].
  Future<Either<Failure, HistoricalSeries>> getHistoricalSeries({
    required String base,
    required String quote,
    required DateTime start,
    required DateTime end,
  });

  /// Full catalog of supported currencies.
  Future<Either<Failure, List<Currency>>> getSupportedCurrencies();

  /// User's selected Home-list currencies (persisted locally).
  Future<Either<Failure, List<SelectedCurrency>>> getSelectedCurrencies();

  /// Adds [code] to the selected list (no-op if already present).
  Future<Either<Failure, List<SelectedCurrency>>> addSelectedCurrency(
    String code,
  );

  /// Removes [code] from the selected list (keeps at least one).
  Future<Either<Failure, List<SelectedCurrency>>> removeSelectedCurrency(
    String code,
  );

  /// Sets [code] as the base (editable) currency.
  Future<Either<Failure, List<SelectedCurrency>>> setBaseCurrency(String code);

  /// Persists a new display order for selected currencies.
  ///
  /// [orderedCodes] must be a permutation of the current selection (same
  /// codes, no extras). Base flags are preserved per code.
  ///
  /// Example: `reorderSelectedCurrencies(['EUR', 'USD', 'GBP'])`
  Future<Either<Failure, List<SelectedCurrency>>> reorderSelectedCurrencies(
    List<String> orderedCodes,
  );

  /// Timestamp of the last successful rate cache write, if any.
  Future<Either<Failure, DateTime?>> getLastUpdatedAt();
}
