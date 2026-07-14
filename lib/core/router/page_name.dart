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

  /// Push route to pick and add a currency to the home list.
  static const String addCurrency = '/addCurrency';
}
