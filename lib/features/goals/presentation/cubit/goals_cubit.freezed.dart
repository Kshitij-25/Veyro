// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goals_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalsState {

 ViewStatus get status; List<GoalProgress> get progress; Failure? get failure;
/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalsStateCopyWith<GoalsState> get copyWith => _$GoalsStateCopyWithImpl<GoalsState>(this as GoalsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.progress, _this.progress)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as GoalsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.progress),_this.failure);
}

@override
String toString() {
  final _this = this as GoalsState;
  return 'GoalsState(status: ${_this.status}, progress: ${_this.progress}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $GoalsStateCopyWith<$Res>  {
  factory $GoalsStateCopyWith(GoalsState value, $Res Function(GoalsState) _then) = _$GoalsStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<GoalProgress> progress, Failure? failure
});




}
/// @nodoc
class _$GoalsStateCopyWithImpl<$Res>
    implements $GoalsStateCopyWith<$Res> {
  _$GoalsStateCopyWithImpl(this._self, this._then);

  final GoalsState _self;
  final $Res Function(GoalsState) _then;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? progress = null,Object? failure = freezed,}) {
  return _then(GoalsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as List<GoalProgress>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalsState].
extension GoalsStatePatterns on GoalsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalsState value)  $default,){
final _that = this;
switch (_that) {
case _GoalsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalsState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<GoalProgress> progress,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
return $default(_that.status,_that.progress,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<GoalProgress> progress,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _GoalsState():
return $default(_that.status,_that.progress,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<GoalProgress> progress,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _GoalsState() when $default != null:
return $default(_that.status,_that.progress,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _GoalsState implements GoalsState {
  const _GoalsState({this.status = ViewStatus.initial,  List<GoalProgress> progress = const [], this.failure}): _progress = progress;
  

@override@JsonKey() final  ViewStatus status;
 final  List<GoalProgress> _progress;
@override@JsonKey() List<GoalProgress> get progress {
  if (_progress is EqualUnmodifiableListView) return _progress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_progress);
}

@override final  Failure? failure;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalsStateCopyWith<_GoalsState> get copyWith => __$GoalsStateCopyWithImpl<_GoalsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.progress, _progress)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_progress),failure);
}

@override
String toString() {
    return 'GoalsState(status: $status, progress: $progress, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$GoalsStateCopyWith<$Res> implements $GoalsStateCopyWith<$Res> {
  factory _$GoalsStateCopyWith(_GoalsState value, $Res Function(_GoalsState) _then) = __$GoalsStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<GoalProgress> progress, Failure? failure
});




}
/// @nodoc
class __$GoalsStateCopyWithImpl<$Res>
    implements _$GoalsStateCopyWith<$Res> {
  __$GoalsStateCopyWithImpl(this._self, this._then);

  final _GoalsState _self;
  final $Res Function(_GoalsState) _then;

/// Create a copy of GoalsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? progress = null,Object? failure = freezed,}) {
  return _then(_GoalsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,progress: null == progress ? _self._progress : progress // ignore: cast_nullable_to_non_nullable
as List<GoalProgress>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
