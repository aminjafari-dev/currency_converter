import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/router/page_name.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/utils/currency_display_name.dart';
import 'package:currency_converter/core/utils/currency_formatter.dart';
import 'package:currency_converter/core/utils/relative_time_formatter.dart';
import 'package:currency_converter/core/widgets/g_button.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';
import 'package:currency_converter/features/rates/domain/entities/selected_currency.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_bloc.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_event.dart';
import 'package:currency_converter/features/rates/presentation/bloc/home_state.dart';
import 'package:currency_converter/features/rates/presentation/widgets/currency_row.dart';

/// Convert tab body – currency list (Stitch `01_home_currency_list`).
///
/// Tap any currency to edit its amount; siblings update via local conversion.
/// Tap the pen icon to enter edit mode — each card shows remove + drag handles.
/// Swipe a row (outside edit mode) to remove it. Long-press sets the base.
///
/// Expects an ancestor [HomeBloc] from [MainShellPage] — never create one here
/// so the Convert tab stays alive in the shell [IndexedStack].
///
/// Example:
/// ```dart
/// const HomePage();
/// ```
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const _HomeView();
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
          // Pen / done — toggles list-edit mode (remove + drag on each card).
          // Outline circle matches the Stitch home header next to the lime +.
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, next) => prev.isEditing != next.isEditing,
            builder: (context, state) {
              // Use `end` (not physical `right`) so RTL (fa) keeps space from
              // the screen edge — AppBar actions flip to the start side in RTL.
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: Tooltip(
                  message:
                      state.isEditing ? l10n.doneEditing : l10n.editList,
                  child: Material(
                    color: state.isEditing
                        ? AppColors.surfaceContainerHigh
                        : Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(const HomeEvent.editModeToggled());
                      },
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          // Check means "done editing"; pen means "enter edit mode".
                          state.isEditing ? Icons.check : Icons.edit_outlined,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Add currency — filled lime circle (always available).
          // Directional `end` padding mirrors LTR trailing margin in Persian RTL.
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: AppSpacing.containerMargin,
            ),
            child: Tooltip(
              message: l10n.addCurrencyAction,
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
          ),
        ],
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
                // Disable pull-to-refresh while rearranging — avoids fighting drag.
                notificationPredicate: state.isEditing
                    ? (_) => false
                    : defaultScrollNotificationPredicate,
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
                child: _CurrencyList(
                  selected: selected,
                  catalog: catalog,
                  convertedAmounts: convertedAmounts,
                  lastUpdated: lastUpdated,
                  isEditing: state.isEditing,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Scrollable currency list with an optional reorder mode and footer.
///
/// Uses [CustomScrollView] + [SliverReorderableList] so the sync/disclaimer
/// footer stays outside the reorderable region in both modes.
class _CurrencyList extends StatelessWidget {
  final List<SelectedCurrency> selected;
  final Map<String, Currency> catalog;
  final Map<String, double> convertedAmounts;
  final DateTime? lastUpdated;
  final bool isEditing;

  const _CurrencyList({
    required this.selected,
    required this.catalog,
    required this.convertedAmounts,
    required this.lastUpdated,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Currency cards — reorderable when [isEditing] is true.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.md,
            AppSpacing.containerMargin,
            0,
          ),
          sliver: SliverReorderableList(
            itemCount: selected.length,
            // onReorderItem already adjusts newIndex when moving downward —
            // do not subtract 1 again in the BLoC.
            onReorderItem: (oldIndex, newIndex) {
              // Ignore accidental long-press drags outside edit mode.
              if (!isEditing) return;
              context.read<HomeBloc>().add(
                    HomeEvent.currenciesReordered(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                  );
            },
            itemBuilder: (context, index) {
              final item = selected[index];
              final l10n = AppLocalizations.of(context);
              final name = CurrencyDisplayName.resolve(
                l10n,
                item.code,
                fallback: catalog[item.code]?.name ?? item.code,
              );
              final amount = convertedAmounts[item.code] ?? 0;

              final row = CurrencyRow(
                code: item.code,
                name: name,
                amountText: CurrencyFormatter.format(amount, item.code),
                isEditing: isEditing,
                dragIndex: index,
                onRemove: isEditing
                    ? () {
                        context.read<HomeBloc>().add(
                              HomeEvent.currencyRemoved(code: item.code),
                            );
                      }
                    : null,
                onLongPress: isEditing
                    ? null
                    : () {
                        context.read<HomeBloc>().add(
                              HomeEvent.baseChanged(code: item.code),
                            );
                      },
                onAmountChanged: isEditing
                    ? null
                    : (value) {
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
              );

              // Spacing between cards — SliverReorderableList has no separatorBuilder.
              final padded = Padding(
                key: ValueKey('currency-${item.code}'),
                padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                child: isEditing
                    // Edit mode: row already exposes remove + drag; no swipe.
                    ? row
                    // Normal mode: keep swipe-to-remove as a secondary path.
                    : Dismissible(
                        key: ValueKey('dismiss-${item.code}'),
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
                        child: row,
                      ),
              );

              return padded;
            },
          ),
        ),
        // Footer (sync time + disclaimer) — never part of the reorderable set.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.xl,
            AppSpacing.containerMargin,
            AppSpacing.xl,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
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
            ),
          ),
        ),
      ],
    );
  }
}
