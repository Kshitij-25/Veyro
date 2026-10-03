// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingState {

 TrackedActivityType get type; TrackingStatus get status;/// Live numbers while a session is active or paused.
 TrackingSnapshot? get snapshot; LocationPermissionStatus? get permission; bool get isSaving;/// The most recently saved activity, until acknowledged.
 TrackedActivity? get savedActivity; Failure? get failure;
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingStateCopyWith<TrackingState> get copyWith => _$TrackingStateCopyWithImpl<TrackingState>(this as TrackingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TrackingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingState&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.snapshot, _this.snapshot) || other.snapshot == _this.snapshot)&&(identical(other.permission, _this.permission) || other.permission == _this.permission)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.savedActivity, _this.savedActivity) || other.savedActivity == _this.savedActivity)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as TrackingState;
  return Object.hash(runtimeType,_this.type,_this.status,_this.snapshot,_this.permission,_this.isSaving,_this.savedActivity,_this.failure);
}

@override
String toString() {
  final _this = this as TrackingState;
  return 'TrackingState(type: ${_this.type}, status: ${_this.status}, snapshot: ${_this.snapshot}, permission: ${_this.permission}, isSaving: ${_this.isSaving}, savedActivity: ${_this.savedActivity}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $TrackingStateCopyWith<$Res>  {
  factory $TrackingStateCopyWith(TrackingState value, $Res Function(TrackingState) _then) = _$TrackingStateCopyWithImpl;
@useResult
$Res call({
 TrackedActivityType type, TrackingStatus status, TrackingSnapshot? snapshot, LocationPermissionStatus? permission, bool isSaving, TrackedActivity? savedActivity, Failure? failure
});


$TrackingSnapshotCopyWith<$Res>? get snapshot;$TrackedActivityCopyWith<$Res>? get savedActivity;

}
/// @nodoc
class _$TrackingStateCopyWithImpl<$Res>
    implements $TrackingStateCopyWith<$Res> {
  _$TrackingStateCopyWithImpl(this._self, this._then);

  final TrackingState _self;
  final $Res Function(TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = null,Object? snapshot = freezed,Object? permission = freezed,Object? isSaving = null,Object? savedActivity = freezed,Object? failure = freezed,}) {
  return _then(TrackingState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TrackedActivityType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackingStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as TrackingSnapshot?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as LocationPermissionStatus?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,savedActivity: freezed == savedActivity ? _self.savedActivity : savedActivity // ignore: cast_nullable_to_non_nullable
as TrackedActivity?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $TrackingSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackedActivityCopyWith<$Res>? get savedActivity {
    if (_self.savedActivity == null) {
    return null;
  }

  return $TrackedActivityCopyWith<$Res>(_self.savedActivity!, (value) {
    return _then(_self.copyWith(savedActivity: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackingState].
extension TrackingStatePatterns on TrackingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingState value)  $default,){
final _that = this;
switch (_that) {
case _TrackingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingState value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrackedActivityType type,  TrackingStatus status,  TrackingSnapshot? snapshot,  LocationPermissionStatus? permission,  bool isSaving,  TrackedActivity? savedActivity,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.type,_that.status,_that.snapshot,_that.permission,_that.isSaving,_that.savedActivity,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrackedActivityType type,  TrackingStatus status,  TrackingSnapshot? snapshot,  LocationPermissionStatus? permission,  bool isSaving,  TrackedActivity? savedActivity,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _TrackingState():
return $default(_that.type,_that.status,_that.snapshot,_that.permission,_that.isSaving,_that.savedActivity,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrackedActivityType type,  TrackingStatus status,  TrackingSnapshot? snapshot,  LocationPermissionStatus? permission,  bool isSaving,  TrackedActivity? savedActivity,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.type,_that.status,_that.snapshot,_that.permission,_that.isSaving,_that.savedActivity,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TrackingState implements TrackingState {
  const _TrackingState({this.type = TrackedActivityType.run, this.status = TrackingStatus.idle, this.snapshot, this.permission, this.isSaving = false, this.savedActivity, this.failure});
  

@override@JsonKey() final  TrackedActivityType type;
@override@JsonKey() final  TrackingStatus status;
/// Live numbers while a session is active or paused.
@override final  TrackingSnapshot? snapshot;
@override final  LocationPermissionStatus? permission;
@override@JsonKey() final  bool isSaving;
/// The most recently saved activity, until acknowledged.
@override final  TrackedActivity? savedActivity;
@override final  Failure? failure;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingStateCopyWith<_TrackingState> get copyWith => __$TrackingStateCopyWithImpl<_TrackingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingState&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.savedActivity, savedActivity) || other.savedActivity == savedActivity)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,status,snapshot,permission,isSaving,savedActivity,failure);
}

@override
String toString() {
    return 'TrackingState(type: $type, status: $status, snapshot: $snapshot, permission: $permission, isSaving: $isSaving, savedActivity: $savedActivity, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TrackingStateCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory _$TrackingStateCopyWith(_TrackingState value, $Res Function(_TrackingState) _then) = __$TrackingStateCopyWithImpl;
@override @useResult
$Res call({
 TrackedActivityType type, TrackingStatus status, TrackingSnapshot? snapshot, LocationPermissionStatus? permission, bool isSaving, TrackedActivity? savedActivity, Failure? failure
});


@override $TrackingSnapshotCopyWith<$Res>? get snapshot;@override $TrackedActivityCopyWith<$Res>? get savedActivity;

}
/// @nodoc
class __$TrackingStateCopyWithImpl<$Res>
    implements _$TrackingStateCopyWith<$Res> {
  __$TrackingStateCopyWithImpl(this._self, this._then);

  final _TrackingState _self;
  final $Res Function(_TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = null,Object? snapshot = freezed,Object? permission = freezed,Object? isSaving = null,Object? savedActivity = freezed,Object? failure = freezed,}) {
  return _then(_TrackingState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TrackedActivityType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackingStatus,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as TrackingSnapshot?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as LocationPermissionStatus?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,savedActivity: freezed == savedActivity ? _self.savedActivity : savedActivity // ignore: cast_nullable_to_non_nullable
as TrackedActivity?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $TrackingSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackedActivityCopyWith<$Res>? get savedActivity {
    if (_self.savedActivity == null) {
    return null;
  }

  return $TrackedActivityCopyWith<$Res>(_self.savedActivity!, (value) {
    return _then(_self.copyWith(savedActivity: value));
  });
}
}

// dart format on
