import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:currency_converter/features/currency_detail/domain/entities/range_option.dart';

part 'detail_event.freezed.dart';

@freezed
sealed class DetailEvent with _$DetailEvent {
  const factory DetailEvent.started({
    required String code,
    required String baseCode,
  }) = DetailStarted;

  const factory DetailEvent.rangeChanged({required RangeOption range}) =
      DetailRangeChanged;

  const factory DetailEvent.refreshed() = DetailRefreshed;
}
