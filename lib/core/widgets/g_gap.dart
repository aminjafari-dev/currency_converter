import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:currency_converter/core/theme/app_spacing.dart';

/// Shared Gap wrappers matching the Nerkhak spacing scale.
///
/// Use these instead of [SizedBox] / raw [Gap] with magic numbers.
///
/// Example:
/// ```dart
/// Column(children: [header, GGap.md, body]);
/// ```
abstract final class GGap {
  static const Widget base = Gap(AppSpacing.base);
  static const Widget xs = Gap(AppSpacing.xs);
  static const Widget sm = Gap(AppSpacing.sm);
  static const Widget gutter = Gap(AppSpacing.gutter);
  static const Widget md = Gap(AppSpacing.md);
  static const Widget lg = Gap(AppSpacing.lg);
  static const Widget xl = Gap(AppSpacing.xl);

  /// Horizontal variants for Row layouts.
  static const Widget hBase = Gap(AppSpacing.base);
  static const Widget hXs = Gap(AppSpacing.xs);
  static const Widget hSm = Gap(AppSpacing.sm);
  static const Widget hGutter = Gap(AppSpacing.gutter);
  static const Widget hMd = Gap(AppSpacing.md);
  static const Widget hLg = Gap(AppSpacing.lg);
}
