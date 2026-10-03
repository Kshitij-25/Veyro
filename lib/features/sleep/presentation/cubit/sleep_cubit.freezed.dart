// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepState {

 ViewStatus get status;/// Oldest first.
 List<SleepNight> get nights;/// Imported history, oldest first.
 List<SleepDay> get history; Failure? get failure;
/// Create a copy of SleepState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepStateCopyWith<SleepState> get copyWith => _$SleepStateCopyWithImpl<SleepState>(this as SleepState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SleepState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.nights, _this.nights)&&const DeepCollectionEquality().equals(other.history, _this.history)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as SleepState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.nights),const DeepCollectionEquality().hash(_this.history),_this.failure);
}

@override
String toString() {
  final _this = this as SleepState;
  return 'SleepState(status: ${_this.status}, nights: ${_this.nights}, history: ${_this.history}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $SleepStateCopyWith<$Res>  {
  factory $SleepStateCopyWith(SleepState value, $Res Function(SleepState) _then) = _$SleepStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<SleepNight> nights, List<SleepDay> history, Failure? failure
});




}
/// @nodoc
class _$SleepStateCopyWithImpl<$Res>
    implements $SleepStateCopyWith<$Res> {
  _$SleepStateCopyWithImpl(this._self, this._then);

  final SleepState _self;
  final $Res Function(SleepState) _then;

/// Create a copy of SleepState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? nights = null,Object? history = null,Object? failure = freezed,}) {
  return _then(SleepState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,nights: null == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as List<SleepNight>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<SleepDay>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepState].
extension SleepStatePatterns on SleepState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepState value)  $default,){
final _that = this;
switch (_that) {
case _SleepState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepState value)?  $default,){
final _that = this;
switch (_that) {
case _SleepState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<SleepNight> nights,  List<SleepDay> history,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepState() when $default != null:
return $default(_that.status,_that.nights,_that.history,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<SleepNight> nights,  List<SleepDay> history,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SleepState():
return $default(_that.status,_that.nights,_that.history,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<SleepNight> nights,  List<SleepDay> history,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SleepState() when $default != null:
return $default(_that.status,_that.nights,_that.history,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SleepState implements SleepState {
  const _SleepState({this.status = ViewStatus.initial,  List<SleepNight> nights = const [],  List<SleepDay> history = const [], this.failure}): _nights = nights,_history = history;
  

@override@JsonKey() final  ViewStatus status;
/// Oldest first.
 final  List<SleepNight> _nights;
/// Oldest first.
@override@JsonKey() List<SleepNight> get nights {
  if (_nights is EqualUnmodifiableListView) return _nights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nights);
}

/// Imported history, oldest first.
 final  List<SleepDay> _history;
/// Imported history, oldest first.
@override@JsonKey() List<SleepDay> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override final  Failure? failure;

/// Create a copy of SleepState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepStateCopyWith<_SleepState> get copyWith => __$SleepStateCopyWithImpl<_SleepState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.nights, _nights)&&const DeepCollectionEquality().equals(other.history, _history)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_nights),const DeepCollectionEquality().hash(_history),failure);
}

@override
String toString() {
    return 'SleepState(status: $status, nights: $nights, history: $history, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SleepStateCopyWith<$Res> implements $SleepStateCopyWith<$Res> {
  factory _$SleepStateCopyWith(_SleepState value, $Res Function(_SleepState) _then) = __$SleepStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<SleepNight> nights, List<SleepDay> history, Failure? failure
});




}
/// @nodoc
class __$SleepStateCopyWithImpl<$Res>
    implements _$SleepStateCopyWith<$Res> {
  __$SleepStateCopyWithImpl(this._self, this._then);

  final _SleepState _self;
  final $Res Function(_SleepState) _then;

/// Create a copy of SleepState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? nights = null,Object? history = null,Object? failure = freezed,}) {
  return _then(_SleepState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,nights: null == nights ? _self._nights : nights // ignore: cast_nullable_to_non_nullable
as List<SleepNight>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<SleepDay>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
