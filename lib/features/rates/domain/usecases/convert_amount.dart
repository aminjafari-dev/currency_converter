import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';

/// Pure conversion helper — no I/O.
///
/// Given a [RateSnapshot]-style rate map (base→quote multipliers) and an
/// [amount] in [fromCode], returns the equivalent in [toCode] via triangular
/// conversion through the snapshot base.
///
/// Example:
/// ```dart
/// final result = convertAmount(ConvertAmountParams(
///   amount: 100,
///   fromCode: 'USD',
///   toCode: 'EUR',
///   base: snapshot.base,
///   rates: snapshot.rates,
/// ));
/// ```
class ConvertAmountParams {
  final double amount;
  final String fromCode;
  final String toCode;
  final String base;
  final Map<String, double> rates;

  const ConvertAmountParams({
    required this.amount,
    required this.fromCode,
    required this.toCode,
    required this.base,
    required this.rates,
  });
}

class ConvertAmount implements UseCase<double, ConvertAmountParams> {
  @override
  Future<Either<Failure, double>> call(ConvertAmountParams params) async {
    final from = params.fromCode.toUpperCase();
    final to = params.toCode.toUpperCase();
    final base = params.base.toUpperCase();

    // Same currency — identity.
    if (from == to) {
      return Right(params.amount);
    }

    double? rateOf(String code) {
      if (code == base) return 1.0;
      return params.rates[code];
    }

    final fromRate = rateOf(from);
    final toRate = rateOf(to);

    // Missing rates cannot be converted.
    if (fromRate == null || toRate == null || fromRate == 0) {
      return const Left(ValidationFailure('Missing rate for conversion'));
    }

    // Convert from → base → to.
    final inBase = params.amount / fromRate;
    final result = inBase * toRate;
    return Right(result);
  }
}
