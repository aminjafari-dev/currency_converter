// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_currency_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddCurrencyEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddCurrencyEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddCurrencyEvent()';
  }
}

/// @nodoc
class $AddCurrencyEventCopyWith<$Res> {
  $AddCurrencyEventCopyWith(
      AddCurrencyEvent _, $Res Function(AddCurrencyEvent) __);
}

/// Adds pattern-matching-related methods to [AddCurrencyEvent].
extension AddCurrencyEventPatterns on AddCurrencyEvent {
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
    TResult Function(AddCurrencyStarted value)? started,
    TResult Function(AddCurrencySearchChanged value)? searchChanged,
    TResult Function(AddCurrencyToggled value)? toggled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted() when started != null:
        return started(_that);
      case AddCurrencySearchChanged() when searchChanged != null:
        return searchChanged(_that);
      case AddCurrencyToggled() when toggled != null:
        return toggled(_that);
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
    required TResult Function(AddCurrencyStarted value) started,
    required TResult Function(AddCurrencySearchChanged value) searchChanged,
    required TResult Function(AddCurrencyToggled value) toggled,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted():
        return started(_that);
      case AddCurrencySearchChanged():
        return searchChanged(_that);
      case AddCurrencyToggled():
        return toggled(_that);
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
    TResult? Function(AddCurrencyStarted value)? started,
    TResult? Function(AddCurrencySearchChanged value)? searchChanged,
    TResult? Function(AddCurrencyToggled value)? toggled,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted() when started != null:
        return started(_that);
      case AddCurrencySearchChanged() when searchChanged != null:
        return searchChanged(_that);
      case AddCurrencyToggled() when toggled != null:
        return toggled(_that);
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
    TResult Function(String query)? searchChanged,
    TResult Function(String code)? toggled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted() when started != null:
        return started();
      case AddCurrencySearchChanged() when searchChanged != null:
        return searchChanged(_that.query);
      case AddCurrencyToggled() when toggled != null:
        return toggled(_that.code);
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
    required TResult Function(String query) searchChanged,
    required TResult Function(String code) toggled,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted():
        return started();
      case AddCurrencySearchChanged():
        return searchChanged(_that.query);
      case AddCurrencyToggled():
        return toggled(_that.code);
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
    TResult? Function(String query)? searchChanged,
    TResult? Function(String code)? toggled,
  }) {
    final _that = this;
    switch (_that) {
      case AddCurrencyStarted() when started != null:
        return started();
      case AddCurrencySearchChanged() when searchChanged != null:
        return searchChanged(_that.query);
      case AddCurrencyToggled() when toggled != null:
        return toggled(_that.code);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AddCurrencyStarted implements AddCurrencyEvent {
  const AddCurrencyStarted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddCurrencyStarted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddCurrencyEvent.started()';
  }
}

/// @nodoc

class AddCurrencySearchChanged implements AddCurrencyEvent {
  const AddCurrencySearchChanged({required this.query});

  final String query;

  /// Create a copy of AddCurrencyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCurrencySearchChangedCopyWith<AddCurrencySearchChanged> get copyWith =>
      _$AddCurrencySearchChangedCopyWithImpl<AddCurrencySearchChanged>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCurrencySearchChanged &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @override
  String toString() {
    return 'AddCurrencyEvent.searchChanged(query: $query)';
  }
}

/// @nodoc
abstract mixin class $AddCurrencySearchChangedCopyWith<$Res>
    implements $AddCurrencyEventCopyWith<$Res> {
  factory $AddCurrencySearchChangedCopyWith(AddCurrencySearchChanged value,
          $Res Function(AddCurrencySearchChanged) _then) =
      _$AddCurrencySearchChangedCopyWithImpl;
  @useResult
  $Res call({String query});
}

/// @nodoc
class _$AddCurrencySearchChangedCopyWithImpl<$Res>
    implements $AddCurrencySearchChangedCopyWith<$Res> {
  _$AddCurrencySearchChangedCopyWithImpl(this._self, this._then);

  final AddCurrencySearchChanged _self;
  final $Res Function(AddCurrencySearchChanged) _then;

  /// Create a copy of AddCurrencyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? query = null,
  }) {
    return _then(AddCurrencySearchChanged(
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AddCurrencyToggled implements AddCurrencyEvent {
  const AddCurrencyToggled({required this.code});

  final String code;

  /// Create a copy of AddCurrencyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCurrencyToggledCopyWith<AddCurrencyToggled> get copyWith =>
      _$AddCurrencyToggledCopyWithImpl<AddCurrencyToggled>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCurrencyToggled &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @override
  String toString() {
    return 'AddCurrencyEvent.toggled(code: $code)';
  }
}

/// @nodoc
abstract mixin class $AddCurrencyToggledCopyWith<$Res>
    implements $AddCurrencyEventCopyWith<$Res> {
  factory $AddCurrencyToggledCopyWith(
          AddCurrencyToggled value, $Res Function(AddCurrencyToggled) _then) =
      _$AddCurrencyToggledCopyWithImpl;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$AddCurrencyToggledCopyWithImpl<$Res>
    implements $AddCurrencyToggledCopyWith<$Res> {
  _$AddCurrencyToggledCopyWithImpl(this._self, this._then);

  final AddCurrencyToggled _self;
  final $Res Function(AddCurrencyToggled) _then;

  /// Create a copy of AddCurrencyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
  }) {
    return _then(AddCurrencyToggled(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
