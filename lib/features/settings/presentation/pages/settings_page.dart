import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/locale/locale_cubit.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_theme_cubit.dart';
import 'package:currency_converter/core/theme/app_theme_mode.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/widgets/app_logo.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';

/// Settings tab with language and visual theme selectors.
///
/// Hosted inside [MainShellPage]; the shell owns the bottom navigation bar.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.settingsTitle,
          style: AppTextStyles.headlineMd(weight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GText(
              l10n.settingsLanguage,
              style: AppTextStyles.labelSm(color: colors.onSurfaceVariant),
            ),
            GGap.sm,
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return Row(
                  children: [
                    _SettingsChip(
                      label: l10n.settingsEnglish,
                      selected: locale.languageCode == 'en',
                      onTap: () => context
                          .read<LocaleCubit>()
                          .setLocale(const Locale('en')),
                    ),
                    GGap.hSm,
                    _SettingsChip(
                      label: l10n.settingsPersian,
                      selected: locale.languageCode == 'fa',
                      onTap: () => context
                          .read<LocaleCubit>()
                          .setLocale(const Locale('fa')),
                    ),
                  ],
                );
              },
            ),
            GGap.xl,
            GText(
              l10n.settingsTheme,
              style: AppTextStyles.labelSm(color: colors.onSurfaceVariant),
            ),
            GGap.sm,
            BlocBuilder<AppThemeCubit, AppThemeMode>(
              builder: (context, mode) {
                return Row(
                  children: [
                    _SettingsChip(
                      label: l10n.settingsThemeDark,
                      selected: mode == AppThemeMode.dark,
                      onTap: () => context
                          .read<AppThemeCubit>()
                          .setTheme(AppThemeMode.dark),
                    ),
                    GGap.hSm,
                    _SettingsChip(
                      label: l10n.settingsThemeLight,
                      selected: mode == AppThemeMode.light,
                      onTap: () => context
                          .read<AppThemeCubit>()
                          .setTheme(AppThemeMode.light),
                    ),
                  ],
                );
              },
            ),
            GGap.lg,
            GText(
              l10n.indicativeRatesDisclaimer,
              style: AppTextStyles.labelSm(
                color: colors.onSurfaceVariant,
              ),
            ),
            GGap.xl,
            // Brand footer — reinforces identity under settings options.
            const Center(
              child: AppLogo(size: 56, borderRadius: AppSpacing.radiusXl),
            ),
            GGap.sm,
            Center(
              child: GText(
                l10n.appName,
                style: AppTextStyles.labelSm(color: colors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SettingsChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: selected ? colors.primary : colors.surfaceContainerHighest,
          ),
        ),
        child: GText(
          label,
          style: AppTextStyles.labelSm(
            color: selected ? colors.onPrimary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
