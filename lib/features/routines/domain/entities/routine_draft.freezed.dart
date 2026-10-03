// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoutineDraft {

 String? get id; String get name; String? get notes; List<RoutineExerciseDraft> get exercises; Set<int> get scheduledWeekdays;
/// Create a copy of RoutineDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineDraftCopyWith<RoutineDraft> get copyWith => _$RoutineDraftCopyWithImpl<RoutineDraft>(this as RoutineDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoutineDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineDraft&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&const DeepCollectionEquality().equals(other.scheduledWeekdays, _this.scheduledWeekdays));
}


@override
int get hashCode {
  final _this = this as RoutineDraft;
  return Object.hash(runtimeType,_this.id,_this.name,_this.notes,const DeepCollectionEquality().hash(_this.exercises),const DeepCollectionEquality().hash(_this.scheduledWeekdays));
}

@override
String toString() {
  final _this = this as RoutineDraft;
  return 'RoutineDraft(id: ${_this.id}, name: ${_this.name}, notes: ${_this.notes}, exercises: ${_this.exercises}, scheduledWeekdays: ${_this.scheduledWeekdays})';
}


}

/// @nodoc
abstract mixin class $RoutineDraftCopyWith<$Res>  {
  factory $RoutineDraftCopyWith(RoutineDraft value, $Res Function(RoutineDraft) _then) = _$RoutineDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? notes, List<RoutineExerciseDraft> exercises, Set<int> scheduledWeekdays
});




}
/// @nodoc
class _$RoutineDraftCopyWithImpl<$Res>
    implements $RoutineDraftCopyWith<$Res> {
  _$RoutineDraftCopyWithImpl(this._self, this._then);

  final RoutineDraft _self;
  final $Res Function(RoutineDraft) _then;

/// Create a copy of RoutineDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? notes = freezed,Object? exercises = null,Object? scheduledWeekdays = null,}) {
  return _then(RoutineDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<RoutineExerciseDraft>,scheduledWeekdays: null == scheduledWeekdays ? _self.scheduledWeekdays : scheduledWeekdays // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineDraft].
extension RoutineDraftPatterns on RoutineDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineDraft value)  $default,){
final _that = this;
switch (_that) {
case _RoutineDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? notes,  List<RoutineExerciseDraft> exercises,  Set<int> scheduledWeekdays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineDraft() when $default != null:
return $default(_that.id,_that.name,_that.notes,_that.exercises,_that.scheduledWeekdays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? notes,  List<RoutineExerciseDraft> exercises,  Set<int> scheduledWeekdays)  $default,) {final _that = this;
switch (_that) {
case _RoutineDraft():
return $default(_that.id,_that.name,_that.notes,_that.exercises,_that.scheduledWeekdays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? notes,  List<RoutineExerciseDraft> exercises,  Set<int> scheduledWeekdays)?  $default,) {final _that = this;
switch (_that) {
case _RoutineDraft() when $default != null:
return $default(_that.id,_that.name,_that.notes,_that.exercises,_that.scheduledWeekdays);case _:
  return null;

}
}

}

/// @nodoc


class _RoutineDraft implements RoutineDraft {
  const _RoutineDraft({this.id, this.name = '', this.notes,  List<RoutineExerciseDraft> exercises = const [],  Set<int> scheduledWeekdays = const {}}): _exercises = exercises,_scheduledWeekdays = scheduledWeekdays;
  

@override final  String? id;
@override@JsonKey() final  String name;
@override final  String? notes;
 final  List<RoutineExerciseDraft> _exercises;
@override@JsonKey() List<RoutineExerciseDraft> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

 final  Set<int> _scheduledWeekdays;
@override@JsonKey() Set<int> get scheduledWeekdays {
  if (_scheduledWeekdays is EqualUnmodifiableSetView) return _scheduledWeekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_scheduledWeekdays);
}


/// Create a copy of RoutineDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineDraftCopyWith<_RoutineDraft> get copyWith => __$RoutineDraftCopyWithImpl<_RoutineDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&const DeepCollectionEquality().equals(other.scheduledWeekdays, _scheduledWeekdays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,notes,const DeepCollectionEquality().hash(_exercises),const DeepCollectionEquality().hash(_scheduledWeekdays));
}

@override
String toString() {
    return 'RoutineDraft(id: $id, name: $name, notes: $notes, exercises: $exercises, scheduledWeekdays: $scheduledWeekdays)';
}


}

/// @nodoc
abstract mixin class _$RoutineDraftCopyWith<$Res> implements $RoutineDraftCopyWith<$Res> {
  factory _$RoutineDraftCopyWith(_RoutineDraft value, $Res Function(_RoutineDraft) _then) = __$RoutineDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? notes, List<RoutineExerciseDraft> exercises, Set<int> scheduledWeekdays
});




}
/// @nodoc
class __$RoutineDraftCopyWithImpl<$Res>
    implements _$RoutineDraftCopyWith<$Res> {
  __$RoutineDraftCopyWithImpl(this._self, this._then);

  final _RoutineDraft _self;
  final $Res Function(_RoutineDraft) _then;

/// Create a copy of RoutineDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? notes = freezed,Object? exercises = null,Object? scheduledWeekdays = null,}) {
  return _then(_RoutineDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<RoutineExerciseDraft>,scheduledWeekdays: null == scheduledWeekdays ? _self._scheduledWeekdays : scheduledWeekdays // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

/// @nodoc
mixin _$RoutineExerciseDraft {

 Exercise get exercise; int get targetSets; int get targetReps; double? get targetWeightKg; int get restSeconds;
/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineExerciseDraftCopyWith<RoutineExerciseDraft> get copyWith => _$RoutineExerciseDraftCopyWithImpl<RoutineExerciseDraft>(this as RoutineExerciseDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoutineExerciseDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineExerciseDraft&&(identical(other.exercise, _this.exercise) || other.exercise == _this.exercise)&&(identical(other.targetSets, _this.targetSets) || other.targetSets == _this.targetSets)&&(identical(other.targetReps, _this.targetReps) || other.targetReps == _this.targetReps)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.restSeconds, _this.restSeconds) || other.restSeconds == _this.restSeconds));
}


@override
int get hashCode {
  final _this = this as RoutineExerciseDraft;
  return Object.hash(runtimeType,_this.exercise,_this.targetSets,_this.targetReps,_this.targetWeightKg,_this.restSeconds);
}

@override
String toString() {
  final _this = this as RoutineExerciseDraft;
  return 'RoutineExerciseDraft(exercise: ${_this.exercise}, targetSets: ${_this.targetSets}, targetReps: ${_this.targetReps}, targetWeightKg: ${_this.targetWeightKg}, restSeconds: ${_this.restSeconds})';
}


}

/// @nodoc
abstract mixin class $RoutineExerciseDraftCopyWith<$Res>  {
  factory $RoutineExerciseDraftCopyWith(RoutineExerciseDraft value, $Res Function(RoutineExerciseDraft) _then) = _$RoutineExerciseDraftCopyWithImpl;
@useResult
$Res call({
 Exercise exercise, int targetSets, int targetReps, double? targetWeightKg, int restSeconds
});


$ExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class _$RoutineExerciseDraftCopyWithImpl<$Res>
    implements $RoutineExerciseDraftCopyWith<$Res> {
  _$RoutineExerciseDraftCopyWithImpl(this._self, this._then);

  final RoutineExerciseDraft _self;
  final $Res Function(RoutineExerciseDraft) _then;

/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exercise = null,Object? targetSets = null,Object? targetReps = null,Object? targetWeightKg = freezed,Object? restSeconds = null,}) {
  return _then(RoutineExerciseDraft(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as Exercise,targetSets: null == targetSets ? _self.targetSets : targetSets // ignore: cast_nullable_to_non_nullable
as int,targetReps: null == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: null == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseCopyWith<$Res> get exercise {
  
  return $ExerciseCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoutineExerciseDraft].
extension RoutineExerciseDraftPatterns on RoutineExerciseDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineExerciseDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineExerciseDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineExerciseDraft value)  $default,){
final _that = this;
switch (_that) {
case _RoutineExerciseDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineExerciseDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineExerciseDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Exercise exercise,  int targetSets,  int targetReps,  double? targetWeightKg,  int restSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineExerciseDraft() when $default != null:
return $default(_that.exercise,_that.targetSets,_that.targetReps,_that.targetWeightKg,_that.restSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Exercise exercise,  int targetSets,  int targetReps,  double? targetWeightKg,  int restSeconds)  $default,) {final _that = this;
switch (_that) {
case _RoutineExerciseDraft():
return $default(_that.exercise,_that.targetSets,_that.targetReps,_that.targetWeightKg,_that.restSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Exercise exercise,  int targetSets,  int targetReps,  double? targetWeightKg,  int restSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RoutineExerciseDraft() when $default != null:
return $default(_that.exercise,_that.targetSets,_that.targetReps,_that.targetWeightKg,_that.restSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _RoutineExerciseDraft implements RoutineExerciseDraft {
  const _RoutineExerciseDraft({required this.exercise, this.targetSets = 3, this.targetReps = 10, this.targetWeightKg, this.restSeconds = 90});
  

@override final  Exercise exercise;
@override@JsonKey() final  int targetSets;
@override@JsonKey() final  int targetReps;
@override final  double? targetWeightKg;
@override@JsonKey() final  int restSeconds;

/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineExerciseDraftCopyWith<_RoutineExerciseDraft> get copyWith => __$RoutineExerciseDraftCopyWithImpl<_RoutineExerciseDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineExerciseDraft&&(identical(other.exercise, exercise) || other.exercise == exercise)&&(identical(other.targetSets, targetSets) || other.targetSets == targetSets)&&(identical(other.targetReps, targetReps) || other.targetReps == targetReps)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.restSeconds, restSeconds) || other.restSeconds == restSeconds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exercise,targetSets,targetReps,targetWeightKg,restSeconds);
}

@override
String toString() {
    return 'RoutineExerciseDraft(exercise: $exercise, targetSets: $targetSets, targetReps: $targetReps, targetWeightKg: $targetWeightKg, restSeconds: $restSeconds)';
}


}

/// @nodoc
abstract mixin class _$RoutineExerciseDraftCopyWith<$Res> implements $RoutineExerciseDraftCopyWith<$Res> {
  factory _$RoutineExerciseDraftCopyWith(_RoutineExerciseDraft value, $Res Function(_RoutineExerciseDraft) _then) = __$RoutineExerciseDraftCopyWithImpl;
@override @useResult
$Res call({
 Exercise exercise, int targetSets, int targetReps, double? targetWeightKg, int restSeconds
});


@override $ExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class __$RoutineExerciseDraftCopyWithImpl<$Res>
    implements _$RoutineExerciseDraftCopyWith<$Res> {
  __$RoutineExerciseDraftCopyWithImpl(this._self, this._then);

  final _RoutineExerciseDraft _self;
  final $Res Function(_RoutineExerciseDraft) _then;

/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exercise = null,Object? targetSets = null,Object? targetReps = null,Object? targetWeightKg = freezed,Object? restSeconds = null,}) {
  return _then(_RoutineExerciseDraft(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as Exercise,targetSets: null == targetSets ? _self.targetSets : targetSets // ignore: cast_nullable_to_non_nullable
as int,targetReps: null == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: null == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RoutineExerciseDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseCopyWith<$Res> get exercise {
  
  return $ExerciseCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}

// dart format on
