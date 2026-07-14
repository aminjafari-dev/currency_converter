import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/core/theme/app_theme_mode.dart';

/// App-wide theme cubit that persists the user's visual theme choice.
///
/// Register it as a lazy singleton and rebuild [MaterialApp.theme] from its
/// state so every page updates immediately after the user selects a theme.
///
/// Example:
/// ```dart
/// context.read<AppThemeCubit>().setTheme(AppThemeMode.light);
/// ```
class AppThemeCubit extends Cubit<AppThemeMode> {
  final SharedPreferences prefs;

  AppThemeCubit(this.prefs) : super(_readInitial(prefs));

  static AppThemeMode _readInitial(SharedPreferences prefs) {
    return AppThemeMode.fromStorageKey(
      prefs.getString(AppConstants.themeModeKey),
    );
  }

  /// Saves and applies the selected app theme.
  Future<void> setTheme(AppThemeMode mode) async {
    // Skip redundant writes; useful when the selected chip is tapped again.
    if (mode == state) return;

    await prefs.setString(AppConstants.themeModeKey, mode.storageKey);
    emit(mode);
  }
}
