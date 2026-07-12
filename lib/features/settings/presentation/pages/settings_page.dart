import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/locale/locale_cubit.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/core/widgets/nerkhak_bottom_nav.dart';

/// Minimal Settings placeholder with language switcher (en / fa).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.settingsTitle,
          style: AppTextStyles.headlineMd(weight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: const NerkhakBottomNav(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GText(
              l10n.settingsLanguage,
              style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
            ),
            GGap.sm,
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return Row(
                  children: [
                    _LangChip(
                      label: l10n.settingsEnglish,
                      selected: locale.languageCode == 'en',
                      onTap: () => context
                          .read<LocaleCubit>()
                          .setLocale(const Locale('en')),
                    ),
                    GGap.hSm,
                    _LangChip(
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
              l10n.settingsPlaceholder,
              style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant),
            ),
            GGap.lg,
            GText(
              l10n.indicativeRatesDisclaimer,
              style: AppTextStyles.labelSm(
                color: AppColors.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryFixed : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: selected
                ? AppColors.primaryFixed
                : AppColors.surfaceContainerHighest,
          ),
        ),
        child: GText(
          label,
          style: AppTextStyles.labelSm(
            color: selected
                ? AppColors.onPrimaryFixed
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
