// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeightPoint {

 DateTime get date; double get weightKg;
/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightPointCopyWith<WeightPoint> get copyWith => _$WeightPointCopyWithImpl<WeightPoint>(this as WeightPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeightPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg));
}


@override
int get hashCode {
  final _this = this as WeightPoint;
  return Object.hash(runtimeType,_this.date,_this.weightKg);
}

@override
String toString() {
  final _this = this as WeightPoint;
  return 'WeightPoint(date: ${_this.date}, weightKg: ${_this.weightKg})';
}


}

/// @nodoc
abstract mixin class $WeightPointCopyWith<$Res>  {
  factory $WeightPointCopyWith(WeightPoint value, $Res Function(WeightPoint) _then) = _$WeightPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double weightKg
});




}
/// @nodoc
class _$WeightPointCopyWithImpl<$Res>
    implements $WeightPointCopyWith<$Res> {
  _$WeightPointCopyWithImpl(this._self, this._then);

  final WeightPoint _self;
  final $Res Function(WeightPoint) _then;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(WeightPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightPoint].
extension WeightPointPatterns on WeightPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightPoint value)  $default,){
final _that = this;
switch (_that) {
case _WeightPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightPoint value)?  $default,){
final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double weightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
return $default(_that.date,_that.weightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double weightKg)  $default,) {final _that = this;
switch (_that) {
case _WeightPoint():
return $default(_that.date,_that.weightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double weightKg)?  $default,) {final _that = this;
switch (_that) {
case _WeightPoint() when $default != null:
return $default(_that.date,_that.weightKg);case _:
  return null;

}
}

}

/// @nodoc


class _WeightPoint implements WeightPoint {
  const _WeightPoint({required this.date, required this.weightKg});
  

@override final  DateTime date;
@override final  double weightKg;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightPointCopyWith<_WeightPoint> get copyWith => __$WeightPointCopyWithImpl<_WeightPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,weightKg);
}

@override
String toString() {
    return 'WeightPoint(date: $date, weightKg: $weightKg)';
}


}

/// @nodoc
abstract mixin class _$WeightPointCopyWith<$Res> implements $WeightPointCopyWith<$Res> {
  factory _$WeightPointCopyWith(_WeightPoint value, $Res Function(_WeightPoint) _then) = __$WeightPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double weightKg
});




}
/// @nodoc
class __$WeightPointCopyWithImpl<$Res>
    implements _$WeightPointCopyWith<$Res> {
  __$WeightPointCopyWithImpl(this._self, this._then);

  final _WeightPoint _self;
  final $Res Function(_WeightPoint) _then;

/// Create a copy of WeightPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? weightKg = null,}) {
  return _then(_WeightPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$BodyProgress {

/// Oldest first.
 List<WeightPoint> get weightPoints; double? get startWeightKg; double? get currentWeightKg; double? get bmi;
/// Create a copy of BodyProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyProgressCopyWith<BodyProgress> get copyWith => _$BodyProgressCopyWithImpl<BodyProgress>(this as BodyProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BodyProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyProgress&&const DeepCollectionEquality().equals(other.weightPoints, _this.weightPoints)&&(identical(other.startWeightKg, _this.startWeightKg) || other.startWeightKg == _this.startWeightKg)&&(identical(other.currentWeightKg, _this.currentWeightKg) || other.currentWeightKg == _this.currentWeightKg)&&(identical(other.bmi, _this.bmi) || other.bmi == _this.bmi));
}


@override
int get hashCode {
  final _this = this as BodyProgress;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.weightPoints),_this.startWeightKg,_this.currentWeightKg,_this.bmi);
}

@override
String toString() {
  final _this = this as BodyProgress;
  return 'BodyProgress(weightPoints: ${_this.weightPoints}, startWeightKg: ${_this.startWeightKg}, currentWeightKg: ${_this.currentWeightKg}, bmi: ${_this.bmi})';
}


}

/// @nodoc
abstract mixin class $BodyProgressCopyWith<$Res>  {
  factory $BodyProgressCopyWith(BodyProgress value, $Res Function(BodyProgress) _then) = _$BodyProgressCopyWithImpl;
@useResult
$Res call({
 List<WeightPoint> weightPoints, double? startWeightKg, double? currentWeightKg, double? bmi
});




}
/// @nodoc
class _$BodyProgressCopyWithImpl<$Res>
    implements $BodyProgressCopyWith<$Res> {
  _$BodyProgressCopyWithImpl(this._self, this._then);

  final BodyProgress _self;
  final $Res Function(BodyProgress) _then;

/// Create a copy of BodyProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weightPoints = null,Object? startWeightKg = freezed,Object? currentWeightKg = freezed,Object? bmi = freezed,}) {
  return _then(BodyProgress(
weightPoints: null == weightPoints ? _self.weightPoints : weightPoints // ignore: cast_nullable_to_non_nullable
as List<WeightPoint>,startWeightKg: freezed == startWeightKg ? _self.startWeightKg : startWeightKg // ignore: cast_nullable_to_non_nullable
as double?,currentWeightKg: freezed == currentWeightKg ? _self.currentWeightKg : currentWeightKg // ignore: cast_nullable_to_non_nullable
as double?,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyProgress].
extension BodyProgressPatterns on BodyProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyProgress value)  $default,){
final _that = this;
switch (_that) {
case _BodyProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyProgress value)?  $default,){
final _that = this;
switch (_that) {
case _BodyProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WeightPoint> weightPoints,  double? startWeightKg,  double? currentWeightKg,  double? bmi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyProgress() when $default != null:
return $default(_that.weightPoints,_that.startWeightKg,_that.currentWeightKg,_that.bmi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WeightPoint> weightPoints,  double? startWeightKg,  double? currentWeightKg,  double? bmi)  $default,) {final _that = this;
switch (_that) {
case _BodyProgress():
return $default(_that.weightPoints,_that.startWeightKg,_that.currentWeightKg,_that.bmi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WeightPoint> weightPoints,  double? startWeightKg,  double? currentWeightKg,  double? bmi)?  $default,) {final _that = this;
switch (_that) {
case _BodyProgress() when $default != null:
return $default(_that.weightPoints,_that.startWeightKg,_that.currentWeightKg,_that.bmi);case _:
  return null;

}
}

}

/// @nodoc


class _BodyProgress extends BodyProgress {
  const _BodyProgress({ List<WeightPoint> weightPoints = const [], this.startWeightKg, this.currentWeightKg, this.bmi}): _weightPoints = weightPoints,super._();
  

/// Oldest first.
 final  List<WeightPoint> _weightPoints;
/// Oldest first.
@override@JsonKey() List<WeightPoint> get weightPoints {
  if (_weightPoints is EqualUnmodifiableListView) return _weightPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weightPoints);
}

@override final  double? startWeightKg;
@override final  double? currentWeightKg;
@override final  double? bmi;

/// Create a copy of BodyProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyProgressCopyWith<_BodyProgress> get copyWith => __$BodyProgressCopyWithImpl<_BodyProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyProgress&&const DeepCollectionEquality().equals(other.weightPoints, _weightPoints)&&(identical(other.startWeightKg, startWeightKg) || other.startWeightKg == startWeightKg)&&(identical(other.currentWeightKg, currentWeightKg) || other.currentWeightKg == currentWeightKg)&&(identical(other.bmi, bmi) || other.bmi == bmi));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_weightPoints),startWeightKg,currentWeightKg,bmi);
}

@override
String toString() {
    return 'BodyProgress(weightPoints: $weightPoints, startWeightKg: $startWeightKg, currentWeightKg: $currentWeightKg, bmi: $bmi)';
}


}

/// @nodoc
abstract mixin class _$BodyProgressCopyWith<$Res> implements $BodyProgressCopyWith<$Res> {
  factory _$BodyProgressCopyWith(_BodyProgress value, $Res Function(_BodyProgress) _then) = __$BodyProgressCopyWithImpl;
@override @useResult
$Res call({
 List<WeightPoint> weightPoints, double? startWeightKg, double? currentWeightKg, double? bmi
});




}
/// @nodoc
class __$BodyProgressCopyWithImpl<$Res>
    implements _$BodyProgressCopyWith<$Res> {
  __$BodyProgressCopyWithImpl(this._self, this._then);

  final _BodyProgress _self;
  final $Res Function(_BodyProgress) _then;

/// Create a copy of BodyProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weightPoints = null,Object? startWeightKg = freezed,Object? currentWeightKg = freezed,Object? bmi = freezed,}) {
  return _then(_BodyProgress(
weightPoints: null == weightPoints ? _self._weightPoints : weightPoints // ignore: cast_nullable_to_non_nullable
as List<WeightPoint>,startWeightKg: freezed == startWeightKg ? _self.startWeightKg : startWeightKg // ignore: cast_nullable_to_non_nullable
as double?,currentWeightKg: freezed == currentWeightKg ? _self.currentWeightKg : currentWeightKg // ignore: cast_nullable_to_non_nullable
as double?,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
