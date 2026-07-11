/// Named route constants for Orbit.
///
/// Always navigate with [PageName] values — never hardcode "/..." strings.
///
/// Example:
/// ```dart
/// Navigator.of(context).pushNamed(PageName.addCurrency);
/// ```
abstract final class PageName {
  static const String home = '/home';
  static const String addCurrency = '/addCurrency';
  static const String currencyDetail = '/currencyDetail';
  static const String settings = '/settings';
}
