import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:currency_converter/core/locale/locale_cubit.dart';
import 'package:currency_converter/core/network/api_client.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/features/currency_catalog/currency_catalog_di.dart';
import 'package:currency_converter/features/currency_detail/currency_detail_di.dart';
import 'package:currency_converter/features/home_widget/home_widget_di.dart';
import 'package:currency_converter/features/rates/rates_di.dart';

/// Global GetIt instance — prefer this name over mixing `getIt` / `locator`.
final GetIt locator = GetIt.instance;

/// Bootstraps core + feature DI. Call once from [main] before [runApp].
Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);

  // Frankfurter client (global FX). Oanor client is registered in rates_di.
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );
  locator.registerLazySingleton(() => LocaleCubit(locator()));

  await setupRatesLocator(locator);
  await setupCurrencyCatalogLocator(locator);
  await setupCurrencyDetailLocator(locator);
  await setupHomeWidgetLocator(locator);
}
