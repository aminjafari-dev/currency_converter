import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:currency_converter/core/constants/app_constants.dart';

/// App-wide locale cubit — persists the user's language choice.
///
/// Register as a lazy singleton and drive [MaterialApp.locale] from its state.
///
/// Example:
/// ```dart
/// context.read<LocaleCubit>().setLocale(const Locale('fa'));
/// ```
class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences prefs;

  LocaleCubit(this.prefs)
      : super(_readInitial(prefs));

  static Locale _readInitial(SharedPreferences prefs) {
    final code = prefs.getString(AppConstants.localeKey);
    // Fall back to English when nothing has been saved yet.
    if (code == null || code.isEmpty) {
      return const Locale('en');
    }
    return Locale(code);
  }

  /// Supported locales for Orbit (English + Persian).
  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// Updates and persists the active locale.
  Future<void> setLocale(Locale locale) async {
    await prefs.setString(AppConstants.localeKey, locale.languageCode);
    emit(locale);
  }

  /// Convenience toggle between English and Persian.
  Future<void> toggle() async {
    final next = state.languageCode == 'fa'
        ? const Locale('en')
        : const Locale('fa');
    await setLocale(next);
  }
}
