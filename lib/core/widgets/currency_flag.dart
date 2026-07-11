import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_colors.dart';

/// Circular flag avatar for a currency code.
///
/// Uses `country_flags` [CountryFlag.fromCurrencyCode] so we do not need a
/// separate country-code map for most currencies.
///
/// Example:
/// ```dart
/// CurrencyFlag(code: 'EUR', size: 48);
/// ```
class CurrencyFlag extends StatelessWidget {
  final String code;
  final double size;

  const CurrencyFlag({
    super.key,
    required this.code,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceContainerHighest),
        color: AppColors.surfaceContainerLow,
      ),
      clipBehavior: Clip.antiAlias,
      child: CountryFlag.fromCurrencyCode(
        code,
        width: size,
        height: size,
        shape: const Circle(),
      ),
    );
  }
}
