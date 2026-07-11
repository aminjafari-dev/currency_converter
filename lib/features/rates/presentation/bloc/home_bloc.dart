import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/usecases/convert_amount.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';
import 'package:currency_converter/features/rates/domain/usecases/refresh_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/selected_currency_usecases.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_event.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_state.dart';

/// BLoC for the Home currency list screen.
///
/// Loads selected currencies + latest rates, converts amounts locally, and
/// handles base/amount interactions without any UI types.
///
/// Editing any row's amount realigns every other currency via [ConvertAmount]
/// against the cached snapshot — never a new network request.
///
/// Example:
/// ```dart
/// BlocProvider(
///   create: (_) => locator<HomeBloc>()..add(const HomeEvent.started()),
///   child: const HomePage(),
/// );
/// ```
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetLatestRates getLatestRates;
  final GetSelectedCurrencies getSelectedCurrencies;
  final SetBaseCurrency setBaseCurrency;
  final RemoveSelectedCurrency removeSelectedCurrency;
  final ConvertAmount convertAmount;
  final RefreshRates refreshRates;
  final GetSupportedCurrencies getSupportedCurrencies;

  HomeBloc({
    required this.getLatestRates,
    required this.getSelectedCurrencies,
    required this.setBaseCurrency,
    required this.removeSelectedCurrency,
    required this.convertAmount,
    required this.refreshRates,
    required this.getSupportedCurrencies,
  }) : super(const HomeState(load: HomeLoadState.initial())) {
    on<HomeEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        refreshed: () => _onRefreshed(emit),
        amountChanged: (code, amount) => _onAmountChanged(code, amount, emit),
        baseChanged: (code) => _onBaseChanged(code, emit),
        currencyRemoved: (code) => _onCurrencyRemoved(code, emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<HomeState> emit) async {
    if (!emit.isDone) {
      emit(state.copyWith(load: const HomeLoadState.loading()));
    }
    await _load(emit, forceRefresh: false);
  }

  Future<void> _onRefreshed(Emitter<HomeState> emit) async {
    // Keep prior completed data visible while refreshing when possible.
    if (state.load is! HomeLoadCompleted && !emit.isDone) {
      emit(state.copyWith(load: const HomeLoadState.loading()));
    }
    await _load(emit, forceRefresh: true);
  }

  Future<void> _load(
    Emitter<HomeState> emit, {
    required bool forceRefresh,
  }) async {
    final selectedResult = await getSelectedCurrencies(const NoParams());
    List<SelectedCurrency>? selected;
    Failure? selectedFailure;
    selectedResult.fold(
      (f) => selectedFailure = f,
      (s) => selected = s,
    );
    if (selectedFailure != null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: HomeLoadState.error(_mapFailure(selectedFailure!)),
        ));
      }
      return;
    }

    final catalogResult = await getSupportedCurrencies(const NoParams());
    final catalog = <String, Currency>{};
    catalogResult.fold(
      (_) {},
      (list) {
        for (final c in list) {
          catalog[c.code] = c;
        }
      },
    );

    final baseCode = selected!
        .firstWhere(
          (c) => c.isBase,
          orElse: () => selected!.first,
        )
        .code;

    final ratesResult = forceRefresh
        ? await refreshRates(GetLatestRatesParams(base: baseCode))
        : await getLatestRates(GetLatestRatesParams(base: baseCode));

    RateSnapshot? snapshot;
    Failure? ratesFailure;
    ratesResult.fold(
      (f) => ratesFailure = f,
      (s) => snapshot = s,
    );

    if (ratesFailure != null || snapshot == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: HomeLoadState.error(
            _mapFailure(ratesFailure ?? const ServerFailure()),
          ),
        ));
      }
      return;
    }

    // Prefer keeping the user's current base amount across refresh when we
    // already have completed state; otherwise start from the default.
    const defaultAmount = 100.0;
    final prior = state.load;
    final seedAmount = prior is HomeLoadCompleted
        ? (prior.convertedAmounts[baseCode] ?? prior.baseAmount)
        : defaultAmount;

    final converted = await _convertAll(
      amount: seedAmount,
      fromCode: baseCode,
      selected: selected!,
      snapshot: snapshot!,
    );

    if (!emit.isDone) {
      emit(state.copyWith(
        load: HomeLoadState.completed(
          snapshot: snapshot!,
          selected: selected!,
          catalog: catalog,
          convertedAmounts: converted,
          baseAmount: seedAmount,
          lastUpdated: snapshot!.fetchedAt,
        ),
      ));
    }
  }

  /// Recalculates every selected currency from the edited row using cached rates.
  ///
  /// Useful when the user types into EUR while USD is the persisted base —
  /// others update immediately with no network round-trip.
  Future<void> _onAmountChanged(
    String code,
    double amount,
    Emitter<HomeState> emit,
  ) async {
    final current = state.load;
    if (current is! HomeLoadCompleted) return;

    final converted = await _convertAll(
      amount: amount,
      fromCode: code,
      selected: current.selected,
      snapshot: current.snapshot,
    );

    // Persist the amount that belongs to the official base so refresh/load
    // can restore a consistent seed value later.
    final baseCode = current.selected
        .firstWhere(
          (c) => c.isBase,
          orElse: () => current.selected.first,
        )
        .code;

    if (!emit.isDone) {
      emit(state.copyWith(
        load: current.copyWith(
          baseAmount: converted[baseCode] ?? amount,
          convertedAmounts: converted,
        ),
      ));
    }
  }

  /// Changes the persisted base currency and realigns amounts locally.
  ///
  /// Does not fetch new rates — triangular conversion on the existing snapshot
  /// is enough until the user pull-to-refreshes.
  Future<void> _onBaseChanged(String code, Emitter<HomeState> emit) async {
    final current = state.load;
    if (current is! HomeLoadCompleted) return;

    // Preserve the amount the user sees on the newly selected row.
    final newBaseAmount = current.convertedAmounts[code] ?? current.baseAmount;

    final result = await setBaseCurrency(code);
    List<SelectedCurrency>? selected;
    Failure? failure;
    result.fold((f) => failure = f, (s) => selected = s);
    if (failure != null || selected == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: HomeLoadState.error(_mapFailure(failure!)),
        ));
      }
      return;
    }

    final converted = await _convertAll(
      amount: newBaseAmount,
      fromCode: code,
      selected: selected!,
      snapshot: current.snapshot,
    );

    if (!emit.isDone) {
      emit(state.copyWith(
        load: current.copyWith(
          selected: selected!,
          baseAmount: newBaseAmount,
          convertedAmounts: converted,
        ),
      ));
    }
  }

  Future<void> _onCurrencyRemoved(String code, Emitter<HomeState> emit) async {
    final current = state.load;
    if (current is! HomeLoadCompleted) return;

    final result = await removeSelectedCurrency(code);
    List<SelectedCurrency>? selected;
    Failure? failure;
    result.fold((f) => failure = f, (s) => selected = s);
    if (failure != null || selected == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: HomeLoadState.error(_mapFailure(failure!)),
        ));
      }
      return;
    }

    // After removal, recompute from the persisted base so remaining rows stay aligned.
    final baseCode = selected!
        .firstWhere((c) => c.isBase, orElse: () => selected!.first)
        .code;
    final seedAmount =
        current.convertedAmounts[baseCode] ?? current.baseAmount;

    final converted = await _convertAll(
      amount: seedAmount,
      fromCode: baseCode,
      selected: selected!,
      snapshot: current.snapshot,
    );

    if (!emit.isDone) {
      emit(state.copyWith(
        load: current.copyWith(
          selected: selected!,
          baseAmount: seedAmount,
          convertedAmounts: converted,
        ),
      ));
    }
  }

  /// Converts [amount] in [fromCode] into every selected currency via [ConvertAmount].
  ///
  /// Example: editing 50 EUR updates USD/GBP using the cached snapshot rates.
  Future<Map<String, double>> _convertAll({
    required double amount,
    required String fromCode,
    required List<SelectedCurrency> selected,
    required RateSnapshot snapshot,
  }) async {
    final map = <String, double>{};
    for (final item in selected) {
      if (item.code == fromCode) {
        map[item.code] = amount;
        continue;
      }
      final result = await convertAmount(
        ConvertAmountParams(
          amount: amount,
          fromCode: fromCode,
          toCode: item.code,
          base: snapshot.base,
          rates: snapshot.rates,
        ),
      );
      result.fold(
        (_) => map[item.code] = 0,
        (v) => map[item.code] = v,
      );
    }
    return map;
  }

  String _mapFailure(Failure failure) => failure.message;
}
