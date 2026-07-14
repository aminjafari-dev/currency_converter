import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:currency_converter/core/theme/app_fonts.dart';

/// Builds Nerkhak [ThemeData] variants from the shared design system.
///
/// Wire this into [MaterialApp.theme]. Pass the active [locale] so Persian
/// builds use Far Homa as the default Material text family.
///
/// Example:
/// ```dart
/// MaterialApp(theme: AppTheme.light(locale: locale));
/// ```
abstract final class AppTheme {
  static const ColorScheme _darkScheme = ColorScheme.dark(
    primary: Color(0xFFC6F24E),
    onPrimary: Color(0xFF151F00),
    primaryContainer: Color(0xFFC6F24E),
    onPrimaryContainer: Color(0xFF536D00),
    secondary: Color(0xFFC8C6C8),
    onSecondary: Color(0xFF151F00),
    secondaryContainer: Color(0xFF474649),
    onSecondaryContainer: Color(0xFFE4E2E4),
    surface: Color(0xFF131315),
    onSurface: Color(0xFFE4E2E4),
    onSurfaceVariant: Color(0xFFC4C9B0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    outline: Color(0xFF8E937C),
    outlineVariant: Color(0xFF444936),
    surfaceContainerLowest: Color(0xFF0E0E10),
    surfaceContainerLow: Color(0xFF1B1B1D),
    surfaceContainer: Color(0xFF1F1F21),
    surfaceContainerHigh: Color(0xFF2A2A2C),
    surfaceContainerHighest: Color(0xFF353437),
  );

  static const ColorScheme _lightScheme = ColorScheme.light(
    primary: Color(0xFF5F7800),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFC6F24E),
    onPrimaryContainer: Color(0xFF151F00),
    secondary: Color(0xFF60634F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE4E8D8),
    onSecondaryContainer: Color(0xFF1D2114),
    surface: Color(0xFFF8FAF1),
    onSurface: Color(0xFF1B1D16),
    onSurfaceVariant: Color(0xFF596047),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    outline: Color(0xFF777D67),
    outlineVariant: Color(0xFFC8CEB7),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F5EA),
    surfaceContainer: Color(0xFFECEFDF),
    surfaceContainerHigh: Color(0xFFE4E8D7),
    surfaceContainerHighest: Color(0xFFD8DDC9),
  );

  /// Dark Nerkhak theme used across the whole app.
  ///
  /// When [locale] is Persian, [ThemeData.fontFamily] and the text theme use
  /// Far Homa so Material defaults (AppBar, SnackBar, Input hints) match
  /// Iranian UI copy. Latin locales keep Nunito via Google Fonts.
  static ThemeData dark({Locale? locale}) {
    return _build(
      locale: locale,
      brightness: Brightness.dark,
      colorScheme: _darkScheme,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  /// Light Nerkhak theme for users who prefer a brighter interface.
  ///
  /// Uses the same lime identity color as the dark theme while swapping surface
  /// and text roles to Material light values.
  static ThemeData light({Locale? locale}) {
    return _build(
      locale: locale,
      brightness: Brightness.light,
      colorScheme: _lightScheme,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData _build({
    required Locale? locale,
    required Brightness brightness,
    required ColorScheme colorScheme,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final isPersian = AppFonts.isPersian(locale);

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      // Default family for widgets that don't set an explicit TextStyle.
      fontFamily: isPersian ? AppFonts.farHoma : null,
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
    );

    final TextTheme textTheme = isPersian
        ? base.textTheme.apply(
            fontFamily: AppFonts.farHoma,
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          )
        : GoogleFonts.nunitoTextTheme(base.textTheme).apply(
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: systemOverlayStyle,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.surfaceContainerHighest,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: isPersian ? AppFonts.farHoma : null,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontFamily: isPersian ? AppFonts.farHoma : null,
        ),
      ),
    );
  }
}
