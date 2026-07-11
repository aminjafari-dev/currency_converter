import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/utils/currency_formatter.dart';
import 'package:currency_converter/core/utils/relative_time_formatter.dart';
import 'package:currency_converter/core/widgets/g_button.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/core/widgets/orbit_bottom_nav.dart';
import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_bloc.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_event.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_state.dart';
import 'package:currency_converter/features/rates/presentation/widgets/currency_row.dart';

/// Home – Currency List screen matching Stitch `01_home_currency_list`.
///
/// Tap any currency to edit its amount; siblings update via local conversion.
/// Swipe a row to remove it. Long-press sets the persisted base for refresh.
///
/// Example:
/// ```dart
/// Navigator.pushNamed(context, PageName.home);
/// ```
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HomeBloc>()..add(const HomeEvent.started()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.appName.toUpperCase(),
          style: AppTextStyles.headlineMd(weight: FontWeight.w800),
        ),
        actions: [
          // Add currency — the only app-bar action (edit pen removed).
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.containerMargin),
            child: Material(
              color: AppColors.primaryFixed,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  await Navigator.of(context).pushNamed(PageName.addCurrency);
                  if (context.mounted) {
                    context.read<HomeBloc>().add(const HomeEvent.started());
                  }
                },
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.add, color: AppColors.onPrimaryFixed),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final load = state.load;
          String? chartCode;
          String? baseCode;
          if (load is HomeLoadCompleted) {
            baseCode = load.selected
                .firstWhere((c) => c.isBase, orElse: () => load.selected.first)
                .code;
            chartCode = load.selected
                .firstWhere((c) => !c.isBase, orElse: () => load.selected.first)
                .code;
          }
          return OrbitBottomNav(
            currentIndex: 0,
            chartCurrencyCode: chartCode,
            chartBaseCode: baseCode,
          );
        },
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.load.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryFixed),
            ),
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GText(message, textAlign: TextAlign.center),
                    GGap.md,
                    GButton(
                      label: l10n.retry,
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(const HomeEvent.refreshed());
                      },
                    ),
                  ],
                ),
              ),
            ),
            completed: (
              snapshot,
              selected,
              catalog,
              convertedAmounts,
              baseAmount,
              lastUpdated,
            ) {
              if (selected.isEmpty) {
                return Center(child: GText(l10n.emptyCurrencies));
              }

              return RefreshIndicator(
                color: AppColors.primaryFixed,
                backgroundColor: AppColors.surfaceContainer,
                onRefresh: () async {
                  context.read<HomeBloc>().add(const HomeEvent.refreshed());
                  await context.read<HomeBloc>().stream.firstWhere(
                        (s) =>
                            s.load is HomeLoadCompleted ||
                            s.load is HomeLoadError,
                      );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.containerMargin,
                    AppSpacing.md,
                    AppSpacing.containerMargin,
                    AppSpacing.xl,
                  ),
                  itemCount: selected.length + 1,
                  separatorBuilder: (_, __) => GGap.gutter,
                  itemBuilder: (context, index) {
                    // Footer after the list.
                    if (index == selected.length) {
                      return Column(
                        children: [
                          GGap.xl,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.sync,
                                size: 14,
                                color: AppColors.onTertiaryContainer,
                              ),
                              GGap.hXs,
                              GText(
                                l10n.ratesUpdated(
                                  RelativeTimeFormatter.format(
                                    context,
                                    lastUpdated,
                                  ),
                                ),
                                style: AppTextStyles.labelSm(
                                  color: AppColors.onTertiaryContainer,
                                ),
                              ),
                            ],
                          ),
                          GGap.md,
                          Container(
                            width: 64,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          GGap.sm,
                          GText(
                            l10n.indicativeRatesDisclaimer,
                            style: AppTextStyles.labelSm(
                              color: AppColors.onTertiaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }

                    final item = selected[index];
                    final name = catalog[item.code]?.name ?? item.code;
                    final amount = convertedAmounts[item.code] ?? 0;

                    // Swipe to remove replaces the old pen + edit-mode affordance.
                    return Dismissible(
                      key: ValueKey('currency-${item.code}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                      onDismissed: (_) {
                        context.read<HomeBloc>().add(
                              HomeEvent.currencyRemoved(code: item.code),
                            );
                      },
                      child: CurrencyRow(
                        code: item.code,
                        name: name,
                        amountText:
                            CurrencyFormatter.format(amount, item.code),
                        onLongPress: () {
                          context.read<HomeBloc>().add(
                                HomeEvent.baseChanged(code: item.code),
                              );
                        },
                        onAmountChanged: (value) {
                          final parsed = double.tryParse(
                            value.replaceAll(',', ''),
                          );
                          // Ignore incomplete input (e.g. empty / lone ".") so
                          // we do not reset sibling amounts mid-keystroke.
                          if (parsed != null) {
                            context.read<HomeBloc>().add(
                                  HomeEvent.amountChanged(
                                    code: item.code,
                                    amount: parsed,
                                  ),
                                );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
