import 'package:flutter/material.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/router/route_args.dart';
import 'package:currency_converter/features/currency_catalog/presentation/pages/add_currency_page.dart';
import 'package:currency_converter/features/currency_detail/presentation/pages/currency_detail_page.dart';
import 'package:currency_converter/features/rates/presentation/pages/home_page.dart';
import 'package:currency_converter/features/settings/presentation/pages/settings_page.dart';

/// Central named-route table for Orbit.
///
/// Example:
/// ```dart
/// MaterialApp(routes: PageRouter.routes, initialRoute: PageName.home);
/// ```
abstract final class PageRouter {
  static Map<String, WidgetBuilder> routes = {
    PageName.home: (_) => const HomePage(),
    PageName.addCurrency: (_) => const AddCurrencyPage(),
    PageName.settings: (_) => const SettingsPage(),
    PageName.currencyDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final detailArgs = args is CurrencyDetailArgs
          ? args
          : const CurrencyDetailArgs(code: 'EUR', baseCode: 'USD');
      return CurrencyDetailPage(args: detailArgs);
    },
  };
}
