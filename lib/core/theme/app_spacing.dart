/// Spacing scale from the Stitch Orbit export.
///
/// Prefer these constants (and [GGap]) instead of magic numbers.
///
/// Example:
/// ```dart
/// Padding(padding: EdgeInsets.all(AppSpacing.md), child: child);
/// ```
abstract final class AppSpacing {
  static const double base = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double gutter = 12;
  static const double md = 16;
  static const double containerMargin = 20;
  static const double lg = 24;
  static const double xl = 32;

  static const double radiusDefault = 4;
  static const double radiusLg = 8;
  static const double radiusXl = 12;
  static const double radiusFull = 999;
}
