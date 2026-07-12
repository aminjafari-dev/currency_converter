import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

/// Persistent notch bottom bar for [MainShellPage].
///
/// Does **not** navigate — the shell switches an [IndexedStack] via [onTap]
/// so this widget stays mounted across tab changes.
///
/// Indexes: 0 = Convert, 1 = Chart, 2 = Settings.
///
/// Example:
/// ```dart
/// NerkhakBottomNav(
///   currentIndex: tabIndex,
///   onTap: (i) => setState(() => tabIndex = i),
/// );
/// ```
class NerkhakBottomNav extends StatefulWidget {
  final int currentIndex;

  /// Called when the user selects a tab. Host should update [currentIndex].
  final ValueChanged<int> onTap;

  const NerkhakBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<NerkhakBottomNav> createState() => _NerkhakBottomNavState();
}

class _NerkhakBottomNavState extends State<NerkhakBottomNav> {
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant NerkhakBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate the notch when the shell updates the selected tab index.
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.jumpTo(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BottomBarItem _item({
    required IconData icon,
    required String label,
  }) {
    return BottomBarItem(
      inActiveItem: Icon(icon, color: AppColors.onSurfaceVariant),
      activeItem: Icon(icon, color: AppColors.onPrimaryFixed),
      itemLabel: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: AppColors.surfaceContainerLowest,
      notchColor: AppColors.primaryFixed,
      kIconSize: 24,
      kBottomRadius: AppSpacing.radiusXl,
      showLabel: true,
      showShadow: false,
      removeMargins: false,
      durationInMilliSeconds: 300,
      elevation: 0,
      itemLabelStyle: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 10,
      ),
      bottomBarItems: [
        _item(icon: Icons.sync_alt, label: l10n.navConvert),
        _item(icon: Icons.show_chart, label: l10n.navChart),
        _item(icon: Icons.settings, label: l10n.navSettings),
      ],
      onTap: widget.onTap,
    );
  }
}
