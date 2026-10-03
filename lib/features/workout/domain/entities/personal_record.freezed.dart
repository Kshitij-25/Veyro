// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalRecord {

 Exercise get exercise; double get maxWeightKg; int get maxReps; double get estimatedOneRepMaxKg; DateTime get achievedAt;
/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalRecordCopyWith<PersonalRecord> get copyWith => _$PersonalRecordCopyWithImpl<PersonalRecord>(this as PersonalRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PersonalRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalRecord&&(identical(other.exercise, _this.exercise) || other.exercise == _this.exercise)&&(identical(other.maxWeightKg, _this.maxWeightKg) || other.maxWeightKg == _this.maxWeightKg)&&(identical(other.maxReps, _this.maxReps) || other.maxReps == _this.maxReps)&&(identical(other.estimatedOneRepMaxKg, _this.estimatedOneRepMaxKg) || other.estimatedOneRepMaxKg == _this.estimatedOneRepMaxKg)&&(identical(other.achievedAt, _this.achievedAt) || other.achievedAt == _this.achievedAt));
}


@override
int get hashCode {
  final _this = this as PersonalRecord;
  return Object.hash(runtimeType,_this.exercise,_this.maxWeightKg,_this.maxReps,_this.estimatedOneRepMaxKg,_this.achievedAt);
}

@override
String toString() {
  final _this = this as PersonalRecord;
  return 'PersonalRecord(exercise: ${_this.exercise}, maxWeightKg: ${_this.maxWeightKg}, maxReps: ${_this.maxReps}, estimatedOneRepMaxKg: ${_this.estimatedOneRepMaxKg}, achievedAt: ${_this.achievedAt})';
}


}

/// @nodoc
abstract mixin class $PersonalRecordCopyWith<$Res>  {
  factory $PersonalRecordCopyWith(PersonalRecord value, $Res Function(PersonalRecord) _then) = _$PersonalRecordCopyWithImpl;
@useResult
$Res call({
 Exercise exercise, double maxWeightKg, int maxReps, double estimatedOneRepMaxKg, DateTime achievedAt
});


$ExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class _$PersonalRecordCopyWithImpl<$Res>
    implements $PersonalRecordCopyWith<$Res> {
  _$PersonalRecordCopyWithImpl(this._self, this._then);

  final PersonalRecord _self;
  final $Res Function(PersonalRecord) _then;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exercise = null,Object? maxWeightKg = null,Object? maxReps = null,Object? estimatedOneRepMaxKg = null,Object? achievedAt = null,}) {
  return _then(PersonalRecord(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as Exercise,maxWeightKg: null == maxWeightKg ? _self.maxWeightKg : maxWeightKg // ignore: cast_nullable_to_non_nullable
as double,maxReps: null == maxReps ? _self.maxReps : maxReps // ignore: cast_nullable_to_non_nullable
as int,estimatedOneRepMaxKg: null == estimatedOneRepMaxKg ? _self.estimatedOneRepMaxKg : estimatedOneRepMaxKg // ignore: cast_nullable_to_non_nullable
as double,achievedAt: null == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseCopyWith<$Res> get exercise {
  
  return $ExerciseCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonalRecord].
extension PersonalRecordPatterns on PersonalRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalRecord value)  $default,){
final _that = this;
switch (_that) {
case _PersonalRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Exercise exercise,  double maxWeightKg,  int maxReps,  double estimatedOneRepMaxKg,  DateTime achievedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
return $default(_that.exercise,_that.maxWeightKg,_that.maxReps,_that.estimatedOneRepMaxKg,_that.achievedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Exercise exercise,  double maxWeightKg,  int maxReps,  double estimatedOneRepMaxKg,  DateTime achievedAt)  $default,) {final _that = this;
switch (_that) {
case _PersonalRecord():
return $default(_that.exercise,_that.maxWeightKg,_that.maxReps,_that.estimatedOneRepMaxKg,_that.achievedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Exercise exercise,  double maxWeightKg,  int maxReps,  double estimatedOneRepMaxKg,  DateTime achievedAt)?  $default,) {final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
return $default(_that.exercise,_that.maxWeightKg,_that.maxReps,_that.estimatedOneRepMaxKg,_that.achievedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalRecord implements PersonalRecord {
  const _PersonalRecord({required this.exercise, required this.maxWeightKg, required this.maxReps, required this.estimatedOneRepMaxKg, required this.achievedAt});
  

@override final  Exercise exercise;
@override final  double maxWeightKg;
@override final  int maxReps;
@override final  double estimatedOneRepMaxKg;
@override final  DateTime achievedAt;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalRecordCopyWith<_PersonalRecord> get copyWith => __$PersonalRecordCopyWithImpl<_PersonalRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalRecord&&(identical(other.exercise, exercise) || other.exercise == exercise)&&(identical(other.maxWeightKg, maxWeightKg) || other.maxWeightKg == maxWeightKg)&&(identical(other.maxReps, maxReps) || other.maxReps == maxReps)&&(identical(other.estimatedOneRepMaxKg, estimatedOneRepMaxKg) || other.estimatedOneRepMaxKg == estimatedOneRepMaxKg)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exercise,maxWeightKg,maxReps,estimatedOneRepMaxKg,achievedAt);
}

@override
String toString() {
    return 'PersonalRecord(exercise: $exercise, maxWeightKg: $maxWeightKg, maxReps: $maxReps, estimatedOneRepMaxKg: $estimatedOneRepMaxKg, achievedAt: $achievedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonalRecordCopyWith<$Res> implements $PersonalRecordCopyWith<$Res> {
  factory _$PersonalRecordCopyWith(_PersonalRecord value, $Res Function(_PersonalRecord) _then) = __$PersonalRecordCopyWithImpl;
@override @useResult
$Res call({
 Exercise exercise, double maxWeightKg, int maxReps, double estimatedOneRepMaxKg, DateTime achievedAt
});


@override $ExerciseCopyWith<$Res> get exercise;

}
/// @nodoc
class __$PersonalRecordCopyWithImpl<$Res>
    implements _$PersonalRecordCopyWith<$Res> {
  __$PersonalRecordCopyWithImpl(this._self, this._then);

  final _PersonalRecord _self;
  final $Res Function(_PersonalRecord) _then;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exercise = null,Object? maxWeightKg = null,Object? maxReps = null,Object? estimatedOneRepMaxKg = null,Object? achievedAt = null,}) {
  return _then(_PersonalRecord(
exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as Exercise,maxWeightKg: null == maxWeightKg ? _self.maxWeightKg : maxWeightKg // ignore: cast_nullable_to_non_nullable
as double,maxReps: null == maxReps ? _self.maxReps : maxReps // ignore: cast_nullable_to_non_nullable
as int,estimatedOneRepMaxKg: null == estimatedOneRepMaxKg ? _self.estimatedOneRepMaxKg : estimatedOneRepMaxKg // ignore: cast_nullable_to_non_nullable
as double,achievedAt: null == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PersonalRecord
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
