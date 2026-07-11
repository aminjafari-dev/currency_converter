import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';

/// Shared Orbit text widget — prefer this over raw [Text] in feature UI.
///
/// Pass a [style] from [AppTextStyles], or rely on the default body style.
///
/// Example:
/// ```dart
/// GText(l10n.appName, style: AppTextStyles.headlineMd(weight: FontWeight.w800));
/// ```
class GText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const GText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style ?? AppTextStyles.bodyMd(color: AppColors.onSurface),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
