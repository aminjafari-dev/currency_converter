import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rates.dart';

/// Force-refreshes latest rates (pull-to-refresh / widget refresh).
///
/// Example:
/// ```dart
/// await refreshRates(GetLatestRatesParams(base: 'USD'));
/// ```
class RefreshRates implements UseCase<RateSnapshot, GetLatestRatesParams> {
  final RatesRepository repository;

  RefreshRates(this.repository);

  @override
  Future<Either<Failure, RateSnapshot>> call(GetLatestRatesParams params) {
    return repository.getLatestRates(
      base: params.base,
      symbols: params.symbols,
    );
  }
}

/// Reads the last successful cache timestamp.
class GetLastUpdatedAt implements UseCase<DateTime?, NoParams> {
  final RatesRepository repository;

  GetLastUpdatedAt(this.repository);

  @override
  Future<Either<Failure, DateTime?>> call(NoParams params) {
    return repository.getLastUpdatedAt();
  }
}
