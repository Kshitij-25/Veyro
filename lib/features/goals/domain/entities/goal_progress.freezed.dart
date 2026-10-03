// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalProgress {

 Goal get goal;/// Value for the current day/week, or the current weight.
 double get currentValue;/// `0..1` share of the target reached.
 double get fraction; bool get isAchieved;/// Consecutive days/weeks the goal was met (0 for one-off goals).
 int get currentStreak; int get longestStreak;
/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalProgressCopyWith<GoalProgress> get copyWith => _$GoalProgressCopyWithImpl<GoalProgress>(this as GoalProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalProgress&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.currentValue, _this.currentValue) || other.currentValue == _this.currentValue)&&(identical(other.fraction, _this.fraction) || other.fraction == _this.fraction)&&(identical(other.isAchieved, _this.isAchieved) || other.isAchieved == _this.isAchieved)&&(identical(other.currentStreak, _this.currentStreak) || other.currentStreak == _this.currentStreak)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak));
}


@override
int get hashCode {
  final _this = this as GoalProgress;
  return Object.hash(runtimeType,_this.goal,_this.currentValue,_this.fraction,_this.isAchieved,_this.currentStreak,_this.longestStreak);
}

@override
String toString() {
  final _this = this as GoalProgress;
  return 'GoalProgress(goal: ${_this.goal}, currentValue: ${_this.currentValue}, fraction: ${_this.fraction}, isAchieved: ${_this.isAchieved}, currentStreak: ${_this.currentStreak}, longestStreak: ${_this.longestStreak})';
}


}

/// @nodoc
abstract mixin class $GoalProgressCopyWith<$Res>  {
  factory $GoalProgressCopyWith(GoalProgress value, $Res Function(GoalProgress) _then) = _$GoalProgressCopyWithImpl;
@useResult
$Res call({
 Goal goal, double currentValue, double fraction, bool isAchieved, int currentStreak, int longestStreak
});


$GoalCopyWith<$Res> get goal;

}
/// @nodoc
class _$GoalProgressCopyWithImpl<$Res>
    implements $GoalProgressCopyWith<$Res> {
  _$GoalProgressCopyWithImpl(this._self, this._then);

  final GoalProgress _self;
  final $Res Function(GoalProgress) _then;

/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goal = null,Object? currentValue = null,Object? fraction = null,Object? isAchieved = null,Object? currentStreak = null,Object? longestStreak = null,}) {
  return _then(GoalProgress(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,isAchieved: null == isAchieved ? _self.isAchieved : isAchieved // ignore: cast_nullable_to_non_nullable
as bool,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res> get goal {
  
  return $GoalCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoalProgress].
extension GoalProgressPatterns on GoalProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalProgress value)  $default,){
final _that = this;
switch (_that) {
case _GoalProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalProgress value)?  $default,){
final _that = this;
switch (_that) {
case _GoalProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Goal goal,  double currentValue,  double fraction,  bool isAchieved,  int currentStreak,  int longestStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalProgress() when $default != null:
return $default(_that.goal,_that.currentValue,_that.fraction,_that.isAchieved,_that.currentStreak,_that.longestStreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Goal goal,  double currentValue,  double fraction,  bool isAchieved,  int currentStreak,  int longestStreak)  $default,) {final _that = this;
switch (_that) {
case _GoalProgress():
return $default(_that.goal,_that.currentValue,_that.fraction,_that.isAchieved,_that.currentStreak,_that.longestStreak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Goal goal,  double currentValue,  double fraction,  bool isAchieved,  int currentStreak,  int longestStreak)?  $default,) {final _that = this;
switch (_that) {
case _GoalProgress() when $default != null:
return $default(_that.goal,_that.currentValue,_that.fraction,_that.isAchieved,_that.currentStreak,_that.longestStreak);case _:
  return null;

}
}

}

/// @nodoc


class _GoalProgress implements GoalProgress {
  const _GoalProgress({required this.goal, required this.currentValue, required this.fraction, required this.isAchieved, this.currentStreak = 0, this.longestStreak = 0});
  

@override final  Goal goal;
/// Value for the current day/week, or the current weight.
@override final  double currentValue;
/// `0..1` share of the target reached.
@override final  double fraction;
@override final  bool isAchieved;
/// Consecutive days/weeks the goal was met (0 for one-off goals).
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;

/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalProgressCopyWith<_GoalProgress> get copyWith => __$GoalProgressCopyWithImpl<_GoalProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalProgress&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&(identical(other.isAchieved, isAchieved) || other.isAchieved == isAchieved)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak));
}


@override
int get hashCode {
    return Object.hash(runtimeType,goal,currentValue,fraction,isAchieved,currentStreak,longestStreak);
}

@override
String toString() {
    return 'GoalProgress(goal: $goal, currentValue: $currentValue, fraction: $fraction, isAchieved: $isAchieved, currentStreak: $currentStreak, longestStreak: $longestStreak)';
}


}

/// @nodoc
abstract mixin class _$GoalProgressCopyWith<$Res> implements $GoalProgressCopyWith<$Res> {
  factory _$GoalProgressCopyWith(_GoalProgress value, $Res Function(_GoalProgress) _then) = __$GoalProgressCopyWithImpl;
@override @useResult
$Res call({
 Goal goal, double currentValue, double fraction, bool isAchieved, int currentStreak, int longestStreak
});


@override $GoalCopyWith<$Res> get goal;

}
/// @nodoc
class __$GoalProgressCopyWithImpl<$Res>
    implements _$GoalProgressCopyWith<$Res> {
  __$GoalProgressCopyWithImpl(this._self, this._then);

  final _GoalProgress _self;
  final $Res Function(_GoalProgress) _then;

/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goal = null,Object? currentValue = null,Object? fraction = null,Object? isAchieved = null,Object? currentStreak = null,Object? longestStreak = null,}) {
  return _then(_GoalProgress(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,isAchieved: null == isAchieved ? _self.isAchieved : isAchieved // ignore: cast_nullable_to_non_nullable
as bool,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GoalProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res> get goal {
  
  return $GoalCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}

// dart format on
