import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_event.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_state.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';
import 'package:currency_converter/features/rates/domain/usecases/selected_currency_usecases.dart';

/// BLoC for searching and toggling currencies on the Add Currency screen.
class AddCurrencyBloc extends Bloc<AddCurrencyEvent, AddCurrencyState> {
  final GetSupportedCurrencies getSupportedCurrencies;
  final GetSelectedCurrencies getSelectedCurrencies;
  final AddSelectedCurrency addSelectedCurrency;
  final RemoveSelectedCurrency removeSelectedCurrency;

  AddCurrencyBloc({
    required this.getSupportedCurrencies,
    required this.getSelectedCurrencies,
    required this.addSelectedCurrency,
    required this.removeSelectedCurrency,
  }) : super(const AddCurrencyState(load: AddCurrencyLoadState.initial())) {
    on<AddCurrencyEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        searchChanged: (query) => _onSearchChanged(query, emit),
        toggled: (code) => _onToggled(code, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<AddCurrencyState> emit) async {
    if (!emit.isDone) {
      emit(state.copyWith(load: const AddCurrencyLoadState.loading()));
    }

    final catalogResult = await getSupportedCurrencies(const NoParams());
    List<Currency>? all;
    Failure? failure;
    catalogResult.fold((f) => failure = f, (c) => all = c);
    if (failure != null || all == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: AddCurrencyLoadState.error(
            failure?.message ?? 'Failed to load currencies',
          ),
        ));
      }
      return;
    }

    final selectedResult = await getSelectedCurrencies(const NoParams());
    final selectedCodes = <String>{};
    selectedResult.fold(
      (_) {},
      (list) => selectedCodes.addAll(list.map((e) => e.code)),
    );

    if (!emit.isDone) {
      emit(state.copyWith(
        load: AddCurrencyLoadState.completed(
          all: all!,
          filtered: all!,
          selectedCodes: selectedCodes,
          query: '',
        ),
      ));
    }
  }

  Future<void> _onSearchChanged(
    String query,
    Emitter<AddCurrencyState> emit,
  ) async {
    final current = state.load;
    if (current is! AddCurrencyLoadCompleted) return;

    final q = query.trim().toLowerCase();
    // Empty query shows the full catalog again.
    final filtered = q.isEmpty
        ? current.all
        : current.all
            .where(
              (c) =>
                  c.code.toLowerCase().contains(q) ||
                  c.name.toLowerCase().contains(q),
            )
            .toList();

    if (!emit.isDone) {
      emit(state.copyWith(
        load: current.copyWith(filtered: filtered, query: query),
      ));
    }
  }

  Future<void> _onToggled(String code, Emitter<AddCurrencyState> emit) async {
    final current = state.load;
    if (current is! AddCurrencyLoadCompleted) return;

    final upper = code.toUpperCase();
    final isSelected = current.selectedCodes.contains(upper);

    final result = isSelected
        ? await removeSelectedCurrency(upper)
        : await addSelectedCurrency(upper);

    Failure? failure;
    Set<String>? nextCodes;
    result.fold(
      (f) => failure = f,
      (list) => nextCodes = list.map((e) => e.code).toSet(),
    );

    if (failure != null || nextCodes == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: AddCurrencyLoadState.error(
            failure?.message ?? 'Unable to update selection',
          ),
        ));
      }
      return;
    }

    if (!emit.isDone) {
      emit(state.copyWith(
        load: current.copyWith(selectedCodes: nextCodes!),
      ));
    }
  }
}
