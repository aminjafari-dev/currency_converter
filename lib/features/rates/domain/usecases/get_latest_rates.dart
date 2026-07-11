import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Parameters for [GetLatestRates].
class GetLatestRatesParams {
  final String base;
  final List<String>? symbols;

  const GetLatestRatesParams({required this.base, this.symbols});
}

/// Fetches the latest FX snapshot for a base currency.
///
/// Example:
/// ```dart
/// final result = await getLatestRates(GetLatestRatesParams(base: 'USD'));
/// ```
class GetLatestRates implements UseCase<RateSnapshot, GetLatestRatesParams> {
  final RatesRepository repository;

  GetLatestRates(this.repository);

  @override
  Future<Either<Failure, RateSnapshot>> call(GetLatestRatesParams params) {
    return repository.getLatestRates(
      base: params.base,
      symbols: params.symbols,
    );
  }
}
