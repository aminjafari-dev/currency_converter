import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/home_widget/domain/entities/widget_snapshot.dart';
import 'package:currency_converter/features/home_widget/domain/repositories/home_widget_repository.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';
import 'package:currency_converter/features/rates/domain/usecases/selected_currency_usecases.dart';

/// Builds a [WidgetSnapshot] from rates domain data and pushes it to the
/// (currently stubbed) home-widget repository.
///
/// Example:
/// ```dart
/// await buildHomeWidgetSnapshot(const NoParams());
/// ```
class BuildHomeWidgetSnapshot implements UseCase<WidgetSnapshot, NoParams> {
  final GetSelectedCurrencies getSelectedCurrencies;
  final GetLatestRates getLatestRates;
  final GetSupportedCurrencies getSupportedCurrencies;
  final HomeWidgetRepository homeWidgetRepository;

  BuildHomeWidgetSnapshot({
    required this.getSelectedCurrencies,
    required this.getLatestRates,
    required this.getSupportedCurrencies,
    required this.homeWidgetRepository,
  });

  @override
  Future<Either<Failure, WidgetSnapshot>> call(NoParams params) async {
    final selectedResult = await getSelectedCurrencies(params);
    List<SelectedCurrency>? selected;
    Failure? failure;
    selectedResult.fold((f) => failure = f, (s) => selected = s);
    if (failure != null || selected == null || selected!.isEmpty) {
      return Left(failure ?? const ValidationFailure('No currencies selected'));
    }

    final base = selected!
        .firstWhere((c) => c.isBase, orElse: () => selected!.first)
        .code;

    final ratesResult = await getLatestRates(GetLatestRatesParams(base: base));
    RateSnapshot? snapshot;
    ratesResult.fold((f) => failure = f, (s) => snapshot = s);
    if (failure != null || snapshot == null) {
      return Left(failure ?? const ServerFailure());
    }

    final names = <String, String>{};
    final catalogResult = await getSupportedCurrencies(params);
    catalogResult.fold((_) {}, (list) {
      for (final c in list) {
        names[c.code] = c.name;
      }
    });

    final quotes = selected!
        .where((c) => !c.isBase)
        .take(3)
        .map((c) {
          return WidgetCurrencyRate(
            code: c.code,
            name: names[c.code] ?? c.code,
            rate: snapshot!.rateFor(c.code) ?? 0,
            changePercent: 0,
          );
        })
        .toList();

    final widgetSnapshot = WidgetSnapshot(
      base: base,
      rates: quotes,
      updatedAt: snapshot!.fetchedAt,
    );

    await homeWidgetRepository.updateWidget(widgetSnapshot);
    return Right(widgetSnapshot);
  }
}
