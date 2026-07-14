import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

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
    // External index changes should move the notch, but user taps are already
    // handled inside AnimatedNotchBottomBar before the shell rebuilds.
    if (oldWidget.currentIndex != widget.currentIndex &&
        _controller.index != widget.currentIndex) {
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
    required Color inactiveColor,
    required Color activeColor,
  }) {
    return BottomBarItem(
      inActiveItem: Icon(icon, color: inactiveColor),
      activeItem: Icon(icon, color: activeColor),
      itemLabel: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: colors.surfaceContainerHigh,
      notchColor: colors.primary,
      kIconSize: 24,
      kBottomRadius: AppSpacing.radiusXl,
      showLabel: true,
      showShadow: false,
      removeMargins: false,
      durationInMilliSeconds: 180,
      elevation: 0,
      itemLabelStyle: TextStyle(
        color: colors.onSurface,
        fontSize: 10,
      ),
      bottomBarItems: [
        _item(
          icon: Icons.sync_alt,
          label: l10n.navConvert,
          inactiveColor: colors.onSurface,
          activeColor: colors.onPrimary,
        ),
        _item(
          icon: Icons.show_chart,
          label: l10n.navChart,
          inactiveColor: colors.onSurface,
          activeColor: colors.onPrimary,
        ),
        _item(
          icon: Icons.settings,
          label: l10n.navSettings,
          inactiveColor: colors.onSurface,
          activeColor: colors.onPrimary,
        ),
      ],
      onTap: widget.onTap,
    );
  }
}
