import 'package:flutter/material.dart';

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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colors.surface,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
