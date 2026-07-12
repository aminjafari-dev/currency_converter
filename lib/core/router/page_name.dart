/// Named route constants for Nerkhak.
///
/// Always navigate with [PageName] values — never hardcode "/..." strings.
/// Convert / Chart / Settings are tabs inside [MainShellPage] (`home`), not
/// separate push routes.
///
/// Example:
/// ```dart
/// Navigator.of(context).pushNamed(PageName.addCurrency);
/// ```
abstract final class PageName {
  /// Main shell (Convert / Chart / Settings tabs).
  static const String home = '/home';
  static const String addCurrency = '/addCurrency';

  /// Standalone chart route (optional deep link); prefer the Chart tab in shell.
  static const String currencyDetail = '/currencyDetail';
}
