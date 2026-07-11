import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Returns the full supported currency catalog from Frankfurter.
///
/// Example:
/// ```dart
/// final result = await getSupportedCurrencies(const NoParams());
/// ```
class GetSupportedCurrencies implements UseCase<List<Currency>, NoParams> {
  final RatesRepository repository;

  GetSupportedCurrencies(this.repository);

  @override
  Future<Either<Failure, List<Currency>>> call(NoParams params) {
    return repository.getSupportedCurrencies();
  }
}
