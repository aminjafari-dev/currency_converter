import 'package:flutter/material.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/features/currency_catalog/presentation/pages/add_currency_page.dart';
import 'package:currency_converter/features/main_shell/presentation/pages/main_shell_page.dart';

/// Central named-route table for Nerkhak.
///
/// Tab screens (Convert / Chart / Settings) live inside [MainShellPage] so the
/// bottom nav is not rebuilt on tab change. Only pushed flows use extra routes.
///
/// Example:
/// ```dart
/// MaterialApp(routes: PageRouter.routes, initialRoute: PageName.home);
/// ```
abstract final class PageRouter {
  static Map<String, WidgetBuilder> routes = {
    // Shell owns IndexedStack tabs + persistent bottom navigation.
    PageName.home: (_) => const MainShellPage(),
    PageName.addCurrency: (_) => const AddCurrencyPage(),
  };
}
