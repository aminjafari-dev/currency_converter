import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_spacing.dart';

/// Shared Nerkhak scaffold — use instead of raw [Scaffold] in feature pages.
///
/// Example:
/// ```dart
/// return GScaffold(
///   extendBody: true,
///   appBar: AppBar(title: GText(l10n.appName)),
///   body: child,
///   bottomNavigationBar: NerkhakBottomNav(
///     currentIndex: index,
///     onTap: (i) => setState(() => index = i),
///   ),
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

  /// Reserves the standard 40 px page breathing room below feature content.
  ///
  /// Example: set to `false` on a shell scaffold when nested page scaffolds
  /// already reserve the bottom space.
  final bool reserveBottomSpace;

  const GScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.reserveBottomSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colors.surface,
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: reserveBottomSpace ? AppSpacing.pageBottomSpace : 0,
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
