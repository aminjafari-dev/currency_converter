import 'package:get_it/get_it.dart';

import 'package:currency_converter/features/home_widget/data/repositories/home_widget_repository_stub.dart';
import 'package:currency_converter/features/home_widget/domain/repositories/home_widget_repository.dart';
import 'package:currency_converter/features/home_widget/domain/usecases/build_home_widget_snapshot.dart';

/// Registers home-widget feature dependencies (domain-ready, stub data).
Future<void> setupHomeWidgetLocator(GetIt locator) async {
  locator.registerLazySingleton<HomeWidgetRepository>(
    () => HomeWidgetRepositoryStub(),
  );
  locator.registerLazySingleton(
    () => BuildHomeWidgetSnapshot(
      getSelectedCurrencies: locator(),
      getLatestRates: locator(),
      getSupportedCurrencies: locator(),
      homeWidgetRepository: locator(),
    ),
  );
}
