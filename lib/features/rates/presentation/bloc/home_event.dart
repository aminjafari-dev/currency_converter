import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

/// Sealed events for the Home currency list screen.
///
/// Example:
/// ```dart
/// context.read<HomeBloc>().add(const HomeEvent.started());
/// context.read<HomeBloc>().add(
///   HomeEvent.amountChanged(code: 'EUR', amount: 100),
/// );
/// ```
@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Initial load of selected currencies + latest rates.
  const factory HomeEvent.started() = HomeStarted;

  /// Pull-to-refresh / tap sync icon.
  const factory HomeEvent.refreshed() = HomeRefreshed;

  /// User edited any currency's amount — recalculate all others locally.
  ///
  /// [code] is the currency the user typed into; [amount] is that value.
  /// No network call: uses [ConvertAmount] against the cached snapshot.
  const factory HomeEvent.amountChanged({
    required String code,
    required double amount,
  }) = HomeAmountChanged;

  /// User long-pressed a row to make it the persisted base (for refresh).
  /// Amounts realign locally from the visible value on that row — no rate fetch.
  const factory HomeEvent.baseChanged({required String code}) = HomeBaseChanged;

  /// User dismissed a currency from the list (e.g. swipe-to-remove).
  const factory HomeEvent.currencyRemoved({required String code}) =
      HomeCurrencyRemoved;
}
