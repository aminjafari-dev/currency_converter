import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

/// Sealed events for the Home currency list screen.
///
/// Example:
/// ```dart
/// context.read<HomeBloc>().add(const HomeEvent.started());
/// context.read<HomeBloc>().add(HomeEvent.amountChanged(amount: 100));
/// ```
@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Initial load of selected currencies + latest rates.
  const factory HomeEvent.started() = HomeStarted;

  /// Pull-to-refresh / tap sync icon.
  const factory HomeEvent.refreshed() = HomeRefreshed;

  /// User edited the base amount field.
  const factory HomeEvent.amountChanged({required double amount}) =
      HomeAmountChanged;

  /// User tapped a non-base row to make it the new base.
  const factory HomeEvent.baseChanged({required String code}) = HomeBaseChanged;

  /// User removed a currency while in edit mode.
  const factory HomeEvent.currencyRemoved({required String code}) =
      HomeCurrencyRemoved;

  /// Toggle edit mode (reorder / remove affordances).
  const factory HomeEvent.editModeToggled() = HomeEditModeToggled;
}
