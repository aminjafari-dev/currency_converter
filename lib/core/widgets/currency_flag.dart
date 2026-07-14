import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

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
    // IRT is synthetic (IRR ÷ 10) — reuse the Iranian flag from IRR.
    final flagCode = code.toUpperCase() == 'IRT' ? 'IRR' : code;
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.surfaceContainerHighest),
        color: colors.surfaceContainerLow,
      ),
      clipBehavior: Clip.antiAlias,
      child: CountryFlag.fromCurrencyCode(
        flagCode,
        width: size,
        height: size,
        shape: const Circle(),
      ),
    );
  }
}
