// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BodyMeasurement {

 String get id; DateTime get measuredAt; double? get weightKg; double? get bodyFatPercent; double? get waistCm; double? get chestCm; double? get hipsCm; double? get armCm; double? get thighCm; String? get notes;
/// Create a copy of BodyMeasurement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyMeasurementCopyWith<BodyMeasurement> get copyWith => _$BodyMeasurementCopyWithImpl<BodyMeasurement>(this as BodyMeasurement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BodyMeasurement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyMeasurement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.measuredAt, _this.measuredAt) || other.measuredAt == _this.measuredAt)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.bodyFatPercent, _this.bodyFatPercent) || other.bodyFatPercent == _this.bodyFatPercent)&&(identical(other.waistCm, _this.waistCm) || other.waistCm == _this.waistCm)&&(identical(other.chestCm, _this.chestCm) || other.chestCm == _this.chestCm)&&(identical(other.hipsCm, _this.hipsCm) || other.hipsCm == _this.hipsCm)&&(identical(other.armCm, _this.armCm) || other.armCm == _this.armCm)&&(identical(other.thighCm, _this.thighCm) || other.thighCm == _this.thighCm)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as BodyMeasurement;
  return Object.hash(runtimeType,_this.id,_this.measuredAt,_this.weightKg,_this.bodyFatPercent,_this.waistCm,_this.chestCm,_this.hipsCm,_this.armCm,_this.thighCm,_this.notes);
}

@override
String toString() {
  final _this = this as BodyMeasurement;
  return 'BodyMeasurement(id: ${_this.id}, measuredAt: ${_this.measuredAt}, weightKg: ${_this.weightKg}, bodyFatPercent: ${_this.bodyFatPercent}, waistCm: ${_this.waistCm}, chestCm: ${_this.chestCm}, hipsCm: ${_this.hipsCm}, armCm: ${_this.armCm}, thighCm: ${_this.thighCm}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $BodyMeasurementCopyWith<$Res>  {
  factory $BodyMeasurementCopyWith(BodyMeasurement value, $Res Function(BodyMeasurement) _then) = _$BodyMeasurementCopyWithImpl;
@useResult
$Res call({
 String id, DateTime measuredAt, double? weightKg, double? bodyFatPercent, double? waistCm, double? chestCm, double? hipsCm, double? armCm, double? thighCm, String? notes
});




}
/// @nodoc
class _$BodyMeasurementCopyWithImpl<$Res>
    implements $BodyMeasurementCopyWith<$Res> {
  _$BodyMeasurementCopyWithImpl(this._self, this._then);

  final BodyMeasurement _self;
  final $Res Function(BodyMeasurement) _then;

/// Create a copy of BodyMeasurement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? measuredAt = null,Object? weightKg = freezed,Object? bodyFatPercent = freezed,Object? waistCm = freezed,Object? chestCm = freezed,Object? hipsCm = freezed,Object? armCm = freezed,Object? thighCm = freezed,Object? notes = freezed,}) {
  return _then(BodyMeasurement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,bodyFatPercent: freezed == bodyFatPercent ? _self.bodyFatPercent : bodyFatPercent // ignore: cast_nullable_to_non_nullable
as double?,waistCm: freezed == waistCm ? _self.waistCm : waistCm // ignore: cast_nullable_to_non_nullable
as double?,chestCm: freezed == chestCm ? _self.chestCm : chestCm // ignore: cast_nullable_to_non_nullable
as double?,hipsCm: freezed == hipsCm ? _self.hipsCm : hipsCm // ignore: cast_nullable_to_non_nullable
as double?,armCm: freezed == armCm ? _self.armCm : armCm // ignore: cast_nullable_to_non_nullable
as double?,thighCm: freezed == thighCm ? _self.thighCm : thighCm // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyMeasurement].
extension BodyMeasurementPatterns on BodyMeasurement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyMeasurement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyMeasurement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyMeasurement value)  $default,){
final _that = this;
switch (_that) {
case _BodyMeasurement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyMeasurement value)?  $default,){
final _that = this;
switch (_that) {
case _BodyMeasurement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyMeasurement() when $default != null:
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _BodyMeasurement():
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _BodyMeasurement() when $default != null:
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _BodyMeasurement extends BodyMeasurement {
  const _BodyMeasurement({required this.id, required this.measuredAt, this.weightKg, this.bodyFatPercent, this.waistCm, this.chestCm, this.hipsCm, this.armCm, this.thighCm, this.notes}): super._();
  

@override final  String id;
@override final  DateTime measuredAt;
@override final  double? weightKg;
@override final  double? bodyFatPercent;
@override final  double? waistCm;
@override final  double? chestCm;
@override final  double? hipsCm;
@override final  double? armCm;
@override final  double? thighCm;
@override final  String? notes;

/// Create a copy of BodyMeasurement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyMeasurementCopyWith<_BodyMeasurement> get copyWith => __$BodyMeasurementCopyWithImpl<_BodyMeasurement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyMeasurement&&(identical(other.id, id) || other.id == id)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.bodyFatPercent, bodyFatPercent) || other.bodyFatPercent == bodyFatPercent)&&(identical(other.waistCm, waistCm) || other.waistCm == waistCm)&&(identical(other.chestCm, chestCm) || other.chestCm == chestCm)&&(identical(other.hipsCm, hipsCm) || other.hipsCm == hipsCm)&&(identical(other.armCm, armCm) || other.armCm == armCm)&&(identical(other.thighCm, thighCm) || other.thighCm == thighCm)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,measuredAt,weightKg,bodyFatPercent,waistCm,chestCm,hipsCm,armCm,thighCm,notes);
}

@override
String toString() {
    return 'BodyMeasurement(id: $id, measuredAt: $measuredAt, weightKg: $weightKg, bodyFatPercent: $bodyFatPercent, waistCm: $waistCm, chestCm: $chestCm, hipsCm: $hipsCm, armCm: $armCm, thighCm: $thighCm, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$BodyMeasurementCopyWith<$Res> implements $BodyMeasurementCopyWith<$Res> {
  factory _$BodyMeasurementCopyWith(_BodyMeasurement value, $Res Function(_BodyMeasurement) _then) = __$BodyMeasurementCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime measuredAt, double? weightKg, double? bodyFatPercent, double? waistCm, double? chestCm, double? hipsCm, double? armCm, double? thighCm, String? notes
});




}
/// @nodoc
class __$BodyMeasurementCopyWithImpl<$Res>
    implements _$BodyMeasurementCopyWith<$Res> {
  __$BodyMeasurementCopyWithImpl(this._self, this._then);

  final _BodyMeasurement _self;
  final $Res Function(_BodyMeasurement) _then;

/// Create a copy of BodyMeasurement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? measuredAt = null,Object? weightKg = freezed,Object? bodyFatPercent = freezed,Object? waistCm = freezed,Object? chestCm = freezed,Object? hipsCm = freezed,Object? armCm = freezed,Object? thighCm = freezed,Object? notes = freezed,}) {
  return _then(_BodyMeasurement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,bodyFatPercent: freezed == bodyFatPercent ? _self.bodyFatPercent : bodyFatPercent // ignore: cast_nullable_to_non_nullable
as double?,waistCm: freezed == waistCm ? _self.waistCm : waistCm // ignore: cast_nullable_to_non_nullable
as double?,chestCm: freezed == chestCm ? _self.chestCm : chestCm // ignore: cast_nullable_to_non_nullable
as double?,hipsCm: freezed == hipsCm ? _self.hipsCm : hipsCm // ignore: cast_nullable_to_non_nullable
as double?,armCm: freezed == armCm ? _self.armCm : armCm // ignore: cast_nullable_to_non_nullable
as double?,thighCm: freezed == thighCm ? _self.thighCm : thighCm // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
