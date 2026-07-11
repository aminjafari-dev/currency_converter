/// Arguments passed to [PageName.currencyDetail] via [RouteSettings.arguments].
///
/// Example:
/// ```dart
/// Navigator.of(context).pushNamed(
///   PageName.currencyDetail,
///   arguments: CurrencyDetailArgs(code: 'EUR', baseCode: 'USD'),
/// );
/// ```
class CurrencyDetailArgs {
  /// Target currency ISO code (e.g. EUR).
  final String code;

  /// Base currency ISO code used for the conversion line (e.g. USD).
  final String baseCode;

  const CurrencyDetailArgs({
    required this.code,
    this.baseCode = 'USD',
  });
}
