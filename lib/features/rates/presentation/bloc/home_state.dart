import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';

part 'home_state.freezed.dart';

/// Load-operation state for Home rates.
@freezed
sealed class HomeLoadState with _$HomeLoadState {
  const factory HomeLoadState.initial() = HomeLoadInitial;
  const factory HomeLoadState.loading() = HomeLoadLoading;
  const factory HomeLoadState.completed({
    required RateSnapshot snapshot,
    required List<SelectedCurrency> selected,
    required Map<String, Currency> catalog,
    required Map<String, double> convertedAmounts,
    required double baseAmount,
    required DateTime? lastUpdated,
  }) = HomeLoadCompleted;
  const factory HomeLoadState.error(String message) = HomeLoadError;
}

/// Combined Home screen state.
///
/// Amounts are always editable in-place; there is no separate list-edit mode.
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    required HomeLoadState load,
  }) = _HomeState;
}
