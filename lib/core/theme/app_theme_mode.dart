import 'package:flutter/material.dart';

import 'package:currency_converter/core/theme/app_theme.dart';

/// App-level theme choices that can be saved and restored.
///
/// Store [storageKey] in local preferences and call [theme] when building
/// [MaterialApp].
///
/// Example:
/// ```dart
/// final themeData = AppThemeMode.light.theme(locale: locale);
/// ```
enum AppThemeMode {
  dark('dark'),
  light('light');

  final String storageKey;

  const AppThemeMode(this.storageKey);

  /// Restores a theme option from persisted storage.
  static AppThemeMode fromStorageKey(String? key) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.storageKey == key,
      orElse: () => AppThemeMode.dark,
    );
  }

  /// Resolves this selection to the concrete Flutter [ThemeData].
  ThemeData theme({Locale? locale}) {
    return switch (this) {
      AppThemeMode.dark => AppTheme.dark(locale: locale),
      AppThemeMode.light => AppTheme.light(locale: locale),
    };
  }
}
