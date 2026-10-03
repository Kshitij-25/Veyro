// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_library_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseLibraryState {

 ViewStatus get status; List<Exercise> get exercises; String get query; MuscleGroup? get muscleGroup;/// The remote catalogue is being downloaded.
 bool get isSyncing;/// When the remote catalogue was last imported (`null` = never).
 DateTime? get lastSyncedAt;/// Exercises added by the most recent manual sync, until acknowledged.
 int? get lastSyncAdded; Failure? get failure;
/// Create a copy of ExerciseLibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseLibraryStateCopyWith<ExerciseLibraryState> get copyWith => _$ExerciseLibraryStateCopyWithImpl<ExerciseLibraryState>(this as ExerciseLibraryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseLibraryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseLibraryState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.muscleGroup, _this.muscleGroup) || other.muscleGroup == _this.muscleGroup)&&(identical(other.isSyncing, _this.isSyncing) || other.isSyncing == _this.isSyncing)&&(identical(other.lastSyncedAt, _this.lastSyncedAt) || other.lastSyncedAt == _this.lastSyncedAt)&&(identical(other.lastSyncAdded, _this.lastSyncAdded) || other.lastSyncAdded == _this.lastSyncAdded)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ExerciseLibraryState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.exercises),_this.query,_this.muscleGroup,_this.isSyncing,_this.lastSyncedAt,_this.lastSyncAdded,_this.failure);
}

@override
String toString() {
  final _this = this as ExerciseLibraryState;
  return 'ExerciseLibraryState(status: ${_this.status}, exercises: ${_this.exercises}, query: ${_this.query}, muscleGroup: ${_this.muscleGroup}, isSyncing: ${_this.isSyncing}, lastSyncedAt: ${_this.lastSyncedAt}, lastSyncAdded: ${_this.lastSyncAdded}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ExerciseLibraryStateCopyWith<$Res>  {
  factory $ExerciseLibraryStateCopyWith(ExerciseLibraryState value, $Res Function(ExerciseLibraryState) _then) = _$ExerciseLibraryStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<Exercise> exercises, String query, MuscleGroup? muscleGroup, bool isSyncing, DateTime? lastSyncedAt, int? lastSyncAdded, Failure? failure
});




}
/// @nodoc
class _$ExerciseLibraryStateCopyWithImpl<$Res>
    implements $ExerciseLibraryStateCopyWith<$Res> {
  _$ExerciseLibraryStateCopyWithImpl(this._self, this._then);

  final ExerciseLibraryState _self;
  final $Res Function(ExerciseLibraryState) _then;

/// Create a copy of ExerciseLibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? exercises = null,Object? query = null,Object? muscleGroup = freezed,Object? isSyncing = null,Object? lastSyncedAt = freezed,Object? lastSyncAdded = freezed,Object? failure = freezed,}) {
  return _then(ExerciseLibraryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,muscleGroup: freezed == muscleGroup ? _self.muscleGroup : muscleGroup // ignore: cast_nullable_to_non_nullable
as MuscleGroup?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSyncAdded: freezed == lastSyncAdded ? _self.lastSyncAdded : lastSyncAdded // ignore: cast_nullable_to_non_nullable
as int?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseLibraryState].
extension ExerciseLibraryStatePatterns on ExerciseLibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseLibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseLibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseLibraryState value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseLibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseLibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseLibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<Exercise> exercises,  String query,  MuscleGroup? muscleGroup,  bool isSyncing,  DateTime? lastSyncedAt,  int? lastSyncAdded,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseLibraryState() when $default != null:
return $default(_that.status,_that.exercises,_that.query,_that.muscleGroup,_that.isSyncing,_that.lastSyncedAt,_that.lastSyncAdded,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<Exercise> exercises,  String query,  MuscleGroup? muscleGroup,  bool isSyncing,  DateTime? lastSyncedAt,  int? lastSyncAdded,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ExerciseLibraryState():
return $default(_that.status,_that.exercises,_that.query,_that.muscleGroup,_that.isSyncing,_that.lastSyncedAt,_that.lastSyncAdded,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<Exercise> exercises,  String query,  MuscleGroup? muscleGroup,  bool isSyncing,  DateTime? lastSyncedAt,  int? lastSyncAdded,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseLibraryState() when $default != null:
return $default(_that.status,_that.exercises,_that.query,_that.muscleGroup,_that.isSyncing,_that.lastSyncedAt,_that.lastSyncAdded,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseLibraryState extends ExerciseLibraryState {
  const _ExerciseLibraryState({this.status = ViewStatus.initial,  List<Exercise> exercises = const [], this.query = '', this.muscleGroup, this.isSyncing = false, this.lastSyncedAt, this.lastSyncAdded, this.failure}): _exercises = exercises,super._();
  

@override@JsonKey() final  ViewStatus status;
 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  String query;
@override final  MuscleGroup? muscleGroup;
/// The remote catalogue is being downloaded.
@override@JsonKey() final  bool isSyncing;
/// When the remote catalogue was last imported (`null` = never).
@override final  DateTime? lastSyncedAt;
/// Exercises added by the most recent manual sync, until acknowledged.
@override final  int? lastSyncAdded;
@override final  Failure? failure;

/// Create a copy of ExerciseLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseLibraryStateCopyWith<_ExerciseLibraryState> get copyWith => __$ExerciseLibraryStateCopyWithImpl<_ExerciseLibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseLibraryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&(identical(other.query, query) || other.query == query)&&(identical(other.muscleGroup, muscleGroup) || other.muscleGroup == muscleGroup)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.lastSyncAdded, lastSyncAdded) || other.lastSyncAdded == lastSyncAdded)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_exercises),query,muscleGroup,isSyncing,lastSyncedAt,lastSyncAdded,failure);
}

@override
String toString() {
    return 'ExerciseLibraryState(status: $status, exercises: $exercises, query: $query, muscleGroup: $muscleGroup, isSyncing: $isSyncing, lastSyncedAt: $lastSyncedAt, lastSyncAdded: $lastSyncAdded, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ExerciseLibraryStateCopyWith<$Res> implements $ExerciseLibraryStateCopyWith<$Res> {
  factory _$ExerciseLibraryStateCopyWith(_ExerciseLibraryState value, $Res Function(_ExerciseLibraryState) _then) = __$ExerciseLibraryStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<Exercise> exercises, String query, MuscleGroup? muscleGroup, bool isSyncing, DateTime? lastSyncedAt, int? lastSyncAdded, Failure? failure
});




}
/// @nodoc
class __$ExerciseLibraryStateCopyWithImpl<$Res>
    implements _$ExerciseLibraryStateCopyWith<$Res> {
  __$ExerciseLibraryStateCopyWithImpl(this._self, this._then);

  final _ExerciseLibraryState _self;
  final $Res Function(_ExerciseLibraryState) _then;

/// Create a copy of ExerciseLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? exercises = null,Object? query = null,Object? muscleGroup = freezed,Object? isSyncing = null,Object? lastSyncedAt = freezed,Object? lastSyncAdded = freezed,Object? failure = freezed,}) {
  return _then(_ExerciseLibraryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,muscleGroup: freezed == muscleGroup ? _self.muscleGroup : muscleGroup // ignore: cast_nullable_to_non_nullable
as MuscleGroup?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSyncAdded: freezed == lastSyncAdded ? _self.lastSyncAdded : lastSyncAdded // ignore: cast_nullable_to_non_nullable
as int?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
