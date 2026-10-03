// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Workout {

 String get id; String get name; DateTime get startedAt; DateTime? get endedAt; String? get routineId; String? get notes; double? get caloriesBurned; List<WorkoutExercise> get exercises;
/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutCopyWith<Workout> get copyWith => _$WorkoutCopyWithImpl<Workout>(this as Workout, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Workout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Workout&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.routineId, _this.routineId) || other.routineId == _this.routineId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.caloriesBurned, _this.caloriesBurned) || other.caloriesBurned == _this.caloriesBurned)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises));
}


@override
int get hashCode {
  final _this = this as Workout;
  return Object.hash(runtimeType,_this.id,_this.name,_this.startedAt,_this.endedAt,_this.routineId,_this.notes,_this.caloriesBurned,const DeepCollectionEquality().hash(_this.exercises));
}

@override
String toString() {
  final _this = this as Workout;
  return 'Workout(id: ${_this.id}, name: ${_this.name}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, routineId: ${_this.routineId}, notes: ${_this.notes}, caloriesBurned: ${_this.caloriesBurned}, exercises: ${_this.exercises})';
}


}

/// @nodoc
abstract mixin class $WorkoutCopyWith<$Res>  {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) _then) = _$WorkoutCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime startedAt, DateTime? endedAt, String? routineId, String? notes, double? caloriesBurned, List<WorkoutExercise> exercises
});




}
/// @nodoc
class _$WorkoutCopyWithImpl<$Res>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._self, this._then);

  final Workout _self;
  final $Res Function(Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? routineId = freezed,Object? notes = freezed,Object? caloriesBurned = freezed,Object? exercises = null,}) {
  return _then(Workout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routineId: freezed == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,caloriesBurned: freezed == caloriesBurned ? _self.caloriesBurned : caloriesBurned // ignore: cast_nullable_to_non_nullable
as double?,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExercise>,
  ));
}

}


/// Adds pattern-matching-related methods to [Workout].
extension WorkoutPatterns on Workout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workout value)  $default,){
final _that = this;
switch (_that) {
case _Workout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workout value)?  $default,){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime startedAt,  DateTime? endedAt,  String? routineId,  String? notes,  double? caloriesBurned,  List<WorkoutExercise> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.name,_that.startedAt,_that.endedAt,_that.routineId,_that.notes,_that.caloriesBurned,_that.exercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime startedAt,  DateTime? endedAt,  String? routineId,  String? notes,  double? caloriesBurned,  List<WorkoutExercise> exercises)  $default,) {final _that = this;
switch (_that) {
case _Workout():
return $default(_that.id,_that.name,_that.startedAt,_that.endedAt,_that.routineId,_that.notes,_that.caloriesBurned,_that.exercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime startedAt,  DateTime? endedAt,  String? routineId,  String? notes,  double? caloriesBurned,  List<WorkoutExercise> exercises)?  $default,) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.name,_that.startedAt,_that.endedAt,_that.routineId,_that.notes,_that.caloriesBurned,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc


class _Workout extends Workout {
  const _Workout({required this.id, required this.name, required this.startedAt, this.endedAt, this.routineId, this.notes, this.caloriesBurned,  List<WorkoutExercise> exercises = const []}): _exercises = exercises,super._();
  

@override final  String id;
@override final  String name;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  String? routineId;
@override final  String? notes;
@override final  double? caloriesBurned;
 final  List<WorkoutExercise> _exercises;
@override@JsonKey() List<WorkoutExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutCopyWith<_Workout> get copyWith => __$WorkoutCopyWithImpl<_Workout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Workout&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.caloriesBurned, caloriesBurned) || other.caloriesBurned == caloriesBurned)&&const DeepCollectionEquality().equals(other.exercises, _exercises));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,startedAt,endedAt,routineId,notes,caloriesBurned,const DeepCollectionEquality().hash(_exercises));
}

@override
String toString() {
    return 'Workout(id: $id, name: $name, startedAt: $startedAt, endedAt: $endedAt, routineId: $routineId, notes: $notes, caloriesBurned: $caloriesBurned, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$WorkoutCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$WorkoutCopyWith(_Workout value, $Res Function(_Workout) _then) = __$WorkoutCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime startedAt, DateTime? endedAt, String? routineId, String? notes, double? caloriesBurned, List<WorkoutExercise> exercises
});




}
/// @nodoc
class __$WorkoutCopyWithImpl<$Res>
    implements _$WorkoutCopyWith<$Res> {
  __$WorkoutCopyWithImpl(this._self, this._then);

  final _Workout _self;
  final $Res Function(_Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? routineId = freezed,Object? notes = freezed,Object? caloriesBurned = freezed,Object? exercises = null,}) {
  return _then(_Workout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,routineId: freezed == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,caloriesBurned: freezed == caloriesBurned ? _self.caloriesBurned : caloriesBurned // ignore: cast_nullable_to_non_nullable
as double?,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExercise>,
  ));
}


}

// dart format on
