import 'package:flutter/material.dart';

/// Design tokens extracted from the Stitch Nerkhak export.
///
/// Always consume colors through [AppTheme] / [ThemeData] rather than
/// hardcoding these values in feature widgets.
///
/// Example:
/// ```dart
/// final colors = Theme.of(context).colorScheme;
/// Container(color: AppColors.surfaceContainer);
/// ```
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFF131315);
  static const Color surface = Color(0xFF131315);
  static const Color surfaceDim = Color(0xFF131315);
  static const Color surfaceContainerLowest = Color(0xFF0E0E10);
  static const Color surfaceContainerLow = Color(0xFF1B1B1D);
  static const Color surfaceContainer = Color(0xFF1F1F21);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2C);
  static const Color surfaceContainerHighest = Color(0xFF353437);
  static const Color surfaceBright = Color(0xFF39393B);
  static const Color surfaceVariant = Color(0xFF353437);

  // Accent / lime
  static const Color primaryFixed = Color(0xFFC6F24E);
  static const Color primaryFixedDim = Color(0xFFABD533);
  static const Color onPrimaryFixed = Color(0xFF151F00);
  static const Color onPrimaryFixedVariant = Color(0xFF3A4D00);
  static const Color onPrimaryContainer = Color(0xFF536D00);
  static const Color inversePrimary = Color(0xFF4F6700);
  static const Color onPrimary = Color(0xFF273500);
  static const Color surfaceTint = Color(0xFFABD533);

  // Text / neutrals
  static const Color onSurface = Color(0xFFE4E2E4);
  static const Color onBackground = Color(0xFFE4E2E4);
  static const Color onSurfaceVariant = Color(0xFFC4C9B0);
  static const Color onTertiaryContainer = Color(0xFF636468);
  static const Color secondary = Color(0xFFC8C6C8);
  static const Color secondaryContainer = Color(0xFF474649);
  static const Color outline = Color(0xFF8E937C);
  static const Color outlineVariant = Color(0xFF444936);
  static const Color primary = Color(0xFFFFFFFF);

  // Error / down-trend
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  /// Soft lime fill used behind insight cards (primary-fixed at ~5% opacity).
  static Color primaryFixedMuted = primaryFixed.withValues(alpha: 0.05);

  /// Soft lime border used around insight cards.
  static Color primaryFixedBorder = primaryFixed.withValues(alpha: 0.20);
}
