import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/utils/currency_display_name.dart';
import 'package:currency_converter/core/utils/currency_formatter.dart';
import 'package:currency_converter/core/widgets/currency_flag.dart';
import 'package:currency_converter/core/widgets/g_button.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_bloc.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_event.dart';
import 'package:currency_converter/features/currency_catalog/presentation/bloc/add_currency_state.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/range_option.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_bloc.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_event.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_state.dart';
import 'package:currency_converter/features/rates/domain/entities/currency.dart';

/// Currency Detail & Chart tab body (Stitch `02_currency_detail_chart`).
///
/// Expects an ancestor [DetailBloc] from [MainShellPage] — never create one
/// here so the Chart tab stays alive in the shell [IndexedStack].
///
/// Example:
/// ```dart
/// const CurrencyDetailPage();
/// ```
class CurrencyDetailPage extends StatelessWidget {
  const CurrencyDetailPage({super.key});

  @override
  Widget build(BuildContext context) => const _DetailView();
}

class _DetailView extends StatelessWidget {
  /// Chart ranges shown in the selector.
  ///
  /// Example: `_visibleRanges.map((range) => _rangeLabel(l10n, range))`.
  static const List<RangeOption> _visibleRanges = [
    RangeOption.oneDay,
    RangeOption.oneWeek,
    RangeOption.oneMonth,
    RangeOption.sixMonths,
    RangeOption.oneYear,
  ];

  const _DetailView();

  String _rangeLabel(AppLocalizations l10n, RangeOption range) {
    switch (range) {
      case RangeOption.oneDay:
        return l10n.rangeOneDay;
      case RangeOption.oneWeek:
        return l10n.rangeOneWeek;
      case RangeOption.oneMonth:
        return l10n.rangeOneMonth;
      case RangeOption.sixMonths:
        return l10n.rangeSixMonths;
      case RangeOption.oneYear:
        return l10n.rangeOneYear;
    }
  }

  /// Opens the chart currency picker and reloads [DetailBloc] with the chosen
  /// quote currency while keeping the current base.
  ///
  /// Example: tapping `EUR` in the Chart app bar can restart the chart as
  /// `GBP/USD` without changing the Convert tab list.
  Future<void> _changeChartCurrency(
    BuildContext context, {
    required String code,
    required String baseCode,
  }) async {
    final detailBloc = context.read<DetailBloc>();
    final colors = Theme.of(context).colorScheme;

    final selectedCode = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (_) {
        return BlocProvider(
          create: (_) =>
              locator<AddCurrencyBloc>()..add(const AddCurrencyEvent.started()),
          child: _ChartCurrencyPickerSheet(
            currentCode: code,
            baseCode: baseCode,
          ),
        );
      },
    );

    if (selectedCode == null || selectedCode == code) return;
    detailBloc.add(DetailEvent.started(code: selectedCode, baseCode: baseCode));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return GScaffold(
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          return state.load.when(
            initial: () => const SizedBox.shrink(),
            loading: () => Center(
              child: CircularProgressIndicator(color: colors.primary),
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
                        .read<DetailBloc>()
                        .add(const DetailEvent.refreshed()),
                  ),
                ],
              ),
            ),
            completed: (
              code,
              baseCode,
              currencyName,
              liveRate,
              todayPercent,
              series,
              stats,
              range,
              snapshot,
            ) {
              final up = todayPercent >= 0;
              final spots = <FlSpot>[];
              for (var i = 0; i < series.points.length; i++) {
                spots.add(FlSpot(i.toDouble(), series.points[i].rate));
              }

              return CustomScrollView(
                slivers: [
                  // No leading back — Chart is a shell tab, not a pushed route.
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: colors.surface,
                    automaticallyImplyLeading: false,
                    title: Tooltip(
                      message: l10n.changeChartCurrency,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        onTap: () {
                          _changeChartCurrency(
                            context,
                            code: code,
                            baseCode: baseCode,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CurrencyFlag(code: code, size: 24),
                              GGap.hXs,
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GText(
                                      code,
                                      style: AppTextStyles.headlineMd(
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                    GText(
                                      currencyName,
                                      style: AppTextStyles.labelSm(
                                        color: colors.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GGap.hXs,
                              Icon(
                                Icons.expand_more,
                                size: 20,
                                color: colors.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: AppSpacing.containerMargin,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GText(
                              l10n.liveRate,
                              style: AppTextStyles.labelSm(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            GText(
                              CurrencyFormatter.formatRate(liveRate),
                              style: AppTextStyles.numeralMd(
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.containerMargin),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            GText(
                              l10n.conversionLine(baseCode),
                              style: AppTextStyles.labelSm(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            GGap.hXs,
                            GText(
                              CurrencyFormatter.formatRate(liveRate,
                                  fractionDigits: 2),
                              style: AppTextStyles.numeralXl(),
                            ),
                            GGap.hXs,
                            GText(code, style: AppTextStyles.headlineMd()),
                          ],
                        ),
                        GGap.xs,
                        Row(
                          children: [
                            Icon(
                              up ? Icons.trending_up : Icons.trending_down,
                              color: up ? colors.primary : colors.error,
                              size: 18,
                            ),
                            GGap.hXs,
                            GText(
                              l10n.percentToday(
                                up ? '+' : '',
                                todayPercent.abs().toStringAsFixed(2),
                              ),
                              style: AppTextStyles.labelSm(
                                color: up ? colors.primary : colors.error,
                              ),
                            ),
                          ],
                        ),
                        GGap.xl,
                        Container(
                          height: 220,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXl),
                            border: Border.all(
                              color: colors.surfaceContainerHighest,
                            ),
                          ),
                          child: spots.length < 2
                              ? const Center(child: GText('—'))
                              : LineChart(
                                  LineChartData(
                                    gridData: const FlGridData(show: false),
                                    titlesData: const FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipColor: (_) =>
                                            colors.surfaceContainerHigh,
                                        getTooltipItems: (touched) {
                                          return touched.map((t) {
                                            return LineTooltipItem(
                                              t.y.toStringAsFixed(3),
                                              AppTextStyles.numeralMd(
                                                color: colors.primary,
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: spots,
                                        isCurved: true,
                                        color: colors.primary,
                                        barWidth: 3,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              colors.primary
                                                  .withValues(alpha: 0.2),
                                              colors.primary
                                                  .withValues(alpha: 0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        GGap.lg,
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(
                              color: colors.surfaceContainerHighest,
                            ),
                          ),
                          child: Row(
                            children: _visibleRanges.map((option) {
                              final selected = option == range;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<DetailBloc>().add(
                                          DetailEvent.rangeChanged(
                                            range: option,
                                          ),
                                        );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? colors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusFull,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: GText(
                                      _rangeLabel(l10n, option),
                                      style: AppTextStyles.labelSm(
                                        color: selected
                                            ? colors.onPrimary
                                            : colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        GGap.lg,
                        Row(
                          children: [
                            _StatCard(
                              label: l10n.statHigh,
                              value: CurrencyFormatter.formatRate(
                                stats.high,
                                fractionDigits: 3,
                              ),
                            ),
                            GGap.hGutter,
                            _StatCard(
                              label: l10n.statLow,
                              value: CurrencyFormatter.formatRate(
                                stats.low,
                                fractionDigits: 3,
                              ),
                            ),
                            GGap.hGutter,
                            _StatCard(
                              label: l10n.statPercentChange,
                              value:
                                  '${stats.percentChange >= 0 ? '+' : ''}${stats.percentChange.toStringAsFixed(1)}%',
                              valueColor: colors.primary,
                            ),
                          ],
                        ),
                        GGap.lg,
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.05),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXl),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg,
                                  ),
                                ),
                                child: Icon(
                                  Icons.insights,
                                  color: colors.primary,
                                ),
                              ),
                              GGap.hMd,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GText(
                                      l10n.nerkhakInsightTitle,
                                      style: AppTextStyles.labelSm(
                                        color: colors.primary,
                                      ),
                                    ),
                                    GGap.xs,
                                    GText(
                                      l10n.nerkhakInsightBody(currencyName),
                                      style: AppTextStyles.bodyMd(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GGap.xl,
                      ]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Bottom sheet used by the Chart tab to choose the quote currency.
///
/// It reuses [AddCurrencyBloc] for catalog loading and search, but it only
/// returns the tapped currency code; it does not add/remove Home currencies.
class _ChartCurrencyPickerSheet extends StatelessWidget {
  final String currentCode;
  final String baseCode;

  const _ChartCurrencyPickerSheet({
    required this.currentCode,
    required this.baseCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.md,
            AppSpacing.containerMargin,
            0,
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              GGap.md,
              Row(
                children: [
                  Expanded(
                    child: GText(
                      l10n.chartCurrencyPickerTitle,
                      style: AppTextStyles.headlineMd(
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              GGap.md,
              TextField(
                onChanged: (query) {
                  context
                      .read<AddCurrencyBloc>()
                      .add(AddCurrencyEvent.searchChanged(query: query));
                },
                style: AppTextStyles.localize(
                  AppTextStyles.bodyMd(color: colors.onSurface),
                  Localizations.localeOf(context),
                ),
                decoration: InputDecoration(
                  hintText: l10n.searchCurrencyHint,
                  prefixIcon: Icon(
                    Icons.search,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              GGap.md,
              Expanded(
                child: BlocBuilder<AddCurrencyBloc, AddCurrencyState>(
                  builder: (context, state) {
                    return state.load.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                          color: colors.primary,
                        ),
                      ),
                      error: (message) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GText(message, textAlign: TextAlign.center),
                            GGap.md,
                            GButton(
                              label: l10n.retry,
                              onPressed: () {
                                context.read<AddCurrencyBloc>().add(
                                      const AddCurrencyEvent.started(),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                      completed: (all, filtered, selectedCodes, query) {
                        final currencies = filtered
                            .where(
                              (currency) =>
                                  currency.code.toUpperCase() !=
                                  baseCode.toUpperCase(),
                            )
                            .toList();

                        if (currencies.isEmpty) {
                          return Center(child: GText(l10n.emptySearch));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: currencies.length,
                          itemBuilder: (context, index) {
                            final currency = currencies[index];
                            return _ChartCurrencyPickerTile(
                              currency: currency,
                              currentCode: currentCode,
                              onTap: () {
                                Navigator.of(context).pop(currency.code);
                              },
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
      },
    );
  }
}

/// Single currency row inside the Chart picker.
///
/// Shows the localized currency name and a check icon for the chart's current
/// quote so the user can recognize the active selection before changing it.
class _ChartCurrencyPickerTile extends StatelessWidget {
  final Currency currency;
  final String currentCode;
  final VoidCallback onTap;

  const _ChartCurrencyPickerTile({
    required this.currency,
    required this.currentCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final isCurrent = currency.code.toUpperCase() == currentCode.toUpperCase();
    final name = CurrencyDisplayName.resolve(
      l10n,
      currency.code,
      fallback: currency.name,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Material(
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: isCurrent
                ? colors.primary
                : colors.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          onTap: onTap,
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
                      GText(
                        currency.code,
                        style: AppTextStyles.numeralMd(),
                      ),
                      GText(
                        name,
                        style: AppTextStyles.bodyMd(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Icon(
                    Icons.check_circle,
                    color: colors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: colors.surfaceContainerHighest),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GText(
              label,
              style: AppTextStyles.labelSm(color: colors.onSurfaceVariant),
            ),
            GGap.xs,
            GText(
              value,
              style: AppTextStyles.numeralMd(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}
