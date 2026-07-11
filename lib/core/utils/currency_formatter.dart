import 'package:intl/intl.dart';

import 'package:currency_converter/core/constants/app_constants.dart';

/// Formats currency amounts with per-code decimal rules (e.g. JPY = 0 decimals).
///
/// Example:
/// ```dart
/// CurrencyFormatter.format(185420, 'JPY'); // "185,420"
/// ```
abstract final class CurrencyFormatter {
  /// Formats [amount] for display under [currencyCode].
  static String format(double amount, String currencyCode, {String? locale}) {
    final decimals =
        AppConstants.zeroDecimalCurrencies.contains(currencyCode.toUpperCase())
            ? 0
            : 2;
    final formatter = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }

  /// Formats a rate with up to [fractionDigits] decimals (for detail/live rate).
  static String formatRate(double rate, {int fractionDigits = 4}) {
    return rate.toStringAsFixed(fractionDigits);
  }
}
