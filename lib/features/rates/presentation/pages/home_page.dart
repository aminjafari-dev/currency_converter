import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/router/route_args.dart';
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
          IconButton(
            tooltip: l10n.editList,
            onPressed: () {
              context.read<HomeBloc>().add(const HomeEvent.editModeToggled());
            },
            icon: const Icon(Icons.edit_outlined, color: AppColors.onSurfaceVariant),
          ),
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

              final baseCode = selected
                  .firstWhere((c) => c.isBase, orElse: () => selected.first)
                  .code;

              return RefreshIndicator(
                color: AppColors.primaryFixed,
                backgroundColor: AppColors.surfaceContainer,
                onRefresh: () async {
                  context.read<HomeBloc>().add(const HomeEvent.refreshed());
                  await context.read<HomeBloc>().stream.firstWhere(
                        (s) => s.load is HomeLoadCompleted || s.load is HomeLoadError,
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
                    final isBase = item.isBase;

                    return CurrencyRow(
                      code: item.code,
                      name: name,
                      amountText: CurrencyFormatter.format(amount, item.code),
                      isBase: isBase,
                      isEditMode: state.isEditMode,
                      onTap: () {
                        if (state.isEditMode) return;
                        if (isBase) return;
                        Navigator.of(context).pushNamed(
                          PageName.currencyDetail,
                          arguments: CurrencyDetailArgs(
                            code: item.code,
                            baseCode: baseCode,
                          ),
                        );
                      },
                      onLongPress: () {
                        context
                            .read<HomeBloc>()
                            .add(HomeEvent.baseChanged(code: item.code));
                      },
                      onRemove: () {
                        context
                            .read<HomeBloc>()
                            .add(HomeEvent.currencyRemoved(code: item.code));
                      },
                      onAmountChanged: isBase
                          ? (value) {
                              final parsed = double.tryParse(
                                value.replaceAll(',', ''),
                              );
                              if (parsed != null) {
                                context.read<HomeBloc>().add(
                                      HomeEvent.amountChanged(amount: parsed),
                                    );
                              }
                            }
                          : null,
                      amountValue: isBase ? baseAmount : null,
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
