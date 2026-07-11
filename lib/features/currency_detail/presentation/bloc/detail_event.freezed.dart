// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DetailEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailEvent()';
  }
}

/// @nodoc
class $DetailEventCopyWith<$Res> {
  $DetailEventCopyWith(DetailEvent _, $Res Function(DetailEvent) __);
}

/// Adds pattern-matching-related methods to [DetailEvent].
extension DetailEventPatterns on DetailEvent {
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
    TResult Function(DetailStarted value)? started,
    TResult Function(DetailRangeChanged value)? rangeChanged,
    TResult Function(DetailRefreshed value)? refreshed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted() when started != null:
        return started(_that);
      case DetailRangeChanged() when rangeChanged != null:
        return rangeChanged(_that);
      case DetailRefreshed() when refreshed != null:
        return refreshed(_that);
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
    required TResult Function(DetailStarted value) started,
    required TResult Function(DetailRangeChanged value) rangeChanged,
    required TResult Function(DetailRefreshed value) refreshed,
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted():
        return started(_that);
      case DetailRangeChanged():
        return rangeChanged(_that);
      case DetailRefreshed():
        return refreshed(_that);
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
    TResult? Function(DetailStarted value)? started,
    TResult? Function(DetailRangeChanged value)? rangeChanged,
    TResult? Function(DetailRefreshed value)? refreshed,
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted() when started != null:
        return started(_that);
      case DetailRangeChanged() when rangeChanged != null:
        return rangeChanged(_that);
      case DetailRefreshed() when refreshed != null:
        return refreshed(_that);
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
    TResult Function(String code, String baseCode)? started,
    TResult Function(RangeOption range)? rangeChanged,
    TResult Function()? refreshed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted() when started != null:
        return started(_that.code, _that.baseCode);
      case DetailRangeChanged() when rangeChanged != null:
        return rangeChanged(_that.range);
      case DetailRefreshed() when refreshed != null:
        return refreshed();
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
    required TResult Function(String code, String baseCode) started,
    required TResult Function(RangeOption range) rangeChanged,
    required TResult Function() refreshed,
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted():
        return started(_that.code, _that.baseCode);
      case DetailRangeChanged():
        return rangeChanged(_that.range);
      case DetailRefreshed():
        return refreshed();
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
    TResult? Function(String code, String baseCode)? started,
    TResult? Function(RangeOption range)? rangeChanged,
    TResult? Function()? refreshed,
  }) {
    final _that = this;
    switch (_that) {
      case DetailStarted() when started != null:
        return started(_that.code, _that.baseCode);
      case DetailRangeChanged() when rangeChanged != null:
        return rangeChanged(_that.range);
      case DetailRefreshed() when refreshed != null:
        return refreshed();
      case _:
        return null;
    }
  }
}

/// @nodoc

class DetailStarted implements DetailEvent {
  const DetailStarted({required this.code, required this.baseCode});

  final String code;
  final String baseCode;

  /// Create a copy of DetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailStartedCopyWith<DetailStarted> get copyWith =>
      _$DetailStartedCopyWithImpl<DetailStarted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailStarted &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.baseCode, baseCode) ||
                other.baseCode == baseCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, baseCode);

  @override
  String toString() {
    return 'DetailEvent.started(code: $code, baseCode: $baseCode)';
  }
}

/// @nodoc
abstract mixin class $DetailStartedCopyWith<$Res>
    implements $DetailEventCopyWith<$Res> {
  factory $DetailStartedCopyWith(
          DetailStarted value, $Res Function(DetailStarted) _then) =
      _$DetailStartedCopyWithImpl;
  @useResult
  $Res call({String code, String baseCode});
}

/// @nodoc
class _$DetailStartedCopyWithImpl<$Res>
    implements $DetailStartedCopyWith<$Res> {
  _$DetailStartedCopyWithImpl(this._self, this._then);

  final DetailStarted _self;
  final $Res Function(DetailStarted) _then;

  /// Create a copy of DetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? baseCode = null,
  }) {
    return _then(DetailStarted(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      baseCode: null == baseCode
          ? _self.baseCode
          : baseCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class DetailRangeChanged implements DetailEvent {
  const DetailRangeChanged({required this.range});

  final RangeOption range;

  /// Create a copy of DetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailRangeChangedCopyWith<DetailRangeChanged> get copyWith =>
      _$DetailRangeChangedCopyWithImpl<DetailRangeChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailRangeChanged &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, range);

  @override
  String toString() {
    return 'DetailEvent.rangeChanged(range: $range)';
  }
}

/// @nodoc
abstract mixin class $DetailRangeChangedCopyWith<$Res>
    implements $DetailEventCopyWith<$Res> {
  factory $DetailRangeChangedCopyWith(
          DetailRangeChanged value, $Res Function(DetailRangeChanged) _then) =
      _$DetailRangeChangedCopyWithImpl;
  @useResult
  $Res call({RangeOption range});
}

/// @nodoc
class _$DetailRangeChangedCopyWithImpl<$Res>
    implements $DetailRangeChangedCopyWith<$Res> {
  _$DetailRangeChangedCopyWithImpl(this._self, this._then);

  final DetailRangeChanged _self;
  final $Res Function(DetailRangeChanged) _then;

  /// Create a copy of DetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? range = null,
  }) {
    return _then(DetailRangeChanged(
      range: null == range
          ? _self.range
          : range // ignore: cast_nullable_to_non_nullable
              as RangeOption,
    ));
  }
}

/// @nodoc

class DetailRefreshed implements DetailEvent {
  const DetailRefreshed();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailRefreshed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailEvent.refreshed()';
  }
}

// dart format on
