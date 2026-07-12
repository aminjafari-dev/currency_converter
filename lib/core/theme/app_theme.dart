import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_fonts.dart';

/// Builds the dark Nerkhak [ThemeData] from Stitch design tokens.
///
/// Wire this into [MaterialApp.theme]. Pass the active [locale] so Persian
/// builds use Far Homa as the default Material text family.
///
/// Do not invent a light theme for v1 — the Stitch export is dark-only.
///
/// Example:
/// ```dart
/// MaterialApp(theme: AppTheme.dark(locale: locale));
/// ```
abstract final class AppTheme {
  /// Dark Nerkhak theme used across the whole app.
  ///
  /// When [locale] is Persian, [ThemeData.fontFamily] and the text theme use
  /// Far Homa so Material defaults (AppBar, SnackBar, Input hints) match
  /// Iranian UI copy. Latin locales keep Nunito via Google Fonts.
  static ThemeData dark({Locale? locale}) {
    final isPersian = AppFonts.isPersian(locale);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Default family for widgets that don't set an explicit TextStyle.
      fontFamily: isPersian ? AppFonts.farHoma : null,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryFixed,
        onPrimary: AppColors.onPrimaryFixed,
        primaryContainer: AppColors.primaryFixed,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.surfaceContainerHigh,
        secondaryContainer: AppColors.secondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
      ),
    );

    final TextTheme textTheme = isPersian
        ? base.textTheme.apply(
            fontFamily: AppFonts.farHoma,
            bodyColor: AppColors.onSurface,
            displayColor: AppColors.onSurface,
          )
        : GoogleFonts.nunitoTextTheme(base.textTheme).apply(
            bodyColor: AppColors.onSurface,
            displayColor: AppColors.onSurface,
          );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceContainerHighest,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryFixed),
        ),
        hintStyle: TextStyle(
          color: AppColors.onTertiaryContainer,
          fontFamily: isPersian ? AppFonts.farHoma : null,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontFamily: isPersian ? AppFonts.farHoma : null,
        ),
      ),
    );
  }
}
