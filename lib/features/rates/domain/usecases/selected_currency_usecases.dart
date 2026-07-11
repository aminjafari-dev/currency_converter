import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

/// Loads the user's selected Home-list currencies.
class GetSelectedCurrencies
    implements UseCase<List<SelectedCurrency>, NoParams> {
  final RatesRepository repository;

  GetSelectedCurrencies(this.repository);

  @override
  Future<Either<Failure, List<SelectedCurrency>>> call(NoParams params) {
    return repository.getSelectedCurrencies();
  }
}

/// Adds a currency code to the selected list.
class AddSelectedCurrency
    implements UseCase<List<SelectedCurrency>, String> {
  final RatesRepository repository;

  AddSelectedCurrency(this.repository);

  @override
  Future<Either<Failure, List<SelectedCurrency>>> call(String code) {
    return repository.addSelectedCurrency(code);
  }
}

/// Removes a currency code from the selected list.
class RemoveSelectedCurrency
    implements UseCase<List<SelectedCurrency>, String> {
  final RatesRepository repository;

  RemoveSelectedCurrency(this.repository);

  @override
  Future<Either<Failure, List<SelectedCurrency>>> call(String code) {
    return repository.removeSelectedCurrency(code);
  }
}

/// Marks [code] as the editable base currency on Home.
class SetBaseCurrency implements UseCase<List<SelectedCurrency>, String> {
  final RatesRepository repository;

  SetBaseCurrency(this.repository);

  @override
  Future<Either<Failure, List<SelectedCurrency>>> call(String code) {
    return repository.setBaseCurrency(code);
  }
}

/// Persists a new Home-list order after the user drags a currency card.
///
/// Pass the full ordered list of codes (same set as before, new sequence).
///
/// Example:
/// ```dart
/// await reorderSelectedCurrencies(['EUR', 'USD', 'GBP']);
/// ```
class ReorderSelectedCurrencies
    implements UseCase<List<SelectedCurrency>, List<String>> {
  final RatesRepository repository;

  ReorderSelectedCurrencies(this.repository);

  @override
  Future<Either<Failure, List<SelectedCurrency>>> call(
    List<String> orderedCodes,
  ) {
    return repository.reorderSelectedCurrencies(orderedCodes);
  }
}
