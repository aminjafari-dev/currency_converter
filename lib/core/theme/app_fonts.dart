import 'package:flutter/material.dart';

/// Font family tokens for Nerkhak.
///
/// Latin UI uses Google Fonts (Nunito / JetBrains Mono). Persian (`fa`) UI copy
/// uses the bundled Far Homa face from `assets/font/Far_Homa/`.
///
/// Example:
/// ```dart
/// style.copyWith(fontFamily: AppFonts.uiFamily(locale));
/// ```
abstract final class AppFonts {
  /// Bundled Far Homa family registered in [pubspec.yaml].
  static const String farHoma = 'FarHoma';

  /// Whether [locale] should render Iranian/Persian UI text with Far Homa.
  ///
  /// Useful before swapping [TextStyle.fontFamily] in theme helpers.
  static bool isPersian(Locale? locale) => locale?.languageCode == 'fa';

  /// Returns Far Homa for Persian locales; otherwise `null` so callers keep
  /// their Latin Google Fonts family (Nunito).
  ///
  /// Example: `GoogleFonts.nunito(...).copyWith(fontFamily: AppFonts.uiFamily(locale))`
  static String? uiFamily(Locale? locale) =>
      isPersian(locale) ? farHoma : null;
}
