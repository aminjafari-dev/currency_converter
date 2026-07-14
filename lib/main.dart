import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:currency_converter/core/bloc/app_bloc_observer.dart';
import 'package:currency_converter/core/locale/locale_cubit.dart';
import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/router/page_router.dart';
import 'package:currency_converter/core/theme/app_theme_cubit.dart';
import 'package:currency_converter/core/theme/app_theme_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  Bloc.observer = AppBlocObserver();
  runApp(const NerkhakApp());
}

/// Root Nerkhak application widget.
///
/// Example: `runApp(const NerkhakApp());`
class NerkhakApp extends StatelessWidget {
  const NerkhakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<LocaleCubit>()),
        BlocProvider.value(value: locator<AppThemeCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<AppThemeCubit, AppThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appName,
                debugShowCheckedModeBanner: false,
                // Theme and locale rebuild together so Persian fonts stay correct
                // after switching between the dark and light palettes.
                theme: themeMode.theme(locale: locale),
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
          );
        },
      ),
    );
  }
}
