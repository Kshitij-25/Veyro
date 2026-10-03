// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_workout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveWorkoutState {

 ViewStatus get status;/// The in-progress workout, or `null` when none is running.
 Workout? get workout; Failure? get failure;/// A start/finish/discard operation is running.
 bool get isBusy;/// The workout that was just finished, until acknowledged.
 Workout? get finishedWorkout;
/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveWorkoutStateCopyWith<ActiveWorkoutState> get copyWith => _$ActiveWorkoutStateCopyWithImpl<ActiveWorkoutState>(this as ActiveWorkoutState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActiveWorkoutState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveWorkoutState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.workout, _this.workout) || other.workout == _this.workout)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.isBusy, _this.isBusy) || other.isBusy == _this.isBusy)&&(identical(other.finishedWorkout, _this.finishedWorkout) || other.finishedWorkout == _this.finishedWorkout));
}


@override
int get hashCode {
  final _this = this as ActiveWorkoutState;
  return Object.hash(runtimeType,_this.status,_this.workout,_this.failure,_this.isBusy,_this.finishedWorkout);
}

@override
String toString() {
  final _this = this as ActiveWorkoutState;
  return 'ActiveWorkoutState(status: ${_this.status}, workout: ${_this.workout}, failure: ${_this.failure}, isBusy: ${_this.isBusy}, finishedWorkout: ${_this.finishedWorkout})';
}


}

/// @nodoc
abstract mixin class $ActiveWorkoutStateCopyWith<$Res>  {
  factory $ActiveWorkoutStateCopyWith(ActiveWorkoutState value, $Res Function(ActiveWorkoutState) _then) = _$ActiveWorkoutStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, Workout? workout, Failure? failure, bool isBusy, Workout? finishedWorkout
});


$WorkoutCopyWith<$Res>? get workout;$WorkoutCopyWith<$Res>? get finishedWorkout;

}
/// @nodoc
class _$ActiveWorkoutStateCopyWithImpl<$Res>
    implements $ActiveWorkoutStateCopyWith<$Res> {
  _$ActiveWorkoutStateCopyWithImpl(this._self, this._then);

  final ActiveWorkoutState _self;
  final $Res Function(ActiveWorkoutState) _then;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? workout = freezed,Object? failure = freezed,Object? isBusy = null,Object? finishedWorkout = freezed,}) {
  return _then(ActiveWorkoutState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workout: freezed == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,finishedWorkout: freezed == finishedWorkout ? _self.finishedWorkout : finishedWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,
  ));
}
/// Create a copy of ActiveWorkoutState
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
}/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get finishedWorkout {
    if (_self.finishedWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.finishedWorkout!, (value) {
    return _then(_self.copyWith(finishedWorkout: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveWorkoutState].
extension ActiveWorkoutStatePatterns on ActiveWorkoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveWorkoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveWorkoutState value)  $default,){
final _that = this;
switch (_that) {
case _ActiveWorkoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveWorkoutState value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  Workout? workout,  Failure? failure,  bool isBusy,  Workout? finishedWorkout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
return $default(_that.status,_that.workout,_that.failure,_that.isBusy,_that.finishedWorkout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  Workout? workout,  Failure? failure,  bool isBusy,  Workout? finishedWorkout)  $default,) {final _that = this;
switch (_that) {
case _ActiveWorkoutState():
return $default(_that.status,_that.workout,_that.failure,_that.isBusy,_that.finishedWorkout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  Workout? workout,  Failure? failure,  bool isBusy,  Workout? finishedWorkout)?  $default,) {final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
return $default(_that.status,_that.workout,_that.failure,_that.isBusy,_that.finishedWorkout);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveWorkoutState extends ActiveWorkoutState {
  const _ActiveWorkoutState({this.status = ViewStatus.initial, this.workout, this.failure, this.isBusy = false, this.finishedWorkout}): super._();
  

@override@JsonKey() final  ViewStatus status;
/// The in-progress workout, or `null` when none is running.
@override final  Workout? workout;
@override final  Failure? failure;
/// A start/finish/discard operation is running.
@override@JsonKey() final  bool isBusy;
/// The workout that was just finished, until acknowledged.
@override final  Workout? finishedWorkout;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveWorkoutStateCopyWith<_ActiveWorkoutState> get copyWith => __$ActiveWorkoutStateCopyWithImpl<_ActiveWorkoutState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveWorkoutState&&(identical(other.status, status) || other.status == status)&&(identical(other.workout, workout) || other.workout == workout)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.finishedWorkout, finishedWorkout) || other.finishedWorkout == finishedWorkout));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,workout,failure,isBusy,finishedWorkout);
}

@override
String toString() {
    return 'ActiveWorkoutState(status: $status, workout: $workout, failure: $failure, isBusy: $isBusy, finishedWorkout: $finishedWorkout)';
}


}

/// @nodoc
abstract mixin class _$ActiveWorkoutStateCopyWith<$Res> implements $ActiveWorkoutStateCopyWith<$Res> {
  factory _$ActiveWorkoutStateCopyWith(_ActiveWorkoutState value, $Res Function(_ActiveWorkoutState) _then) = __$ActiveWorkoutStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, Workout? workout, Failure? failure, bool isBusy, Workout? finishedWorkout
});


@override $WorkoutCopyWith<$Res>? get workout;@override $WorkoutCopyWith<$Res>? get finishedWorkout;

}
/// @nodoc
class __$ActiveWorkoutStateCopyWithImpl<$Res>
    implements _$ActiveWorkoutStateCopyWith<$Res> {
  __$ActiveWorkoutStateCopyWithImpl(this._self, this._then);

  final _ActiveWorkoutState _self;
  final $Res Function(_ActiveWorkoutState) _then;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? workout = freezed,Object? failure = freezed,Object? isBusy = null,Object? finishedWorkout = freezed,}) {
  return _then(_ActiveWorkoutState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workout: freezed == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,finishedWorkout: freezed == finishedWorkout ? _self.finishedWorkout : finishedWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,
  ));
}

/// Create a copy of ActiveWorkoutState
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
}/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get finishedWorkout {
    if (_self.finishedWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.finishedWorkout!, (value) {
    return _then(_self.copyWith(finishedWorkout: value));
  });
}
}

// dart format on
