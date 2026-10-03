// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyActivity {

/// Start of the day (local time).
 DateTime get date; int get steps; double get distanceMeters; double get activeCaloriesKcal; ActivitySource get source;
/// Create a copy of DailyActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyActivityCopyWith<DailyActivity> get copyWith => _$DailyActivityCopyWithImpl<DailyActivity>(this as DailyActivity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyActivity&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.steps, _this.steps) || other.steps == _this.steps)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.activeCaloriesKcal, _this.activeCaloriesKcal) || other.activeCaloriesKcal == _this.activeCaloriesKcal)&&(identical(other.source, _this.source) || other.source == _this.source));
}


@override
int get hashCode {
  final _this = this as DailyActivity;
  return Object.hash(runtimeType,_this.date,_this.steps,_this.distanceMeters,_this.activeCaloriesKcal,_this.source);
}

@override
String toString() {
  final _this = this as DailyActivity;
  return 'DailyActivity(date: ${_this.date}, steps: ${_this.steps}, distanceMeters: ${_this.distanceMeters}, activeCaloriesKcal: ${_this.activeCaloriesKcal}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $DailyActivityCopyWith<$Res>  {
  factory $DailyActivityCopyWith(DailyActivity value, $Res Function(DailyActivity) _then) = _$DailyActivityCopyWithImpl;
@useResult
$Res call({
 DateTime date, int steps, double distanceMeters, double activeCaloriesKcal, ActivitySource source
});




}
/// @nodoc
class _$DailyActivityCopyWithImpl<$Res>
    implements $DailyActivityCopyWith<$Res> {
  _$DailyActivityCopyWithImpl(this._self, this._then);

  final DailyActivity _self;
  final $Res Function(DailyActivity) _then;

/// Create a copy of DailyActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? steps = null,Object? distanceMeters = null,Object? activeCaloriesKcal = null,Object? source = null,}) {
  return _then(DailyActivity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,activeCaloriesKcal: null == activeCaloriesKcal ? _self.activeCaloriesKcal : activeCaloriesKcal // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ActivitySource,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyActivity].
extension DailyActivityPatterns on DailyActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyActivity value)  $default,){
final _that = this;
switch (_that) {
case _DailyActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyActivity value)?  $default,){
final _that = this;
switch (_that) {
case _DailyActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int steps,  double distanceMeters,  double activeCaloriesKcal,  ActivitySource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyActivity() when $default != null:
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCaloriesKcal,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int steps,  double distanceMeters,  double activeCaloriesKcal,  ActivitySource source)  $default,) {final _that = this;
switch (_that) {
case _DailyActivity():
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCaloriesKcal,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int steps,  double distanceMeters,  double activeCaloriesKcal,  ActivitySource source)?  $default,) {final _that = this;
switch (_that) {
case _DailyActivity() when $default != null:
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCaloriesKcal,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _DailyActivity implements DailyActivity {
  const _DailyActivity({required this.date, this.steps = 0, this.distanceMeters = 0, this.activeCaloriesKcal = 0, this.source = ActivitySource.manual});
  

/// Start of the day (local time).
@override final  DateTime date;
@override@JsonKey() final  int steps;
@override@JsonKey() final  double distanceMeters;
@override@JsonKey() final  double activeCaloriesKcal;
@override@JsonKey() final  ActivitySource source;

/// Create a copy of DailyActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyActivityCopyWith<_DailyActivity> get copyWith => __$DailyActivityCopyWithImpl<_DailyActivity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyActivity&&(identical(other.date, date) || other.date == date)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activeCaloriesKcal, activeCaloriesKcal) || other.activeCaloriesKcal == activeCaloriesKcal)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,steps,distanceMeters,activeCaloriesKcal,source);
}

@override
String toString() {
    return 'DailyActivity(date: $date, steps: $steps, distanceMeters: $distanceMeters, activeCaloriesKcal: $activeCaloriesKcal, source: $source)';
}


}

/// @nodoc
abstract mixin class _$DailyActivityCopyWith<$Res> implements $DailyActivityCopyWith<$Res> {
  factory _$DailyActivityCopyWith(_DailyActivity value, $Res Function(_DailyActivity) _then) = __$DailyActivityCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int steps, double distanceMeters, double activeCaloriesKcal, ActivitySource source
});




}
/// @nodoc
class __$DailyActivityCopyWithImpl<$Res>
    implements _$DailyActivityCopyWith<$Res> {
  __$DailyActivityCopyWithImpl(this._self, this._then);

  final _DailyActivity _self;
  final $Res Function(_DailyActivity) _then;

/// Create a copy of DailyActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? steps = null,Object? distanceMeters = null,Object? activeCaloriesKcal = null,Object? source = null,}) {
  return _then(_DailyActivity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,activeCaloriesKcal: null == activeCaloriesKcal ? _self.activeCaloriesKcal : activeCaloriesKcal // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ActivitySource,
  ));
}


}

// dart format on
