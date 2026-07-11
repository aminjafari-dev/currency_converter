import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:currency_converter/features/currency_detail/domain/entities/currency_stats.dart';
import 'package:currency_converter/features/currency_detail/domain/entities/range_option.dart';
import 'package:currency_converter/features/rates/domain/entities/historical_series.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_snapshot.dart';

part 'detail_state.freezed.dart';

@freezed
sealed class DetailLoadState with _$DetailLoadState {
  const factory DetailLoadState.initial() = DetailLoadInitial;
  const factory DetailLoadState.loading() = DetailLoadLoading;
  const factory DetailLoadState.completed({
    required String code,
    required String baseCode,
    required String currencyName,
    required double liveRate,
    required double todayPercent,
    required HistoricalSeries series,
    required CurrencyStats stats,
    required RangeOption range,
    required RateSnapshot snapshot,
  }) = DetailLoadCompleted;
  const factory DetailLoadState.error(String message) = DetailLoadError;
}

@freezed
sealed class DetailState with _$DetailState {
  const factory DetailState({
    required DetailLoadState load,
  }) = _DetailState;
}
