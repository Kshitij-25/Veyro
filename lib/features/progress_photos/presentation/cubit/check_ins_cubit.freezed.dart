// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_ins_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckInsState {

 bool get loaded;/// Newest first.
 List<CheckIn> get checkIns; Failure? get failure;
/// Create a copy of CheckInsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInsStateCopyWith<CheckInsState> get copyWith => _$CheckInsStateCopyWithImpl<CheckInsState>(this as CheckInsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckInsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInsState&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&const DeepCollectionEquality().equals(other.checkIns, _this.checkIns)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as CheckInsState;
  return Object.hash(runtimeType,_this.loaded,const DeepCollectionEquality().hash(_this.checkIns),_this.failure);
}

@override
String toString() {
  final _this = this as CheckInsState;
  return 'CheckInsState(loaded: ${_this.loaded}, checkIns: ${_this.checkIns}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $CheckInsStateCopyWith<$Res>  {
  factory $CheckInsStateCopyWith(CheckInsState value, $Res Function(CheckInsState) _then) = _$CheckInsStateCopyWithImpl;
@useResult
$Res call({
 bool loaded, List<CheckIn> checkIns, Failure? failure
});




}
/// @nodoc
class _$CheckInsStateCopyWithImpl<$Res>
    implements $CheckInsStateCopyWith<$Res> {
  _$CheckInsStateCopyWithImpl(this._self, this._then);

  final CheckInsState _self;
  final $Res Function(CheckInsState) _then;

/// Create a copy of CheckInsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? checkIns = null,Object? failure = freezed,}) {
  return _then(CheckInsState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,checkIns: null == checkIns ? _self.checkIns : checkIns // ignore: cast_nullable_to_non_nullable
as List<CheckIn>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckInsState].
extension CheckInsStatePatterns on CheckInsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInsState value)  $default,){
final _that = this;
switch (_that) {
case _CheckInsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInsState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loaded,  List<CheckIn> checkIns,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInsState() when $default != null:
return $default(_that.loaded,_that.checkIns,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loaded,  List<CheckIn> checkIns,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _CheckInsState():
return $default(_that.loaded,_that.checkIns,_that.failure);case _:
  throw StateError('Unexpected subclass');

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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loaded,  List<CheckIn> checkIns,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _CheckInsState() when $default != null:
return $default(_that.loaded,_that.checkIns,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _CheckInsState implements CheckInsState {
  const _CheckInsState({this.loaded = false,  List<CheckIn> checkIns = const [], this.failure}): _checkIns = checkIns;
  

@override@JsonKey() final  bool loaded;
/// Newest first.
 final  List<CheckIn> _checkIns;
/// Newest first.
@override@JsonKey() List<CheckIn> get checkIns {
  if (_checkIns is EqualUnmodifiableListView) return _checkIns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checkIns);
}

@override final  Failure? failure;

/// Create a copy of CheckInsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInsStateCopyWith<_CheckInsState> get copyWith => __$CheckInsStateCopyWithImpl<_CheckInsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInsState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&const DeepCollectionEquality().equals(other.checkIns, _checkIns)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loaded,const DeepCollectionEquality().hash(_checkIns),failure);
}

@override
String toString() {
    return 'CheckInsState(loaded: $loaded, checkIns: $checkIns, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$CheckInsStateCopyWith<$Res> implements $CheckInsStateCopyWith<$Res> {
  factory _$CheckInsStateCopyWith(_CheckInsState value, $Res Function(_CheckInsState) _then) = __$CheckInsStateCopyWithImpl;
@override @useResult
$Res call({
 bool loaded, List<CheckIn> checkIns, Failure? failure
});




}
/// @nodoc
class __$CheckInsStateCopyWithImpl<$Res>
    implements _$CheckInsStateCopyWith<$Res> {
  __$CheckInsStateCopyWithImpl(this._self, this._then);

  final _CheckInsState _self;
  final $Res Function(_CheckInsState) _then;

/// Create a copy of CheckInsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? checkIns = null,Object? failure = freezed,}) {
  return _then(_CheckInsState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,checkIns: null == checkIns ? _self._checkIns : checkIns // ignore: cast_nullable_to_non_nullable
as List<CheckIn>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
