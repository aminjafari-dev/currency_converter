import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';

/// Shared Nerkhak text widget — prefer this over raw [Text] in feature UI.
///
/// Pass a [style] from [AppTextStyles], or rely on the default body style.
/// When the app locale is Persian (`fa`), UI styles are remapped to Far Homa
/// via [AppTextStyles.localize] so Iranian copy uses the bundled face.
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
    final locale = Localizations.maybeLocaleOf(context);
    final base = style ?? AppTextStyles.bodyMd(color: AppColors.onSurface);

    return Text(
      data,
      // Remap Nunito → Far Homa for `fa` without callers changing every screen.
      style: AppTextStyles.localize(base, locale),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
