import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_bloc.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_event.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_state.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';
import 'package:currency_converter/features/rates/domain/usecases/selected_currency_usecases.dart';

class _MockGetSupported extends Mock implements GetSupportedCurrencies {}

class _MockGetSelected extends Mock implements GetSelectedCurrencies {}

class _MockAddSelected extends Mock implements AddSelectedCurrency {}

class _MockRemoveSelected extends Mock implements RemoveSelectedCurrency {}

void main() {
  late _MockGetSupported getSupported;
  late _MockGetSelected getSelected;
  late _MockAddSelected addSelected;
  late _MockRemoveSelected removeSelected;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getSupported = _MockGetSupported();
    getSelected = _MockGetSelected();
    addSelected = _MockAddSelected();
    removeSelected = _MockRemoveSelected();
  });

  AddCurrencyBloc buildBloc() => AddCurrencyBloc(
        getSupportedCurrencies: getSupported,
        getSelectedCurrencies: getSelected,
        addSelectedCurrency: addSelected,
        removeSelectedCurrency: removeSelected,
      );

  blocTest<AddCurrencyBloc, AddCurrencyState>(
    'started loads catalog and selected codes',
    build: () {
      when(() => getSupported(any())).thenAnswer(
        (_) async => const Right([
          Currency(code: 'USD', name: 'US Dollar'),
          Currency(code: 'EUR', name: 'Euro'),
        ]),
      );
      when(() => getSelected(any())).thenAnswer(
        (_) async => const Right([
          SelectedCurrency(code: 'USD', isBase: true),
        ]),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AddCurrencyEvent.started()),
    expect: () => [
      isA<AddCurrencyState>().having(
        (s) => s.load,
        'load',
        isA<AddCurrencyLoadLoading>(),
      ),
      isA<AddCurrencyState>().having(
        (s) => s.load,
        'load',
        isA<AddCurrencyLoadCompleted>()
            .having((c) => c.all.length, 'all', 2)
            .having((c) => c.selectedCodes.contains('USD'), 'selected', true),
      ),
    ],
  );

  blocTest<AddCurrencyBloc, AddCurrencyState>(
    'started emits error when catalog fails',
    build: () {
      when(() => getSupported(any())).thenAnswer(
        (_) async => const Left(ServerFailure('boom')),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AddCurrencyEvent.started()),
    expect: () => [
      isA<AddCurrencyState>().having(
        (s) => s.load,
        'load',
        isA<AddCurrencyLoadLoading>(),
      ),
      isA<AddCurrencyState>().having(
        (s) => s.load,
        'load',
        isA<AddCurrencyLoadError>(),
      ),
    ],
  );
}
