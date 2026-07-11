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
/// context.read<HomeBloc>().add(const HomeEvent.editModeToggled());
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

  /// User dismissed a currency from the list (swipe or edit-mode remove).
  const factory HomeEvent.currencyRemoved({required String code}) =
      HomeCurrencyRemoved;

  /// Toggles list-edit mode (pen icon): shows remove + drag handles on each card.
  ///
  /// Example: tap the app-bar pen → cards reveal delete and reorder affordances.
  const factory HomeEvent.editModeToggled() = HomeEditModeToggled;

  /// User dragged a card to a new position while in edit mode.
  ///
  /// [oldIndex] / [newIndex] come from [SliverReorderableList.onReorderItem],
  /// which already adjusts [newIndex] when an item moves downward.
  ///
  /// Example: drag EUR from index 2 to the top → `oldIndex: 2, newIndex: 0`.
  const factory HomeEvent.currenciesReordered({
    required int oldIndex,
    required int newIndex,
  }) = HomeCurrenciesReordered;
}
