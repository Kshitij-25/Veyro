// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutHistoryState {

 ViewStatus get status;/// Newest first.
 List<Workout> get workouts; Failure? get failure;
/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutHistoryStateCopyWith<WorkoutHistoryState> get copyWith => _$WorkoutHistoryStateCopyWithImpl<WorkoutHistoryState>(this as WorkoutHistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WorkoutHistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutHistoryState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.workouts, _this.workouts)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as WorkoutHistoryState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.workouts),_this.failure);
}

@override
String toString() {
  final _this = this as WorkoutHistoryState;
  return 'WorkoutHistoryState(status: ${_this.status}, workouts: ${_this.workouts}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $WorkoutHistoryStateCopyWith<$Res>  {
  factory $WorkoutHistoryStateCopyWith(WorkoutHistoryState value, $Res Function(WorkoutHistoryState) _then) = _$WorkoutHistoryStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<Workout> workouts, Failure? failure
});




}
/// @nodoc
class _$WorkoutHistoryStateCopyWithImpl<$Res>
    implements $WorkoutHistoryStateCopyWith<$Res> {
  _$WorkoutHistoryStateCopyWithImpl(this._self, this._then);

  final WorkoutHistoryState _self;
  final $Res Function(WorkoutHistoryState) _then;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? workouts = null,Object? failure = freezed,}) {
  return _then(WorkoutHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workouts: null == workouts ? _self.workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutHistoryState].
extension WorkoutHistoryStatePatterns on WorkoutHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<Workout> workouts,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
return $default(_that.status,_that.workouts,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<Workout> workouts,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutHistoryState():
return $default(_that.status,_that.workouts,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<Workout> workouts,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
return $default(_that.status,_that.workouts,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutHistoryState implements WorkoutHistoryState {
  const _WorkoutHistoryState({this.status = ViewStatus.initial,  List<Workout> workouts = const [], this.failure}): _workouts = workouts;
  

@override@JsonKey() final  ViewStatus status;
/// Newest first.
 final  List<Workout> _workouts;
/// Newest first.
@override@JsonKey() List<Workout> get workouts {
  if (_workouts is EqualUnmodifiableListView) return _workouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workouts);
}

@override final  Failure? failure;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutHistoryStateCopyWith<_WorkoutHistoryState> get copyWith => __$WorkoutHistoryStateCopyWithImpl<_WorkoutHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.workouts, _workouts)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_workouts),failure);
}

@override
String toString() {
    return 'WorkoutHistoryState(status: $status, workouts: $workouts, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutHistoryStateCopyWith<$Res> implements $WorkoutHistoryStateCopyWith<$Res> {
  factory _$WorkoutHistoryStateCopyWith(_WorkoutHistoryState value, $Res Function(_WorkoutHistoryState) _then) = __$WorkoutHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<Workout> workouts, Failure? failure
});




}
/// @nodoc
class __$WorkoutHistoryStateCopyWithImpl<$Res>
    implements _$WorkoutHistoryStateCopyWith<$Res> {
  __$WorkoutHistoryStateCopyWithImpl(this._self, this._then);

  final _WorkoutHistoryState _self;
  final $Res Function(_WorkoutHistoryState) _then;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? workouts = null,Object? failure = freezed,}) {
  return _then(_WorkoutHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,workouts: null == workouts ? _self._workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
