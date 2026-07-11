import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:currency_converter/core/bloc/app_bloc_observer.dart';
import 'package:currency_converter/core/locale/locale_cubit.dart';
import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/router/page_router.dart';
import 'package:currency_converter/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  Bloc.observer = AppBlocObserver();
  runApp(const OrbitApp());
}

/// Root Orbit application widget.
class OrbitApp extends StatelessWidget {
  const OrbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Orbit',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark(),
            locale: locale,
            supportedLocales: LocaleCubit.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: PageName.home,
            routes: PageRouter.routes,
          );
        },
      ),
    );
  }
}
