// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutDetailState {

 ViewStatus get status; Workout? get workout; Failure? get failure;
/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutDetailStateCopyWith<WorkoutDetailState> get copyWith => _$WorkoutDetailStateCopyWithImpl<WorkoutDetailState>(this as WorkoutDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WorkoutDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutDetailState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.workout, _this.workout) || other.workout == _this.workout)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as WorkoutDetailState;
  return Object.hash(runtimeType,_this.status,_this.workout,_this.failure);
}

@override
String toString() {
  final _this = this as WorkoutDetailState;
  return 'WorkoutDetailState(status: ${_this.status}, workout: ${_this.workout}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $WorkoutDetailStateCopyWith<$Res>  {
  factory $WorkoutDetailStateCopyWith(WorkoutDetailState value, $Res Function(WorkoutDetailState) _then) = _$WorkoutDetailStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, Workout? workout, Failure? failure
});


$WorkoutCopyWith<$Res>? get workout;

}
/// @nodoc
class _$WorkoutDetailStateCopyWithImpl<$Res>
    implements $WorkoutDetailStateCopyWith<$Res> {
  _$WorkoutDetailStateCopyWithImpl(this._self, this._then);

  final WorkoutDetailState _self;
  final $Res Function(WorkoutDetailState) _then;

/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? workout = freezed,Object? failure = freezed,}) {
  return _then(WorkoutDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workout: freezed == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get workout {
    if (_self.workout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.workout!, (value) {
    return _then(_self.copyWith(workout: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkoutDetailState].
extension WorkoutDetailStatePatterns on WorkoutDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutDetailState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  Workout? workout,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutDetailState() when $default != null:
return $default(_that.status,_that.workout,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  Workout? workout,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutDetailState():
return $default(_that.status,_that.workout,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  Workout? workout,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutDetailState() when $default != null:
return $default(_that.status,_that.workout,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutDetailState implements WorkoutDetailState {
  const _WorkoutDetailState({this.status = ViewStatus.initial, this.workout, this.failure});
  

@override@JsonKey() final  ViewStatus status;
@override final  Workout? workout;
@override final  Failure? failure;

/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutDetailStateCopyWith<_WorkoutDetailState> get copyWith => __$WorkoutDetailStateCopyWithImpl<_WorkoutDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.workout, workout) || other.workout == workout)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,workout,failure);
}

@override
String toString() {
    return 'WorkoutDetailState(status: $status, workout: $workout, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutDetailStateCopyWith<$Res> implements $WorkoutDetailStateCopyWith<$Res> {
  factory _$WorkoutDetailStateCopyWith(_WorkoutDetailState value, $Res Function(_WorkoutDetailState) _then) = __$WorkoutDetailStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, Workout? workout, Failure? failure
});


@override $WorkoutCopyWith<$Res>? get workout;

}
/// @nodoc
class __$WorkoutDetailStateCopyWithImpl<$Res>
    implements _$WorkoutDetailStateCopyWith<$Res> {
  __$WorkoutDetailStateCopyWithImpl(this._self, this._then);

  final _WorkoutDetailState _self;
  final $Res Function(_WorkoutDetailState) _then;

/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? workout = freezed,Object? failure = freezed,}) {
  return _then(_WorkoutDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workout: freezed == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of WorkoutDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get workout {
    if (_self.workout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.workout!, (value) {
    return _then(_self.copyWith(workout: value));
  });
}
}

// dart format on
