import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

/// Resolves a display name for a currency code, with l10n overrides.
///
/// Synthetic **IRT** (Toman) is not in Frankfurter — we localize it here.
///
/// Example:
/// ```dart
/// CurrencyDisplayName.resolve(l10n, 'IRT', fallback: 'Iranian Toman');
/// ```
abstract final class CurrencyDisplayName {
  /// Returns a localized name when we have one; otherwise [fallback].
  static String resolve(
    AppLocalizations l10n,
    String code, {
    required String fallback,
  }) {
    // Useful so Persian UI shows «تومان ایران» instead of the English catalog stub.
    if (code.toUpperCase() == AppConstants.iranianTomanCode) {
      return l10n.currencyIranianToman;
    }
    if (code.toUpperCase() == AppConstants.iranianRialCode) {
      return l10n.currencyIranianRial;
    }
    return fallback;
  }
}
