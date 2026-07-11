// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DetailLoadState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailLoadState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailLoadState()';
  }
}

/// @nodoc
class $DetailLoadStateCopyWith<$Res> {
  $DetailLoadStateCopyWith(
      DetailLoadState _, $Res Function(DetailLoadState) __);
}

/// Adds pattern-matching-related methods to [DetailLoadState].
extension DetailLoadStatePatterns on DetailLoadState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailLoadInitial value)? initial,
    TResult Function(DetailLoadLoading value)? loading,
    TResult Function(DetailLoadCompleted value)? completed,
    TResult Function(DetailLoadError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial() when initial != null:
        return initial(_that);
      case DetailLoadLoading() when loading != null:
        return loading(_that);
      case DetailLoadCompleted() when completed != null:
        return completed(_that);
      case DetailLoadError() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailLoadInitial value) initial,
    required TResult Function(DetailLoadLoading value) loading,
    required TResult Function(DetailLoadCompleted value) completed,
    required TResult Function(DetailLoadError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial():
        return initial(_that);
      case DetailLoadLoading():
        return loading(_that);
      case DetailLoadCompleted():
        return completed(_that);
      case DetailLoadError():
        return error(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailLoadInitial value)? initial,
    TResult? Function(DetailLoadLoading value)? loading,
    TResult? Function(DetailLoadCompleted value)? completed,
    TResult? Function(DetailLoadError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial() when initial != null:
        return initial(_that);
      case DetailLoadLoading() when loading != null:
        return loading(_that);
      case DetailLoadCompleted() when completed != null:
        return completed(_that);
      case DetailLoadError() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String code,
            String baseCode,
            String currencyName,
            double liveRate,
            double todayPercent,
            HistoricalSeries series,
            CurrencyStats stats,
            RangeOption range,
            RateSnapshot snapshot)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial() when initial != null:
        return initial();
      case DetailLoadLoading() when loading != null:
        return loading();
      case DetailLoadCompleted() when completed != null:
        return completed(
            _that.code,
            _that.baseCode,
            _that.currencyName,
            _that.liveRate,
            _that.todayPercent,
            _that.series,
            _that.stats,
            _that.range,
            _that.snapshot);
      case DetailLoadError() when error != null:
        return error(_that.message);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String code,
            String baseCode,
            String currencyName,
            double liveRate,
            double todayPercent,
            HistoricalSeries series,
            CurrencyStats stats,
            RangeOption range,
            RateSnapshot snapshot)
        completed,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial():
        return initial();
      case DetailLoadLoading():
        return loading();
      case DetailLoadCompleted():
        return completed(
            _that.code,
            _that.baseCode,
            _that.currencyName,
            _that.liveRate,
            _that.todayPercent,
            _that.series,
            _that.stats,
            _that.range,
            _that.snapshot);
      case DetailLoadError():
        return error(_that.message);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String code,
            String baseCode,
            String currencyName,
            double liveRate,
            double todayPercent,
            HistoricalSeries series,
            CurrencyStats stats,
            RangeOption range,
            RateSnapshot snapshot)?
        completed,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DetailLoadInitial() when initial != null:
        return initial();
      case DetailLoadLoading() when loading != null:
        return loading();
      case DetailLoadCompleted() when completed != null:
        return completed(
            _that.code,
            _that.baseCode,
            _that.currencyName,
            _that.liveRate,
            _that.todayPercent,
            _that.series,
            _that.stats,
            _that.range,
            _that.snapshot);
      case DetailLoadError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class DetailLoadInitial implements DetailLoadState {
  const DetailLoadInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailLoadInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailLoadState.initial()';
  }
}

/// @nodoc

class DetailLoadLoading implements DetailLoadState {
  const DetailLoadLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailLoadLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailLoadState.loading()';
  }
}

/// @nodoc

class DetailLoadCompleted implements DetailLoadState {
  const DetailLoadCompleted(
      {required this.code,
      required this.baseCode,
      required this.currencyName,
      required this.liveRate,
      required this.todayPercent,
      required this.series,
      required this.stats,
      required this.range,
      required this.snapshot});

  final String code;
  final String baseCode;
  final String currencyName;
  final double liveRate;
  final double todayPercent;
  final HistoricalSeries series;
  final CurrencyStats stats;
  final RangeOption range;
  final RateSnapshot snapshot;

  /// Create a copy of DetailLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailLoadCompletedCopyWith<DetailLoadCompleted> get copyWith =>
      _$DetailLoadCompletedCopyWithImpl<DetailLoadCompleted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailLoadCompleted &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.baseCode, baseCode) ||
                other.baseCode == baseCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.liveRate, liveRate) ||
                other.liveRate == liveRate) &&
            (identical(other.todayPercent, todayPercent) ||
                other.todayPercent == todayPercent) &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, baseCode, currencyName,
      liveRate, todayPercent, series, stats, range, snapshot);

  @override
  String toString() {
    return 'DetailLoadState.completed(code: $code, baseCode: $baseCode, currencyName: $currencyName, liveRate: $liveRate, todayPercent: $todayPercent, series: $series, stats: $stats, range: $range, snapshot: $snapshot)';
  }
}

/// @nodoc
abstract mixin class $DetailLoadCompletedCopyWith<$Res>
    implements $DetailLoadStateCopyWith<$Res> {
  factory $DetailLoadCompletedCopyWith(
          DetailLoadCompleted value, $Res Function(DetailLoadCompleted) _then) =
      _$DetailLoadCompletedCopyWithImpl;
  @useResult
  $Res call(
      {String code,
      String baseCode,
      String currencyName,
      double liveRate,
      double todayPercent,
      HistoricalSeries series,
      CurrencyStats stats,
      RangeOption range,
      RateSnapshot snapshot});
}

/// @nodoc
class _$DetailLoadCompletedCopyWithImpl<$Res>
    implements $DetailLoadCompletedCopyWith<$Res> {
  _$DetailLoadCompletedCopyWithImpl(this._self, this._then);

  final DetailLoadCompleted _self;
  final $Res Function(DetailLoadCompleted) _then;

  /// Create a copy of DetailLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? baseCode = null,
    Object? currencyName = null,
    Object? liveRate = null,
    Object? todayPercent = null,
    Object? series = null,
    Object? stats = null,
    Object? range = null,
    Object? snapshot = null,
  }) {
    return _then(DetailLoadCompleted(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      baseCode: null == baseCode
          ? _self.baseCode
          : baseCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _self.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      liveRate: null == liveRate
          ? _self.liveRate
          : liveRate // ignore: cast_nullable_to_non_nullable
              as double,
      todayPercent: null == todayPercent
          ? _self.todayPercent
          : todayPercent // ignore: cast_nullable_to_non_nullable
              as double,
      series: null == series
          ? _self.series
          : series // ignore: cast_nullable_to_non_nullable
              as HistoricalSeries,
      stats: null == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as CurrencyStats,
      range: null == range
          ? _self.range
          : range // ignore: cast_nullable_to_non_nullable
              as RangeOption,
      snapshot: null == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as RateSnapshot,
    ));
  }
}

/// @nodoc

class DetailLoadError implements DetailLoadState {
  const DetailLoadError(this.message);

  final String message;

  /// Create a copy of DetailLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailLoadErrorCopyWith<DetailLoadError> get copyWith =>
      _$DetailLoadErrorCopyWithImpl<DetailLoadError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailLoadError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'DetailLoadState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $DetailLoadErrorCopyWith<$Res>
    implements $DetailLoadStateCopyWith<$Res> {
  factory $DetailLoadErrorCopyWith(
          DetailLoadError value, $Res Function(DetailLoadError) _then) =
      _$DetailLoadErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$DetailLoadErrorCopyWithImpl<$Res>
    implements $DetailLoadErrorCopyWith<$Res> {
  _$DetailLoadErrorCopyWithImpl(this._self, this._then);

  final DetailLoadError _self;
  final $Res Function(DetailLoadError) _then;

  /// Create a copy of DetailLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(DetailLoadError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DetailState {
  DetailLoadState get load;

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailStateCopyWith<DetailState> get copyWith =>
      _$DetailStateCopyWithImpl<DetailState>(this as DetailState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailState &&
            (identical(other.load, load) || other.load == load));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load);

  @override
  String toString() {
    return 'DetailState(load: $load)';
  }
}

/// @nodoc
abstract mixin class $DetailStateCopyWith<$Res> {
  factory $DetailStateCopyWith(
          DetailState value, $Res Function(DetailState) _then) =
      _$DetailStateCopyWithImpl;
  @useResult
  $Res call({DetailLoadState load});

  $DetailLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class _$DetailStateCopyWithImpl<$Res> implements $DetailStateCopyWith<$Res> {
  _$DetailStateCopyWithImpl(this._self, this._then);

  final DetailState _self;
  final $Res Function(DetailState) _then;

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? load = null,
  }) {
    return _then(_self.copyWith(
      load: null == load
          ? _self.load
          : load // ignore: cast_nullable_to_non_nullable
              as DetailLoadState,
    ));
  }

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailLoadStateCopyWith<$Res> get load {
    return $DetailLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

/// Adds pattern-matching-related methods to [DetailState].
extension DetailStatePatterns on DetailState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DetailState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DetailState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DetailState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DetailState():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DetailState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DetailState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DetailLoadState load)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DetailState() when $default != null:
        return $default(_that.load);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DetailLoadState load) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DetailState():
        return $default(_that.load);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DetailLoadState load)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DetailState() when $default != null:
        return $default(_that.load);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DetailState implements DetailState {
  const _DetailState({required this.load});

  @override
  final DetailLoadState load;

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DetailStateCopyWith<_DetailState> get copyWith =>
      __$DetailStateCopyWithImpl<_DetailState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DetailState &&
            (identical(other.load, load) || other.load == load));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load);

  @override
  String toString() {
    return 'DetailState(load: $load)';
  }
}

/// @nodoc
abstract mixin class _$DetailStateCopyWith<$Res>
    implements $DetailStateCopyWith<$Res> {
  factory _$DetailStateCopyWith(
          _DetailState value, $Res Function(_DetailState) _then) =
      __$DetailStateCopyWithImpl;
  @override
  @useResult
  $Res call({DetailLoadState load});

  @override
  $DetailLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class __$DetailStateCopyWithImpl<$Res> implements _$DetailStateCopyWith<$Res> {
  __$DetailStateCopyWithImpl(this._self, this._then);

  final _DetailState _self;
  final $Res Function(_DetailState) _then;

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? load = null,
  }) {
    return _then(_DetailState(
      load: null == load
          ? _self.load
          : load // ignore: cast_nullable_to_non_nullable
              as DetailLoadState,
    ));
  }

  /// Create a copy of DetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailLoadStateCopyWith<$Res> get load {
    return $DetailLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

// dart format on
