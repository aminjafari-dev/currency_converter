import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_currency_event.freezed.dart';

/// Events for the Add Currency catalog screen.
@freezed
sealed class AddCurrencyEvent with _$AddCurrencyEvent {
  const factory AddCurrencyEvent.started() = AddCurrencyStarted;
  const factory AddCurrencyEvent.searchChanged({required String query}) =
      AddCurrencySearchChanged;
  const factory AddCurrencyEvent.toggled({required String code}) =
      AddCurrencyToggled;
}
