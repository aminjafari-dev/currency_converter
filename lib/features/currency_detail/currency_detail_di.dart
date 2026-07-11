import 'package:get_it/get_it.dart';

import 'package:currency_converter/features/currency_detail/domain/usecases/compute_currency_stats.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_bloc.dart';

/// Registers Currency Detail feature dependencies.
Future<void> setupCurrencyDetailLocator(GetIt locator) async {
  locator.registerLazySingleton(() => ComputeCurrencyStats());
  locator.registerFactory(
    () => DetailBloc(
      getLatestRates: locator(),
      getHistoricalSeries: locator(),
      getSupportedCurrencies: locator(),
      computeCurrencyStats: locator(),
    ),
  );
}
