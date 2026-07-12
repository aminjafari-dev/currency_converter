import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_fonts.dart';

/// Typography tokens from the Stitch Nerkhak design system.
///
/// Nunito is used for Latin UI copy; JetBrains Mono for rates/numerals.
/// When the locale is Persian (`fa`), UI copy styles resolve to Far Homa via
/// [localize] / [GText] — numerals stay mono so amounts stay aligned.
///
/// Prefer these helpers over ad-hoc [TextStyle] literals.
///
/// Example:
/// ```dart
/// Text('1,240.00', style: AppTextStyles.numeralXl());
/// GText(l10n.appName, style: AppTextStyles.headlineMd()); // Far Homa when fa
/// ```
abstract final class AppTextStyles {
  /// Large brand / page title (32 / 40, weight 600).
  static TextStyle headlineLg({Color? color}) => GoogleFonts.nunito(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02 * 32,
        color: color ?? AppColors.onSurface,
      );

  /// Mobile page title (24 / 32, weight 600).
  static TextStyle headlineLgMobile({Color? color}) => GoogleFonts.nunito(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01 * 24,
        color: color ?? AppColors.onSurface,
      );

  /// Section / currency code title (20 / 28, weight 500).
  static TextStyle headlineMd({Color? color, FontWeight? weight}) =>
      GoogleFonts.nunito(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? AppColors.onSurface,
      );

  /// Body large (18 / 26).
  static TextStyle bodyLg({Color? color}) => GoogleFonts.nunito(
        fontSize: 18,
        height: 26 / 18,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  /// Body medium (16 / 24).
  static TextStyle bodyMd({Color? color}) => GoogleFonts.nunito(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  /// Small uppercase labels (12 / 16, weight 600).
  static TextStyle labelSm({Color? color}) => GoogleFonts.nunito(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05 * 12,
        color: color ?? AppColors.onSurfaceVariant,
      );

  /// Large mono numeral used for converted amounts (40 / 48).
  static TextStyle numeralXl({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.04 * 40,
        color: color ?? AppColors.onSurface,
      );

  /// Medium mono numeral used for rates / stats (18 / 24).
  static TextStyle numeralMd({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.onSurface,
      );

  /// Swaps Latin UI fonts to Far Homa when [locale] is Persian.
  ///
  /// Mono numeral styles are left unchanged so rate amounts keep tabular
  /// alignment. Call from [GText] (or any widget that has a [BuildContext]).
  ///
  /// Example:
  /// ```dart
  /// final style = AppTextStyles.localize(
  ///   AppTextStyles.bodyMd(),
  ///   Localizations.localeOf(context),
  /// );
  /// ```
  static TextStyle localize(TextStyle style, Locale? locale) {
    // Persian UI copy → Far Homa; keep JetBrains Mono for rates/amounts.
    if (!AppFonts.isPersian(locale) || _isMonoNumeral(style)) {
      return style;
    }

    return style.copyWith(
      fontFamily: AppFonts.farHoma,
      // Far Homa is a single face — drop Nunito's tight tracking for RTL copy.
      letterSpacing: 0,
      fontFamilyFallback: const <String>[],
    );
  }

  /// True when [style] is a JetBrains Mono numeral token (not Iranian UI copy).
  static bool _isMonoNumeral(TextStyle style) {
    final family = style.fontFamily?.toLowerCase() ?? '';
    return family.contains('jet') || family.contains('mono');
  }
}
