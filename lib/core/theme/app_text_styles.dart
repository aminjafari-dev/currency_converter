import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:currency_converter/core/theme/app_colors.dart';

/// Typography tokens from the Stitch Orbit design system.
///
/// Inter is used for UI copy; JetBrains Mono is used for rates/numerals.
/// Prefer these helpers over ad-hoc [TextStyle] literals.
///
/// Example:
/// ```dart
/// Text('1,240.00', style: AppTextStyles.numeralXl());
/// ```
abstract final class AppTextStyles {
  /// Large brand / page title (32 / 40, weight 600).
  static TextStyle headlineLg({Color? color}) => GoogleFonts.inter(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02 * 32,
        color: color ?? AppColors.onSurface,
      );

  /// Mobile page title (24 / 32, weight 600).
  static TextStyle headlineLgMobile({Color? color}) => GoogleFonts.inter(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01 * 24,
        color: color ?? AppColors.onSurface,
      );

  /// Section / currency code title (20 / 28, weight 500).
  static TextStyle headlineMd({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? AppColors.onSurface,
      );

  /// Body large (18 / 26).
  static TextStyle bodyLg({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        height: 26 / 18,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  /// Body medium (16 / 24).
  static TextStyle bodyMd({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.onSurface,
      );

  /// Small uppercase labels (12 / 16, weight 600).
  static TextStyle labelSm({Color? color}) => GoogleFonts.inter(
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
}
