import 'package:get_it/get_it.dart';

import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_bloc.dart';

/// Registers Add Currency feature dependencies.
Future<void> setupCurrencyCatalogLocator(GetIt locator) async {
  locator.registerFactory(
    () => AddCurrencyBloc(
      getSupportedCurrencies: locator(),
      getSelectedCurrencies: locator(),
      addSelectedCurrency: locator(),
      removeSelectedCurrency: locator(),
    ),
  );
}
