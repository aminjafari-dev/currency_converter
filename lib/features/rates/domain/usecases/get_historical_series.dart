import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Parameters for [GetHistoricalSeries].
class GetHistoricalSeriesParams {
  final String base;
  final String quote;
  final DateTime start;
  final DateTime end;

  const GetHistoricalSeriesParams({
    required this.base,
    required this.quote,
    required this.start,
    required this.end,
  });
}

/// Loads a historical rate series for charting.
///
/// Example:
/// ```dart
/// final result = await getHistoricalSeries(GetHistoricalSeriesParams(...));
/// ```
class GetHistoricalSeries
    implements UseCase<HistoricalSeries, GetHistoricalSeriesParams> {
  final RatesRepository repository;

  GetHistoricalSeries(this.repository);

  @override
  Future<Either<Failure, HistoricalSeries>> call(
    GetHistoricalSeriesParams params,
  ) {
    return repository.getHistoricalSeries(
      base: params.base,
      quote: params.quote,
      start: params.start,
      end: params.end,
    );
  }
}
