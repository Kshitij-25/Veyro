// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracked_activities_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackedActivitiesState {

 ViewStatus get status;/// Newest first.
 List<TrackedActivity> get activities; Failure? get failure;
/// Create a copy of TrackedActivitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackedActivitiesStateCopyWith<TrackedActivitiesState> get copyWith => _$TrackedActivitiesStateCopyWithImpl<TrackedActivitiesState>(this as TrackedActivitiesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TrackedActivitiesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedActivitiesState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.activities, _this.activities)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as TrackedActivitiesState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.activities),_this.failure);
}

@override
String toString() {
  final _this = this as TrackedActivitiesState;
  return 'TrackedActivitiesState(status: ${_this.status}, activities: ${_this.activities}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $TrackedActivitiesStateCopyWith<$Res>  {
  factory $TrackedActivitiesStateCopyWith(TrackedActivitiesState value, $Res Function(TrackedActivitiesState) _then) = _$TrackedActivitiesStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<TrackedActivity> activities, Failure? failure
});




}
/// @nodoc
class _$TrackedActivitiesStateCopyWithImpl<$Res>
    implements $TrackedActivitiesStateCopyWith<$Res> {
  _$TrackedActivitiesStateCopyWithImpl(this._self, this._then);

  final TrackedActivitiesState _self;
  final $Res Function(TrackedActivitiesState) _then;

/// Create a copy of TrackedActivitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? activities = null,Object? failure = freezed,}) {
  return _then(TrackedActivitiesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<TrackedActivity>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackedActivitiesState].
extension TrackedActivitiesStatePatterns on TrackedActivitiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackedActivitiesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackedActivitiesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackedActivitiesState value)  $default,){
final _that = this;
switch (_that) {
case _TrackedActivitiesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackedActivitiesState value)?  $default,){
final _that = this;
switch (_that) {
case _TrackedActivitiesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<TrackedActivity> activities,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackedActivitiesState() when $default != null:
return $default(_that.status,_that.activities,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<TrackedActivity> activities,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _TrackedActivitiesState():
return $default(_that.status,_that.activities,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<TrackedActivity> activities,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TrackedActivitiesState() when $default != null:
return $default(_that.status,_that.activities,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TrackedActivitiesState implements TrackedActivitiesState {
  const _TrackedActivitiesState({this.status = ViewStatus.initial,  List<TrackedActivity> activities = const [], this.failure}): _activities = activities;
  

@override@JsonKey() final  ViewStatus status;
/// Newest first.
 final  List<TrackedActivity> _activities;
/// Newest first.
@override@JsonKey() List<TrackedActivity> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

@override final  Failure? failure;

/// Create a copy of TrackedActivitiesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackedActivitiesStateCopyWith<_TrackedActivitiesState> get copyWith => __$TrackedActivitiesStateCopyWithImpl<_TrackedActivitiesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackedActivitiesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.activities, _activities)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_activities),failure);
}

@override
String toString() {
    return 'TrackedActivitiesState(status: $status, activities: $activities, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TrackedActivitiesStateCopyWith<$Res> implements $TrackedActivitiesStateCopyWith<$Res> {
  factory _$TrackedActivitiesStateCopyWith(_TrackedActivitiesState value, $Res Function(_TrackedActivitiesState) _then) = __$TrackedActivitiesStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<TrackedActivity> activities, Failure? failure
});




}
/// @nodoc
class __$TrackedActivitiesStateCopyWithImpl<$Res>
    implements _$TrackedActivitiesStateCopyWith<$Res> {
  __$TrackedActivitiesStateCopyWithImpl(this._self, this._then);

  final _TrackedActivitiesState _self;
  final $Res Function(_TrackedActivitiesState) _then;

/// Create a copy of TrackedActivitiesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? activities = null,Object? failure = freezed,}) {
  return _then(_TrackedActivitiesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<TrackedActivity>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
