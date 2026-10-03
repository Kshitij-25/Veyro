// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityState {

 ViewStatus get status; DailyActivity? get today;/// The last seven days, oldest first, ending today.
 List<DailyActivity> get week; HealthAccessStatus get healthAccess; bool get isSyncing; Failure? get failure;
/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityStateCopyWith<ActivityState> get copyWith => _$ActivityStateCopyWithImpl<ActivityState>(this as ActivityState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivityState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.today, _this.today) || other.today == _this.today)&&const DeepCollectionEquality().equals(other.week, _this.week)&&(identical(other.healthAccess, _this.healthAccess) || other.healthAccess == _this.healthAccess)&&(identical(other.isSyncing, _this.isSyncing) || other.isSyncing == _this.isSyncing)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ActivityState;
  return Object.hash(runtimeType,_this.status,_this.today,const DeepCollectionEquality().hash(_this.week),_this.healthAccess,_this.isSyncing,_this.failure);
}

@override
String toString() {
  final _this = this as ActivityState;
  return 'ActivityState(status: ${_this.status}, today: ${_this.today}, week: ${_this.week}, healthAccess: ${_this.healthAccess}, isSyncing: ${_this.isSyncing}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ActivityStateCopyWith<$Res>  {
  factory $ActivityStateCopyWith(ActivityState value, $Res Function(ActivityState) _then) = _$ActivityStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, DailyActivity? today, List<DailyActivity> week, HealthAccessStatus healthAccess, bool isSyncing, Failure? failure
});


$DailyActivityCopyWith<$Res>? get today;

}
/// @nodoc
class _$ActivityStateCopyWithImpl<$Res>
    implements $ActivityStateCopyWith<$Res> {
  _$ActivityStateCopyWithImpl(this._self, this._then);

  final ActivityState _self;
  final $Res Function(ActivityState) _then;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? today = freezed,Object? week = null,Object? healthAccess = null,Object? isSyncing = null,Object? failure = freezed,}) {
  return _then(ActivityState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DailyActivity?,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as List<DailyActivity>,healthAccess: null == healthAccess ? _self.healthAccess : healthAccess // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyActivityCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $DailyActivityCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityState].
extension ActivityStatePatterns on ActivityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityState value)  $default,){
final _that = this;
switch (_that) {
case _ActivityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityState value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  DailyActivity? today,  List<DailyActivity> week,  HealthAccessStatus healthAccess,  bool isSyncing,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
return $default(_that.status,_that.today,_that.week,_that.healthAccess,_that.isSyncing,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  DailyActivity? today,  List<DailyActivity> week,  HealthAccessStatus healthAccess,  bool isSyncing,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ActivityState():
return $default(_that.status,_that.today,_that.week,_that.healthAccess,_that.isSyncing,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  DailyActivity? today,  List<DailyActivity> week,  HealthAccessStatus healthAccess,  bool isSyncing,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ActivityState() when $default != null:
return $default(_that.status,_that.today,_that.week,_that.healthAccess,_that.isSyncing,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityState implements ActivityState {
  const _ActivityState({this.status = ViewStatus.initial, this.today,  List<DailyActivity> week = const [], this.healthAccess = HealthAccessStatus.unknown, this.isSyncing = false, this.failure}): _week = week;
  

@override@JsonKey() final  ViewStatus status;
@override final  DailyActivity? today;
/// The last seven days, oldest first, ending today.
 final  List<DailyActivity> _week;
/// The last seven days, oldest first, ending today.
@override@JsonKey() List<DailyActivity> get week {
  if (_week is EqualUnmodifiableListView) return _week;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_week);
}

@override@JsonKey() final  HealthAccessStatus healthAccess;
@override@JsonKey() final  bool isSyncing;
@override final  Failure? failure;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityStateCopyWith<_ActivityState> get copyWith => __$ActivityStateCopyWithImpl<_ActivityState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityState&&(identical(other.status, status) || other.status == status)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other.week, _week)&&(identical(other.healthAccess, healthAccess) || other.healthAccess == healthAccess)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,today,const DeepCollectionEquality().hash(_week),healthAccess,isSyncing,failure);
}

@override
String toString() {
    return 'ActivityState(status: $status, today: $today, week: $week, healthAccess: $healthAccess, isSyncing: $isSyncing, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ActivityStateCopyWith<$Res> implements $ActivityStateCopyWith<$Res> {
  factory _$ActivityStateCopyWith(_ActivityState value, $Res Function(_ActivityState) _then) = __$ActivityStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, DailyActivity? today, List<DailyActivity> week, HealthAccessStatus healthAccess, bool isSyncing, Failure? failure
});


@override $DailyActivityCopyWith<$Res>? get today;

}
/// @nodoc
class __$ActivityStateCopyWithImpl<$Res>
    implements _$ActivityStateCopyWith<$Res> {
  __$ActivityStateCopyWithImpl(this._self, this._then);

  final _ActivityState _self;
  final $Res Function(_ActivityState) _then;

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? today = freezed,Object? week = null,Object? healthAccess = null,Object? isSyncing = null,Object? failure = freezed,}) {
  return _then(_ActivityState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DailyActivity?,week: null == week ? _self._week : week // ignore: cast_nullable_to_non_nullable
as List<DailyActivity>,healthAccess: null == healthAccess ? _self.healthAccess : healthAccess // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ActivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyActivityCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $DailyActivityCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

// dart format on
