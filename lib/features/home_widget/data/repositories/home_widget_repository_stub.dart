import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/features/home_widget/domain/entities/widget_snapshot.dart';
import 'package:currency_converter/features/home_widget/domain/repositories/home_widget_repository.dart';

/// Stub repository — logs intent until native widget providers are added.
///
/// TODO: call `HomeWidget.saveWidgetData` / `HomeWidget.updateWidget` once
/// Android Glance / iOS WidgetKit UI ships.
class HomeWidgetRepositoryStub implements HomeWidgetRepository {
  @override
  Future<Either<Failure, Unit>> updateWidget(WidgetSnapshot snapshot) async {
    // Domain-ready only: acknowledge the snapshot without native I/O.
    // ignore: avoid_print
    print(
      'HomeWidgetRepositoryStub: would publish '
      '${snapshot.rates.length} rates for base ${snapshot.base}',
    );
    return const Right(unit);
  }
}
