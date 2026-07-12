import 'package:get_it/get_it.dart';

import 'package:currency_converter/core/network/oanor_api_client.dart';
import 'package:currency_converter/features/rates/data/datasources/local/rates_local_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/cascading_iran_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/frankfurter_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/oanor_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/datasources/remote/tgju_irr_remote_data_source.dart';
import 'package:currency_converter/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';
import 'package:currency_converter/features/rates/domain/usecases/convert_amount.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_historical_series.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';
import 'package:currency_converter/features/rates/domain/usecases/refresh_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/selected_currency_usecases.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_bloc.dart';

/// Registers rates feature dependencies (data, domain, Home BLoC).
///
/// Called from the root [setupLocator].
Future<void> setupRatesLocator(GetIt locator) async {
  // Data sources — Frankfurter (global FX) + Oanor IRR (TGJU fallback)
  locator.registerLazySingleton(() => OanorApiClient());
  locator.registerLazySingleton<RatesRemoteDataSource>(
    () => FrankfurterRemoteDataSource(apiClient: locator()),
  );
  // Oanor first; if key is not subscribed (402), TGJU supplies bazaar IRR.
  locator.registerLazySingleton<OanorIrrRemoteDataSource>(
    () => CascadingIranIrrRemoteDataSource(
      primary: OanorIrrRemoteDataSourceImpl(apiClient: locator()),
      fallback: TgjuIrrRemoteDataSource(),
    ),
  );
  locator.registerLazySingleton<RatesLocalDataSource>(
    () => RatesLocalDataSourceImpl(prefs: locator()),
  );

  // Repository
  locator.registerLazySingleton<RatesRepository>(
    () => RatesRepositoryImpl(
      remoteDataSource: locator(),
      oanorIrrRemoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => GetLatestRates(locator()));
  locator.registerLazySingleton(() => GetHistoricalSeries(locator()));
  locator.registerLazySingleton(() => GetSupportedCurrencies(locator()));
  locator.registerLazySingleton(() => ConvertAmount());
  locator.registerLazySingleton(() => GetSelectedCurrencies(locator()));
  locator.registerLazySingleton(() => AddSelectedCurrency(locator()));
  locator.registerLazySingleton(() => RemoveSelectedCurrency(locator()));
  locator.registerLazySingleton(() => ReorderSelectedCurrencies(locator()));
  locator.registerLazySingleton(() => SetBaseCurrency(locator()));
  locator.registerLazySingleton(() => RefreshRates(locator()));
  locator.registerLazySingleton(() => GetLastUpdatedAt(locator()));

  // BLoC — always factory
  locator.registerFactory(
    () => HomeBloc(
      getLatestRates: locator(),
      getSelectedCurrencies: locator(),
      setBaseCurrency: locator(),
      removeSelectedCurrency: locator(),
      reorderSelectedCurrencies: locator(),
      convertAmount: locator(),
      refreshRates: locator(),
      getSupportedCurrencies: locator(),
    ),
  );
}
