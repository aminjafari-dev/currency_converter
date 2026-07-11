import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/currency_stats.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';

/// Computes [CurrencyStats] from a historical series (pure domain logic).
class ComputeCurrencyStats
    implements UseCase<CurrencyStats, HistoricalSeries> {
  @override
  Future<Either<Failure, CurrencyStats>> call(HistoricalSeries params) async {
    return Right(CurrencyStats.fromSeries(params));
  }
}
