import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';

import 'package:currency_converter/features/home_widget/domain/entities/widget_snapshot.dart';

/// Contract for pushing [WidgetSnapshot] to the OS home-screen widget.
///
/// v1 ships a no-op stub — wire `home_widget` save/update once native UI exists.
abstract class HomeWidgetRepository {
  Future<Either<Failure, Unit>> updateWidget(WidgetSnapshot snapshot);
}
