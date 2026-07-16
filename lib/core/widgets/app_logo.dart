import 'package:flutter/material.dart';

import 'package:currency_converter/core/constants/image_path.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

/// Nerkhak brand logo rendered from [ImagePath.logo].
///
/// Use in AppBars, splash-style headers, and settings about sections.
/// Size defaults to 32 so it fits next to a title without dominating the bar.
///
/// Example:
/// ```dart
/// AppBar(title: Row(children: [AppLogo(), GGap.hSm, GText(l10n.appName)]));
/// ```
class AppLogo extends StatelessWidget {
  /// Display size (width & height). The source asset is square (2048×2048).
  final double size;

  /// Corner radius applied via [ClipRRect]. Matches app icon rounding feel.
  final double borderRadius;

  const AppLogo({
    super.key,
    this.size = 32,
    this.borderRadius = AppSpacing.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Semantics label keeps the mark accessible when shown without nearby text.
    return Semantics(
      label: l10n.appName,
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          ImagePath.logo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          // Filter quality helps the lime edges stay crisp when downscaled.
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
