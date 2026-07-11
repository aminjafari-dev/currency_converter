// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeEvent()';
  }
}

/// @nodoc
class $HomeEventCopyWith<$Res> {
  $HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}

/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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
    TResult Function(HomeStarted value)? started,
    TResult Function(HomeRefreshed value)? refreshed,
    TResult Function(HomeAmountChanged value)? amountChanged,
    TResult Function(HomeBaseChanged value)? baseChanged,
    TResult Function(HomeCurrencyRemoved value)? currencyRemoved,
    TResult Function(HomeEditModeToggled value)? editModeToggled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted() when started != null:
        return started(_that);
      case HomeRefreshed() when refreshed != null:
        return refreshed(_that);
      case HomeAmountChanged() when amountChanged != null:
        return amountChanged(_that);
      case HomeBaseChanged() when baseChanged != null:
        return baseChanged(_that);
      case HomeCurrencyRemoved() when currencyRemoved != null:
        return currencyRemoved(_that);
      case HomeEditModeToggled() when editModeToggled != null:
        return editModeToggled(_that);
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
    required TResult Function(HomeStarted value) started,
    required TResult Function(HomeRefreshed value) refreshed,
    required TResult Function(HomeAmountChanged value) amountChanged,
    required TResult Function(HomeBaseChanged value) baseChanged,
    required TResult Function(HomeCurrencyRemoved value) currencyRemoved,
    required TResult Function(HomeEditModeToggled value) editModeToggled,
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted():
        return started(_that);
      case HomeRefreshed():
        return refreshed(_that);
      case HomeAmountChanged():
        return amountChanged(_that);
      case HomeBaseChanged():
        return baseChanged(_that);
      case HomeCurrencyRemoved():
        return currencyRemoved(_that);
      case HomeEditModeToggled():
        return editModeToggled(_that);
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
    TResult? Function(HomeStarted value)? started,
    TResult? Function(HomeRefreshed value)? refreshed,
    TResult? Function(HomeAmountChanged value)? amountChanged,
    TResult? Function(HomeBaseChanged value)? baseChanged,
    TResult? Function(HomeCurrencyRemoved value)? currencyRemoved,
    TResult? Function(HomeEditModeToggled value)? editModeToggled,
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted() when started != null:
        return started(_that);
      case HomeRefreshed() when refreshed != null:
        return refreshed(_that);
      case HomeAmountChanged() when amountChanged != null:
        return amountChanged(_that);
      case HomeBaseChanged() when baseChanged != null:
        return baseChanged(_that);
      case HomeCurrencyRemoved() when currencyRemoved != null:
        return currencyRemoved(_that);
      case HomeEditModeToggled() when editModeToggled != null:
        return editModeToggled(_that);
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
    TResult Function()? started,
    TResult Function()? refreshed,
    TResult Function(double amount)? amountChanged,
    TResult Function(String code)? baseChanged,
    TResult Function(String code)? currencyRemoved,
    TResult Function()? editModeToggled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted() when started != null:
        return started();
      case HomeRefreshed() when refreshed != null:
        return refreshed();
      case HomeAmountChanged() when amountChanged != null:
        return amountChanged(_that.amount);
      case HomeBaseChanged() when baseChanged != null:
        return baseChanged(_that.code);
      case HomeCurrencyRemoved() when currencyRemoved != null:
        return currencyRemoved(_that.code);
      case HomeEditModeToggled() when editModeToggled != null:
        return editModeToggled();
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
    required TResult Function() started,
    required TResult Function() refreshed,
    required TResult Function(double amount) amountChanged,
    required TResult Function(String code) baseChanged,
    required TResult Function(String code) currencyRemoved,
    required TResult Function() editModeToggled,
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted():
        return started();
      case HomeRefreshed():
        return refreshed();
      case HomeAmountChanged():
        return amountChanged(_that.amount);
      case HomeBaseChanged():
        return baseChanged(_that.code);
      case HomeCurrencyRemoved():
        return currencyRemoved(_that.code);
      case HomeEditModeToggled():
        return editModeToggled();
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
    TResult? Function()? started,
    TResult? Function()? refreshed,
    TResult? Function(double amount)? amountChanged,
    TResult? Function(String code)? baseChanged,
    TResult? Function(String code)? currencyRemoved,
    TResult? Function()? editModeToggled,
  }) {
    final _that = this;
    switch (_that) {
      case HomeStarted() when started != null:
        return started();
      case HomeRefreshed() when refreshed != null:
        return refreshed();
      case HomeAmountChanged() when amountChanged != null:
        return amountChanged(_that.amount);
      case HomeBaseChanged() when baseChanged != null:
        return baseChanged(_that.code);
      case HomeCurrencyRemoved() when currencyRemoved != null:
        return currencyRemoved(_that.code);
      case HomeEditModeToggled() when editModeToggled != null:
        return editModeToggled();
      case _:
        return null;
    }
  }
}

/// @nodoc

class HomeStarted implements HomeEvent {
  const HomeStarted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeStarted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeEvent.started()';
  }
}

/// @nodoc

class HomeRefreshed implements HomeEvent {
  const HomeRefreshed();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeRefreshed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeEvent.refreshed()';
  }
}

/// @nodoc

class HomeAmountChanged implements HomeEvent {
  const HomeAmountChanged({required this.amount});

  final double amount;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeAmountChangedCopyWith<HomeAmountChanged> get copyWith =>
      _$HomeAmountChangedCopyWithImpl<HomeAmountChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeAmountChanged &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount);

  @override
  String toString() {
    return 'HomeEvent.amountChanged(amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $HomeAmountChangedCopyWith<$Res>
    implements $HomeEventCopyWith<$Res> {
  factory $HomeAmountChangedCopyWith(
          HomeAmountChanged value, $Res Function(HomeAmountChanged) _then) =
      _$HomeAmountChangedCopyWithImpl;
  @useResult
  $Res call({double amount});
}

/// @nodoc
class _$HomeAmountChangedCopyWithImpl<$Res>
    implements $HomeAmountChangedCopyWith<$Res> {
  _$HomeAmountChangedCopyWithImpl(this._self, this._then);

  final HomeAmountChanged _self;
  final $Res Function(HomeAmountChanged) _then;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = null,
  }) {
    return _then(HomeAmountChanged(
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class HomeBaseChanged implements HomeEvent {
  const HomeBaseChanged({required this.code});

  final String code;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeBaseChangedCopyWith<HomeBaseChanged> get copyWith =>
      _$HomeBaseChangedCopyWithImpl<HomeBaseChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeBaseChanged &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @override
  String toString() {
    return 'HomeEvent.baseChanged(code: $code)';
  }
}

/// @nodoc
abstract mixin class $HomeBaseChangedCopyWith<$Res>
    implements $HomeEventCopyWith<$Res> {
  factory $HomeBaseChangedCopyWith(
          HomeBaseChanged value, $Res Function(HomeBaseChanged) _then) =
      _$HomeBaseChangedCopyWithImpl;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$HomeBaseChangedCopyWithImpl<$Res>
    implements $HomeBaseChangedCopyWith<$Res> {
  _$HomeBaseChangedCopyWithImpl(this._self, this._then);

  final HomeBaseChanged _self;
  final $Res Function(HomeBaseChanged) _then;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
  }) {
    return _then(HomeBaseChanged(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class HomeCurrencyRemoved implements HomeEvent {
  const HomeCurrencyRemoved({required this.code});

  final String code;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeCurrencyRemovedCopyWith<HomeCurrencyRemoved> get copyWith =>
      _$HomeCurrencyRemovedCopyWithImpl<HomeCurrencyRemoved>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeCurrencyRemoved &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @override
  String toString() {
    return 'HomeEvent.currencyRemoved(code: $code)';
  }
}

/// @nodoc
abstract mixin class $HomeCurrencyRemovedCopyWith<$Res>
    implements $HomeEventCopyWith<$Res> {
  factory $HomeCurrencyRemovedCopyWith(
          HomeCurrencyRemoved value, $Res Function(HomeCurrencyRemoved) _then) =
      _$HomeCurrencyRemovedCopyWithImpl;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$HomeCurrencyRemovedCopyWithImpl<$Res>
    implements $HomeCurrencyRemovedCopyWith<$Res> {
  _$HomeCurrencyRemovedCopyWithImpl(this._self, this._then);

  final HomeCurrencyRemoved _self;
  final $Res Function(HomeCurrencyRemoved) _then;

  /// Create a copy of HomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
  }) {
    return _then(HomeCurrencyRemoved(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class HomeEditModeToggled implements HomeEvent {
  const HomeEditModeToggled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeEditModeToggled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeEvent.editModeToggled()';
  }
}

// dart format on
