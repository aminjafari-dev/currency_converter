// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeLoadState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLoadState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLoadState()';
  }
}

/// @nodoc
class $HomeLoadStateCopyWith<$Res> {
  $HomeLoadStateCopyWith(HomeLoadState _, $Res Function(HomeLoadState) __);
}

/// Adds pattern-matching-related methods to [HomeLoadState].
extension HomeLoadStatePatterns on HomeLoadState {
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
    TResult Function(HomeLoadInitial value)? initial,
    TResult Function(HomeLoadLoading value)? loading,
    TResult Function(HomeLoadCompleted value)? completed,
    TResult Function(HomeLoadError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial() when initial != null:
        return initial(_that);
      case HomeLoadLoading() when loading != null:
        return loading(_that);
      case HomeLoadCompleted() when completed != null:
        return completed(_that);
      case HomeLoadError() when error != null:
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
    required TResult Function(HomeLoadInitial value) initial,
    required TResult Function(HomeLoadLoading value) loading,
    required TResult Function(HomeLoadCompleted value) completed,
    required TResult Function(HomeLoadError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial():
        return initial(_that);
      case HomeLoadLoading():
        return loading(_that);
      case HomeLoadCompleted():
        return completed(_that);
      case HomeLoadError():
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
    TResult? Function(HomeLoadInitial value)? initial,
    TResult? Function(HomeLoadLoading value)? loading,
    TResult? Function(HomeLoadCompleted value)? completed,
    TResult? Function(HomeLoadError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial() when initial != null:
        return initial(_that);
      case HomeLoadLoading() when loading != null:
        return loading(_that);
      case HomeLoadCompleted() when completed != null:
        return completed(_that);
      case HomeLoadError() when error != null:
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
            RateSnapshot snapshot,
            List<SelectedCurrency> selected,
            Map<String, Currency> catalog,
            Map<String, double> convertedAmounts,
            double baseAmount,
            DateTime? lastUpdated)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial() when initial != null:
        return initial();
      case HomeLoadLoading() when loading != null:
        return loading();
      case HomeLoadCompleted() when completed != null:
        return completed(_that.snapshot, _that.selected, _that.catalog,
            _that.convertedAmounts, _that.baseAmount, _that.lastUpdated);
      case HomeLoadError() when error != null:
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
            RateSnapshot snapshot,
            List<SelectedCurrency> selected,
            Map<String, Currency> catalog,
            Map<String, double> convertedAmounts,
            double baseAmount,
            DateTime? lastUpdated)
        completed,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial():
        return initial();
      case HomeLoadLoading():
        return loading();
      case HomeLoadCompleted():
        return completed(_that.snapshot, _that.selected, _that.catalog,
            _that.convertedAmounts, _that.baseAmount, _that.lastUpdated);
      case HomeLoadError():
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
            RateSnapshot snapshot,
            List<SelectedCurrency> selected,
            Map<String, Currency> catalog,
            Map<String, double> convertedAmounts,
            double baseAmount,
            DateTime? lastUpdated)?
        completed,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLoadInitial() when initial != null:
        return initial();
      case HomeLoadLoading() when loading != null:
        return loading();
      case HomeLoadCompleted() when completed != null:
        return completed(_that.snapshot, _that.selected, _that.catalog,
            _that.convertedAmounts, _that.baseAmount, _that.lastUpdated);
      case HomeLoadError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class HomeLoadInitial implements HomeLoadState {
  const HomeLoadInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLoadInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLoadState.initial()';
  }
}

/// @nodoc

class HomeLoadLoading implements HomeLoadState {
  const HomeLoadLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLoadLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLoadState.loading()';
  }
}

/// @nodoc

class HomeLoadCompleted implements HomeLoadState {
  const HomeLoadCompleted(
      {required this.snapshot,
      required final List<SelectedCurrency> selected,
      required final Map<String, Currency> catalog,
      required final Map<String, double> convertedAmounts,
      required this.baseAmount,
      required this.lastUpdated})
      : _selected = selected,
        _catalog = catalog,
        _convertedAmounts = convertedAmounts;

  final RateSnapshot snapshot;
  final List<SelectedCurrency> _selected;
  List<SelectedCurrency> get selected {
    if (_selected is EqualUnmodifiableListView) return _selected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selected);
  }

  final Map<String, Currency> _catalog;
  Map<String, Currency> get catalog {
    if (_catalog is EqualUnmodifiableMapView) return _catalog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_catalog);
  }

  final Map<String, double> _convertedAmounts;
  Map<String, double> get convertedAmounts {
    if (_convertedAmounts is EqualUnmodifiableMapView) return _convertedAmounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_convertedAmounts);
  }

  final double baseAmount;
  final DateTime? lastUpdated;

  /// Create a copy of HomeLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeLoadCompletedCopyWith<HomeLoadCompleted> get copyWith =>
      _$HomeLoadCompletedCopyWithImpl<HomeLoadCompleted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeLoadCompleted &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            const DeepCollectionEquality().equals(other._selected, _selected) &&
            const DeepCollectionEquality().equals(other._catalog, _catalog) &&
            const DeepCollectionEquality()
                .equals(other._convertedAmounts, _convertedAmounts) &&
            (identical(other.baseAmount, baseAmount) ||
                other.baseAmount == baseAmount) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      snapshot,
      const DeepCollectionEquality().hash(_selected),
      const DeepCollectionEquality().hash(_catalog),
      const DeepCollectionEquality().hash(_convertedAmounts),
      baseAmount,
      lastUpdated);

  @override
  String toString() {
    return 'HomeLoadState.completed(snapshot: $snapshot, selected: $selected, catalog: $catalog, convertedAmounts: $convertedAmounts, baseAmount: $baseAmount, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $HomeLoadCompletedCopyWith<$Res>
    implements $HomeLoadStateCopyWith<$Res> {
  factory $HomeLoadCompletedCopyWith(
          HomeLoadCompleted value, $Res Function(HomeLoadCompleted) _then) =
      _$HomeLoadCompletedCopyWithImpl;
  @useResult
  $Res call(
      {RateSnapshot snapshot,
      List<SelectedCurrency> selected,
      Map<String, Currency> catalog,
      Map<String, double> convertedAmounts,
      double baseAmount,
      DateTime? lastUpdated});
}

/// @nodoc
class _$HomeLoadCompletedCopyWithImpl<$Res>
    implements $HomeLoadCompletedCopyWith<$Res> {
  _$HomeLoadCompletedCopyWithImpl(this._self, this._then);

  final HomeLoadCompleted _self;
  final $Res Function(HomeLoadCompleted) _then;

  /// Create a copy of HomeLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? snapshot = null,
    Object? selected = null,
    Object? catalog = null,
    Object? convertedAmounts = null,
    Object? baseAmount = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(HomeLoadCompleted(
      snapshot: null == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as RateSnapshot,
      selected: null == selected
          ? _self._selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<SelectedCurrency>,
      catalog: null == catalog
          ? _self._catalog
          : catalog // ignore: cast_nullable_to_non_nullable
              as Map<String, Currency>,
      convertedAmounts: null == convertedAmounts
          ? _self._convertedAmounts
          : convertedAmounts // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      baseAmount: null == baseAmount
          ? _self.baseAmount
          : baseAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class HomeLoadError implements HomeLoadState {
  const HomeLoadError(this.message);

  final String message;

  /// Create a copy of HomeLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeLoadErrorCopyWith<HomeLoadError> get copyWith =>
      _$HomeLoadErrorCopyWithImpl<HomeLoadError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeLoadError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'HomeLoadState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $HomeLoadErrorCopyWith<$Res>
    implements $HomeLoadStateCopyWith<$Res> {
  factory $HomeLoadErrorCopyWith(
          HomeLoadError value, $Res Function(HomeLoadError) _then) =
      _$HomeLoadErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$HomeLoadErrorCopyWithImpl<$Res>
    implements $HomeLoadErrorCopyWith<$Res> {
  _$HomeLoadErrorCopyWithImpl(this._self, this._then);

  final HomeLoadError _self;
  final $Res Function(HomeLoadError) _then;

  /// Create a copy of HomeLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(HomeLoadError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$HomeState {
  HomeLoadState get load;
  bool get isEditing;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            (identical(other.load, load) || other.load == load) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load, isEditing);

  @override
  String toString() {
    return 'HomeState(load: $load, isEditing: $isEditing)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call({HomeLoadState load, bool isEditing});

  $HomeLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? load = null,
    Object? isEditing = null,
  }) {
    return _then(_self.copyWith(
      load: null == load
          ? _self.load
          : load // ignore: cast_nullable_to_non_nullable
              as HomeLoadState,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HomeLoadStateCopyWith<$Res> get load {
    return $HomeLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(HomeLoadState load, bool isEditing)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(_that.load, _that.isEditing);
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
    TResult Function(HomeLoadState load, bool isEditing) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(_that.load, _that.isEditing);
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
    TResult? Function(HomeLoadState load, bool isEditing)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(_that.load, _that.isEditing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState implements HomeState {
  const _HomeState({required this.load, this.isEditing = false});

  @override
  final HomeLoadState load;
  @override
  @JsonKey()
  final bool isEditing;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            (identical(other.load, load) || other.load == load) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load, isEditing);

  @override
  String toString() {
    return 'HomeState(load: $load, isEditing: $isEditing)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call({HomeLoadState load, bool isEditing});

  @override
  $HomeLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? load = null,
    Object? isEditing = null,
  }) {
    return _then(_HomeState(
      load: null == load
          ? _self.load
          : load // ignore: cast_nullable_to_non_nullable
              as HomeLoadState,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HomeLoadStateCopyWith<$Res> get load {
    return $HomeLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

// dart format on
