import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/constants/app_constants.dart';
import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/utils/currency_display_name.dart';
import 'package:currency_converter/core/widgets/currency_flag.dart';
import 'package:currency_converter/core/widgets/g_button.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_bloc.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_event.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_state.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';

/// Add Currency screen matching Stitch `03_add_currency`.
class AddCurrencyPage extends StatelessWidget {
  const AddCurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<AddCurrencyBloc>()..add(const AddCurrencyEvent.started()),
      child: const _AddCurrencyView(),
    );
  }
}

class _AddCurrencyView extends StatelessWidget {
  const _AddCurrencyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GText(
          l10n.addCurrencyTitle,
          style: AppTextStyles.headlineMd(weight: FontWeight.w700),
        ),
        actions: const [
          // Directional `end` so trailing icon keeps screen-edge inset in RTL.
          Padding(
            padding: EdgeInsetsDirectional.only(
              end: AppSpacing.containerMargin,
            ),
            child: Icon(Icons.language, color: AppColors.primaryFixed),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              AppSpacing.lg,
              AppSpacing.containerMargin,
              AppSpacing.md,
            ),
            child: TextField(
              onChanged: (q) {
                context
                    .read<AddCurrencyBloc>()
                    .add(AddCurrencyEvent.searchChanged(query: q));
              },
              // Far Homa when locale is `fa` so Persian search input matches UI copy.
              style: AppTextStyles.localize(
                AppTextStyles.bodyMd(),
                Localizations.localeOf(context),
              ),
              decoration: InputDecoration(
                hintText: l10n.searchCurrencyHint,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AddCurrencyBloc, AddCurrencyState>(
              builder: (context, state) {
                return state.load.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryFixed,
                    ),
                  ),
                  error: (message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GText(message),
                        GGap.md,
                        GButton(
                          label: l10n.retry,
                          onPressed: () => context
                              .read<AddCurrencyBloc>()
                              .add(const AddCurrencyEvent.started()),
                        ),
                      ],
                    ),
                  ),
                  completed: (all, filtered, selectedCodes, query) {
                    if (filtered.isEmpty) {
                      return Center(child: GText(l10n.emptySearch));
                    }

                    final popular = AppConstants.popularCurrencies
                        .map((code) {
                          try {
                            return filtered.firstWhere((c) => c.code == code);
                          } catch (_) {
                            return null;
                          }
                        })
                        .whereType<Currency>()
                        .toList();

                    final alphabetical = filtered
                        .where(
                          (c) =>
                              !AppConstants.popularCurrencies.contains(c.code),
                        )
                        .toList();

                    final sections = <_Section>[];
                    // Show Popular only when not actively searching.
                    if (query.trim().isEmpty && popular.isNotEmpty) {
                      sections.add(
                        _Section(title: l10n.popularSection, items: popular),
                      );
                    }

                    String? currentLetter;
                    var bucket = <Currency>[];
                    for (final c in alphabetical) {
                      final letter = c.code.isNotEmpty
                          ? c.code[0].toUpperCase()
                          : '#';
                      if (currentLetter == null) {
                        currentLetter = letter;
                        bucket = [c];
                      } else if (letter == currentLetter) {
                        bucket.add(c);
                      } else {
                        sections.add(
                          _Section(title: currentLetter, items: bucket),
                        );
                        currentLetter = letter;
                        bucket = [c];
                      }
                    }
                    if (currentLetter != null && bucket.isNotEmpty) {
                      sections.add(
                        _Section(title: currentLetter, items: bucket),
                      );
                    }

                    // When searching, flatten into a single list section.
                    if (query.trim().isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.containerMargin,
                          0,
                          AppSpacing.containerMargin,
                          AppSpacing.xl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final c = filtered[index];
                          return _CurrencyCatalogTile(
                            currency: c,
                            isSelected: selectedCodes.contains(c.code),
                            isTrending: AppConstants.trendingCurrencies
                                .contains(c.code),
                            trendingLabel: l10n.trendingBadge,
                            onToggle: () {
                              context.read<AddCurrencyBloc>().add(
                                    AddCurrencyEvent.toggled(code: c.code),
                                  );
                            },
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.containerMargin,
                        0,
                        AppSpacing.containerMargin,
                        AppSpacing.xl,
                      ),
                      itemCount: sections.length,
                      itemBuilder: (context, sectionIndex) {
                        final section = sections[sectionIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GGap.md,
                            Row(
                              children: [
                                GText(
                                  section.title.toUpperCase(),
                                  style: AppTextStyles.labelSm(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                GGap.hMd,
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.surfaceContainerHighest,
                                  ),
                                ),
                              ],
                            ),
                            GGap.sm,
                            ...section.items.map(
                              (c) => _CurrencyCatalogTile(
                                currency: c,
                                isSelected: selectedCodes.contains(c.code),
                                isTrending: AppConstants.trendingCurrencies
                                    .contains(c.code),
                                trendingLabel: l10n.trendingBadge,
                                onToggle: () {
                                  context.read<AddCurrencyBloc>().add(
                                        AddCurrencyEvent.toggled(code: c.code),
                                      );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Section {
  final String title;
  final List<Currency> items;
  const _Section({required this.title, required this.items});
}

class _CurrencyCatalogTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final bool isTrending;
  final String trendingLabel;
  final VoidCallback onToggle;

  const _CurrencyCatalogTile({
    required this.currency,
    required this.isSelected,
    required this.isTrending,
    required this.trendingLabel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Material(
        color: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                CurrencyFlag(code: currency.code, size: 40),
                GGap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GText(
                            currency.code,
                            style: AppTextStyles.numeralMd(),
                          ),
                          if (isTrending) ...[
                            GGap.hXs,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: GText(
                                trendingLabel,
                                style: AppTextStyles.labelSm(
                                  color: AppColors.primaryFixed,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      GText(
                        CurrencyDisplayName.resolve(
                          l10n,
                          currency.code,
                          fallback: currency.name,
                        ),
                        style: AppTextStyles.bodyMd(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryFixed
                        : Colors.transparent,
                    border: Border.all(color: AppColors.primaryFixed),
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected
                        ? AppColors.onPrimaryFixed
                        : AppColors.primaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
