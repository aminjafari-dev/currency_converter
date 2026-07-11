import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/error/failures.dart';
import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/currency_stats.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/range_option.dart';
import 'package:currency_converter/features/currency_detail/domain/usecases/compute_currency_stats.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_event.dart';
import 'package:currency_converter/features/currency_detail/presentation/bloc/detail_state.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_historical_series.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rates.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_supported_currencies.dart';

/// BLoC for Currency Detail & Chart.
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetLatestRates getLatestRates;
  final GetHistoricalSeries getHistoricalSeries;
  final GetSupportedCurrencies getSupportedCurrencies;
  final ComputeCurrencyStats computeCurrencyStats;

  String _code = 'EUR';
  String _baseCode = 'USD';
  RangeOption _range = RangeOption.oneMonth;

  DetailBloc({
    required this.getLatestRates,
    required this.getHistoricalSeries,
    required this.getSupportedCurrencies,
    required this.computeCurrencyStats,
  }) : super(const DetailState(load: DetailLoadState.initial())) {
    on<DetailEvent>((event, emit) async {
      await event.when(
        started: (code, baseCode) => _onStarted(code, baseCode, emit),
        rangeChanged: (range) => _onRangeChanged(range, emit),
        refreshed: () => _load(emit),
      );
    });
  }

  Future<void> _onStarted(
    String code,
    String baseCode,
    Emitter<DetailState> emit,
  ) async {
    _code = code.toUpperCase();
    _baseCode = baseCode.toUpperCase();
    _range = RangeOption.oneMonth;
    if (!emit.isDone) {
      emit(state.copyWith(load: const DetailLoadState.loading()));
    }
    await _load(emit);
  }

  Future<void> _onRangeChanged(
    RangeOption range,
    Emitter<DetailState> emit,
  ) async {
    _range = range;
    if (!emit.isDone) {
      emit(state.copyWith(load: const DetailLoadState.loading()));
    }
    await _load(emit);
  }

  Future<void> _load(Emitter<DetailState> emit) async {
    final ratesResult =
        await getLatestRates(GetLatestRatesParams(base: _baseCode));
    RateSnapshot? snapshot;
    Failure? failure;
    ratesResult.fold((f) => failure = f, (s) => snapshot = s);
    if (failure != null || snapshot == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: DetailLoadState.error(
            failure?.message ?? 'Failed to load rate',
          ),
        ));
      }
      return;
    }

    final liveRate = snapshot!.rateFor(_code) ?? 0;

    final seriesResult = await getHistoricalSeries(
      GetHistoricalSeriesParams(
        base: _baseCode,
        quote: _code,
        start: _range.startDate(),
        end: DateTime.now(),
      ),
    );

    HistoricalSeries? series;
    seriesResult.fold(
      (f) => failure = f,
      (s) => series = s,
    );
    if (series == null) {
      if (!emit.isDone) {
        emit(state.copyWith(
          load: DetailLoadState.error(
            failure?.message ?? 'Failed to load chart',
          ),
        ));
      }
      return;
    }

    final statsResult = await computeCurrencyStats(series!);
    CurrencyStats stats = const CurrencyStats(high: 0, low: 0, percentChange: 0);
    statsResult.fold((_) {}, (s) => stats = s);

    // Approximate "today" change from the last two points when available.
    double todayPercent = stats.percentChange;
    if (series!.points.length >= 2) {
      final prev = series!.points[series!.points.length - 2].rate;
      final last = series!.points.last.rate;
      if (prev != 0) {
        todayPercent = ((last - prev) / prev) * 100;
      }
    }

    String name = _code;
    final catalog = await getSupportedCurrencies(const NoParams());
    catalog.fold((_) {}, (list) {
      for (final c in list) {
        if (c.code == _code) name = c.name;
      }
    });

    if (!emit.isDone) {
      emit(state.copyWith(
        load: DetailLoadState.completed(
          code: _code,
          baseCode: _baseCode,
          currencyName: name,
          liveRate: liveRate,
          todayPercent: todayPercent,
          series: series!,
          stats: stats,
          range: _range,
          snapshot: snapshot!,
        ),
      ));
    }
  }
}
