import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

import 'package:currency_converter/core/locator.dart';
import 'package:currency_converter/core/router/route_args.dart';
import 'package:currency_converter/core/theme/app_colors.dart';
import 'package:currency_converter/core/theme/app_spacing.dart';
import 'package:currency_converter/core/theme/app_text_styles.dart';
import 'package:currency_converter/core/utils/currency_formatter.dart';
import 'package:currency_converter/core/widgets/currency_flag.dart';
import 'package:currency_converter/core/widgets/g_button.dart';
import 'package:currency_converter/core/widgets/g_gap.dart';
import 'package:currency_converter/core/widgets/g_scaffold.dart';
import 'package:currency_converter/core/widgets/g_text.dart';
import 'package:currency_converter/core/widgets/nerkhak_bottom_nav.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/range_option.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_bloc.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_event.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_state.dart';

/// Currency Detail & Chart screen matching Stitch `02_currency_detail_chart`.
class CurrencyDetailPage extends StatelessWidget {
  final CurrencyDetailArgs args;

  const CurrencyDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<DetailBloc>()
        ..add(DetailEvent.started(code: args.code, baseCode: args.baseCode)),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
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
      case RangeOption.all:
        return l10n.rangeAll;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GScaffold(
      bottomNavigationBar: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          final load = state.load;
          return NerkhakBottomNav(
            currentIndex: 1,
            chartCurrencyCode:
                load is DetailLoadCompleted ? load.code : null,
            chartBaseCode:
                load is DetailLoadCompleted ? load.baseCode : null,
          );
        },
      ),
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          return state.load.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryFixed),
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
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.background,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Row(
                      children: [
                        CurrencyFlag(code: code, size: 24),
                        GGap.hXs,
                        GText(
                          code,
                          style: AppTextStyles.headlineMd(weight: FontWeight.w700),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: AppSpacing.containerMargin,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GText(
                              l10n.liveRate,
                              style: AppTextStyles.labelSm(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            GText(
                              CurrencyFormatter.formatRate(liveRate),
                              style: AppTextStyles.numeralMd(
                                color: AppColors.primaryFixed,
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
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            GGap.hXs,
                            GText(
                              CurrencyFormatter.formatRate(liveRate, fractionDigits: 2),
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
                              color: up
                                  ? AppColors.primaryFixed
                                  : AppColors.error,
                              size: 18,
                            ),
                            GGap.hXs,
                            GText(
                              l10n.percentToday(
                                up ? '+' : '',
                                todayPercent.abs().toStringAsFixed(2),
                              ),
                              style: AppTextStyles.labelSm(
                                color: up
                                    ? AppColors.primaryFixed
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        GGap.xl,
                        Container(
                          height: 220,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXl),
                            border: Border.all(
                              color: AppColors.surfaceContainerHighest,
                            ),
                          ),
                          child: spots.length < 2
                              ? const Center(child: GText('—'))
                              : LineChart(
                                  LineChartData(
                                    gridData: const FlGridData(show: false),
                                    titlesData:
                                        const FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipColor: (_) =>
                                            AppColors.surfaceContainerHigh,
                                        getTooltipItems: (touched) {
                                          return touched.map((t) {
                                            return LineTooltipItem(
                                              t.y.toStringAsFixed(3),
                                              AppTextStyles.numeralMd(
                                                color: AppColors.primaryFixed,
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
                                        color: AppColors.primaryFixed,
                                        barWidth: 3,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors.primaryFixed
                                                  .withValues(alpha: 0.2),
                                              AppColors.primaryFixed
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
                            color: AppColors.surfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(
                              color: AppColors.surfaceContainerHighest,
                            ),
                          ),
                          child: Row(
                            children: RangeOption.values.map((option) {
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
                                          ? AppColors.primaryFixed
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
                                            ? AppColors.onPrimaryFixed
                                            : AppColors.onSurfaceVariant,
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
                              valueColor: AppColors.primaryFixed,
                            ),
                          ],
                        ),
                        GGap.lg,
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixedMuted,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXl),
                            border: Border.all(
                              color: AppColors.primaryFixedBorder,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.insights,
                                  color: AppColors.primaryFixed,
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
                                        color: AppColors.primaryFixed,
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.surfaceContainerHighest),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GText(
              label,
              style: AppTextStyles.labelSm(color: AppColors.onSurfaceVariant),
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
