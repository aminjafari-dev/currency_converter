import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_colors.dart';

/// Shared Orbit scaffold — use instead of raw [Scaffold] in feature pages.
///
/// Example:
/// ```dart
/// return GScaffold(
///   appBar: AppBar(title: GText(l10n.appName)),
///   body: child,
///   bottomNavigationBar: const OrbitBottomNav(currentIndex: 0),
/// );
/// ```
class GScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const GScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
