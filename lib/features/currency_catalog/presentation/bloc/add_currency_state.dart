import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:currency_converter/features/rates/domain/entities/currency.dart';

part 'add_currency_state.freezed.dart';

@freezed
sealed class AddCurrencyLoadState with _$AddCurrencyLoadState {
  const factory AddCurrencyLoadState.initial() = AddCurrencyLoadInitial;
  const factory AddCurrencyLoadState.loading() = AddCurrencyLoadLoading;
  const factory AddCurrencyLoadState.completed({
    required List<Currency> all,
    required List<Currency> filtered,
    required Set<String> selectedCodes,
    required String query,
  }) = AddCurrencyLoadCompleted;
  const factory AddCurrencyLoadState.error(String message) =
      AddCurrencyLoadError;
}

@freezed
sealed class AddCurrencyState with _$AddCurrencyState {
  const factory AddCurrencyState({
    required AddCurrencyLoadState load,
  }) = _AddCurrencyState;
}
