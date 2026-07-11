// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_currency_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddCurrencyLoadState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddCurrencyLoadState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddCurrencyLoadState()';
  }
}

/// @nodoc
class $AddCurrencyLoadStateCopyWith<$Res> {
  $AddCurrencyLoadStateCopyWith(
      AddCurrencyLoadState _, $Res Function(AddCurrencyLoadState) __);
}

/// Adds pattern-matching-related methods to [AddCurrencyLoadState].
extension AddCurrencyLoadStatePatterns on AddCurrencyLoadState {
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
    TResult Function(AddCurrencyLoadInitial value)? initial,
    TResult Function(AddCurrencyLoadLoading value)? loading,
    TResult Function(AddCurrencyLoadCompleted value)? completed,
    TResult Function(AddCurrencyLoadError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial() when initial != null:
        return initial(_that);
      case AddCurrencyLoadLoading() when loading != null:
        return loading(_that);
      case AddCurrencyLoadCompleted() when completed != null:
        return completed(_that);
      case AddCurrencyLoadError() when error != null:
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
    required TResult Function(AddCurrencyLoadInitial value) initial,
    required TResult Function(AddCurrencyLoadLoading value) loading,
    required TResult Function(AddCurrencyLoadCompleted value) completed,
    required TResult Function(AddCurrencyLoadError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial():
        return initial(_that);
      case AddCurrencyLoadLoading():
        return loading(_that);
      case AddCurrencyLoadCompleted():
        return completed(_that);
      case AddCurrencyLoadError():
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
    TResult? Function(AddCurrencyLoadInitial value)? initial,
    TResult? Function(AddCurrencyLoadLoading value)? loading,
    TResult? Function(AddCurrencyLoadCompleted value)? completed,
    TResult? Function(AddCurrencyLoadError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial() when initial != null:
        return initial(_that);
      case AddCurrencyLoadLoading() when loading != null:
        return loading(_that);
      case AddCurrencyLoadCompleted() when completed != null:
        return completed(_that);
      case AddCurrencyLoadError() when error != null:
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
    TResult Function(List<Currency> all, List<Currency> filtered,
            Set<String> selectedCodes, String query)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial() when initial != null:
        return initial();
      case AddCurrencyLoadLoading() when loading != null:
        return loading();
      case AddCurrencyLoadCompleted() when completed != null:
        return completed(
            _that.all, _that.filtered, _that.selectedCodes, _that.query);
      case AddCurrencyLoadError() when error != null:
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
    required TResult Function(List<Currency> all, List<Currency> filtered,
            Set<String> selectedCodes, String query)
        completed,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial():
        return initial();
      case AddCurrencyLoadLoading():
        return loading();
      case AddCurrencyLoadCompleted():
        return completed(
            _that.all, _that.filtered, _that.selectedCodes, _that.query);
      case AddCurrencyLoadError():
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
    TResult? Function(List<Currency> all, List<Currency> filtered,
            Set<String> selectedCodes, String query)?
        completed,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyLoadInitial() when initial != null:
        return initial();
      case AddCurrencyLoadLoading() when loading != null:
        return loading();
      case AddCurrencyLoadCompleted() when completed != null:
        return completed(
            _that.all, _that.filtered, _that.selectedCodes, _that.query);
      case AddCurrencyLoadError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AddCurrencyLoadInitial implements AddCurrencyLoadState {
  const AddCurrencyLoadInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddCurrencyLoadInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddCurrencyLoadState.initial()';
  }
}

/// @nodoc

class AddCurrencyLoadLoading implements AddCurrencyLoadState {
  const AddCurrencyLoadLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddCurrencyLoadLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddCurrencyLoadState.loading()';
  }
}

/// @nodoc

class AddCurrencyLoadCompleted implements AddCurrencyLoadState {
  const AddCurrencyLoadCompleted(
      {required final List<Currency> all,
      required final List<Currency> filtered,
      required final Set<String> selectedCodes,
      required this.query})
      : _all = all,
        _filtered = filtered,
        _selectedCodes = selectedCodes;

  final List<Currency> _all;
  List<Currency> get all {
    if (_all is EqualUnmodifiableListView) return _all;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_all);
  }

  final List<Currency> _filtered;
  List<Currency> get filtered {
    if (_filtered is EqualUnmodifiableListView) return _filtered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filtered);
  }

  final Set<String> _selectedCodes;
  Set<String> get selectedCodes {
    if (_selectedCodes is EqualUnmodifiableSetView) return _selectedCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedCodes);
  }

  final String query;

  /// Create a copy of AddCurrencyLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCurrencyLoadCompletedCopyWith<AddCurrencyLoadCompleted> get copyWith =>
      _$AddCurrencyLoadCompletedCopyWithImpl<AddCurrencyLoadCompleted>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCurrencyLoadCompleted &&
            const DeepCollectionEquality().equals(other._all, _all) &&
            const DeepCollectionEquality().equals(other._filtered, _filtered) &&
            const DeepCollectionEquality()
                .equals(other._selectedCodes, _selectedCodes) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_all),
      const DeepCollectionEquality().hash(_filtered),
      const DeepCollectionEquality().hash(_selectedCodes),
      query);

  @override
  String toString() {
    return 'AddCurrencyLoadState.completed(all: $all, filtered: $filtered, selectedCodes: $selectedCodes, query: $query)';
  }
}

/// @nodoc
abstract mixin class $AddCurrencyLoadCompletedCopyWith<$Res>
    implements $AddCurrencyLoadStateCopyWith<$Res> {
  factory $AddCurrencyLoadCompletedCopyWith(AddCurrencyLoadCompleted value,
          $Res Function(AddCurrencyLoadCompleted) _then) =
      _$AddCurrencyLoadCompletedCopyWithImpl;
  @useResult
  $Res call(
      {List<Currency> all,
      List<Currency> filtered,
      Set<String> selectedCodes,
      String query});
}

/// @nodoc
class _$AddCurrencyLoadCompletedCopyWithImpl<$Res>
    implements $AddCurrencyLoadCompletedCopyWith<$Res> {
  _$AddCurrencyLoadCompletedCopyWithImpl(this._self, this._then);

  final AddCurrencyLoadCompleted _self;
  final $Res Function(AddCurrencyLoadCompleted) _then;

  /// Create a copy of AddCurrencyLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? all = null,
    Object? filtered = null,
    Object? selectedCodes = null,
    Object? query = null,
  }) {
    return _then(AddCurrencyLoadCompleted(
      all: null == all
          ? _self._all
          : all // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      filtered: null == filtered
          ? _self._filtered
          : filtered // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
      selectedCodes: null == selectedCodes
          ? _self._selectedCodes
          : selectedCodes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AddCurrencyLoadError implements AddCurrencyLoadState {
  const AddCurrencyLoadError(this.message);

  final String message;

  /// Create a copy of AddCurrencyLoadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCurrencyLoadErrorCopyWith<AddCurrencyLoadError> get copyWith =>
      _$AddCurrencyLoadErrorCopyWithImpl<AddCurrencyLoadError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCurrencyLoadError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AddCurrencyLoadState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AddCurrencyLoadErrorCopyWith<$Res>
    implements $AddCurrencyLoadStateCopyWith<$Res> {
  factory $AddCurrencyLoadErrorCopyWith(AddCurrencyLoadError value,
          $Res Function(AddCurrencyLoadError) _then) =
      _$AddCurrencyLoadErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AddCurrencyLoadErrorCopyWithImpl<$Res>
    implements $AddCurrencyLoadErrorCopyWith<$Res> {
  _$AddCurrencyLoadErrorCopyWithImpl(this._self, this._then);

  final AddCurrencyLoadError _self;
  final $Res Function(AddCurrencyLoadError) _then;

  /// Create a copy of AddCurrencyLoadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AddCurrencyLoadError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AddCurrencyState {
  AddCurrencyLoadState get load;

  /// Create a copy of AddCurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCurrencyStateCopyWith<AddCurrencyState> get copyWith =>
      _$AddCurrencyStateCopyWithImpl<AddCurrencyState>(
          this as AddCurrencyState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCurrencyState &&
            (identical(other.load, load) || other.load == load));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load);

  @override
  String toString() {
    return 'AddCurrencyState(load: $load)';
  }
}

/// @nodoc
abstract mixin class $AddCurrencyStateCopyWith<$Res> {
  factory $AddCurrencyStateCopyWith(
          AddCurrencyState value, $Res Function(AddCurrencyState) _then) =
      _$AddCurrencyStateCopyWithImpl;
  @useResult
  $Res call({AddCurrencyLoadState load});

  $AddCurrencyLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class _$AddCurrencyStateCopyWithImpl<$Res>
    implements $AddCurrencyStateCopyWith<$Res> {
  _$AddCurrencyStateCopyWithImpl(this._self, this._then);

  final AddCurrencyState _self;
  final $Res Function(AddCurrencyState) _then;

  /// Create a copy of AddCurrencyState
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
              as AddCurrencyLoadState,
    ));
  }

  /// Create a copy of AddCurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddCurrencyLoadStateCopyWith<$Res> get load {
    return $AddCurrencyLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AddCurrencyState].
extension AddCurrencyStatePatterns on AddCurrencyState {
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
    TResult Function(_AddCurrencyState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState() when $default != null:
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
    TResult Function(_AddCurrencyState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState():
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
    TResult? Function(_AddCurrencyState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState() when $default != null:
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
    TResult Function(AddCurrencyLoadState load)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState() when $default != null:
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
    TResult Function(AddCurrencyLoadState load) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState():
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
    TResult? Function(AddCurrencyLoadState load)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCurrencyState() when $default != null:
        return $default(_that.load);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddCurrencyState implements AddCurrencyState {
  const _AddCurrencyState({required this.load});

  @override
  final AddCurrencyLoadState load;

  /// Create a copy of AddCurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddCurrencyStateCopyWith<_AddCurrencyState> get copyWith =>
      __$AddCurrencyStateCopyWithImpl<_AddCurrencyState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddCurrencyState &&
            (identical(other.load, load) || other.load == load));
  }

  @override
  int get hashCode => Object.hash(runtimeType, load);

  @override
  String toString() {
    return 'AddCurrencyState(load: $load)';
  }
}

/// @nodoc
abstract mixin class _$AddCurrencyStateCopyWith<$Res>
    implements $AddCurrencyStateCopyWith<$Res> {
  factory _$AddCurrencyStateCopyWith(
          _AddCurrencyState value, $Res Function(_AddCurrencyState) _then) =
      __$AddCurrencyStateCopyWithImpl;
  @override
  @useResult
  $Res call({AddCurrencyLoadState load});

  @override
  $AddCurrencyLoadStateCopyWith<$Res> get load;
}

/// @nodoc
class __$AddCurrencyStateCopyWithImpl<$Res>
    implements _$AddCurrencyStateCopyWith<$Res> {
  __$AddCurrencyStateCopyWithImpl(this._self, this._then);

  final _AddCurrencyState _self;
  final $Res Function(_AddCurrencyState) _then;

  /// Create a copy of AddCurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? load = null,
  }) {
    return _then(_AddCurrencyState(
      load: null == load
          ? _self.load
          : load // ignore: cast_nullable_to_non_nullable
              as AddCurrencyLoadState,
    ));
  }

  /// Create a copy of AddCurrencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddCurrencyLoadStateCopyWith<$Res> get load {
    return $AddCurrencyLoadStateCopyWith<$Res>(_self.load, (value) {
      return _then(_self.copyWith(load: value));
    });
  }
}

// dart format on
