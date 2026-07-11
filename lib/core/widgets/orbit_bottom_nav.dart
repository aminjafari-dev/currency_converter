import 'package:flutter/material.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/router/route_args.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';

/// Shared Orbit bottom navigation matching the Stitch design.
///
/// Indexes: 0 = Convert (Home), 1 = Chart (Detail entry), 2 = Settings.
///
/// Example:
/// ```dart
/// bottomNavigationBar: OrbitBottomNav(currentIndex: 0);
/// ```
class OrbitBottomNav extends StatelessWidget {
  final int currentIndex;

  /// Optional currency code used when tapping the Chart tab.
  final String? chartCurrencyCode;
  final String? chartBaseCode;

  const OrbitBottomNav({
    super.key,
    required this.currentIndex,
    this.chartCurrencyCode,
    this.chartBaseCode,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex && index != 1) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil(
          PageName.home,
          (route) => false,
        );
      case 1:
        final code = chartCurrencyCode ?? 'EUR';
        final base = chartBaseCode ?? 'USD';
        Navigator.of(context).pushNamed(
          PageName.currencyDetail,
          arguments: CurrencyDetailArgs(code: code, baseCode: base),
        );
      case 2:
        Navigator.of(context).pushNamed(PageName.settings);
    }
  }

  Widget _item({
    required BuildContext context,
    required int index,
    required IconData icon,
    required bool filled,
  }) {
    final selected = currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryFixed : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: selected ? AppColors.onPrimaryFixed : AppColors.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.surfaceContainerHighest),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(
              context: context,
              index: 0,
              icon: Icons.sync_alt,
              filled: true,
            ),
            _item(
              context: context,
              index: 1,
              icon: Icons.show_chart,
              filled: false,
            ),
            _item(
              context: context,
              index: 2,
              icon: Icons.settings,
              filled: false,
            ),
          ],
        ),
      ),
    );
  }
}
