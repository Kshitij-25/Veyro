// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSummary {

 DateTime get date; DailyActivity get activity; Workout? get activeWorkout; List<Routine> get todaysRoutines; int get workoutsThisWeek; double? get latestWeightKg; List<GoalProgress> get goals;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.activity, _this.activity) || other.activity == _this.activity)&&(identical(other.activeWorkout, _this.activeWorkout) || other.activeWorkout == _this.activeWorkout)&&const DeepCollectionEquality().equals(other.todaysRoutines, _this.todaysRoutines)&&(identical(other.workoutsThisWeek, _this.workoutsThisWeek) || other.workoutsThisWeek == _this.workoutsThisWeek)&&(identical(other.latestWeightKg, _this.latestWeightKg) || other.latestWeightKg == _this.latestWeightKg)&&const DeepCollectionEquality().equals(other.goals, _this.goals));
}


@override
int get hashCode {
  final _this = this as DashboardSummary;
  return Object.hash(runtimeType,_this.date,_this.activity,_this.activeWorkout,const DeepCollectionEquality().hash(_this.todaysRoutines),_this.workoutsThisWeek,_this.latestWeightKg,const DeepCollectionEquality().hash(_this.goals));
}

@override
String toString() {
  final _this = this as DashboardSummary;
  return 'DashboardSummary(date: ${_this.date}, activity: ${_this.activity}, activeWorkout: ${_this.activeWorkout}, todaysRoutines: ${_this.todaysRoutines}, workoutsThisWeek: ${_this.workoutsThisWeek}, latestWeightKg: ${_this.latestWeightKg}, goals: ${_this.goals})';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 DateTime date, DailyActivity activity, Workout? activeWorkout, List<Routine> todaysRoutines, int workoutsThisWeek, double? latestWeightKg, List<GoalProgress> goals
});


$DailyActivityCopyWith<$Res> get activity;$WorkoutCopyWith<$Res>? get activeWorkout;

}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? activity = null,Object? activeWorkout = freezed,Object? todaysRoutines = null,Object? workoutsThisWeek = null,Object? latestWeightKg = freezed,Object? goals = null,}) {
  return _then(DashboardSummary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as DailyActivity,activeWorkout: freezed == activeWorkout ? _self.activeWorkout : activeWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,todaysRoutines: null == todaysRoutines ? _self.todaysRoutines : todaysRoutines // ignore: cast_nullable_to_non_nullable
as List<Routine>,workoutsThisWeek: null == workoutsThisWeek ? _self.workoutsThisWeek : workoutsThisWeek // ignore: cast_nullable_to_non_nullable
as int,latestWeightKg: freezed == latestWeightKg ? _self.latestWeightKg : latestWeightKg // ignore: cast_nullable_to_non_nullable
as double?,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalProgress>,
  ));
}
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyActivityCopyWith<$Res> get activity {
  
  return $DailyActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get activeWorkout {
    if (_self.activeWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.activeWorkout!, (value) {
    return _then(_self.copyWith(activeWorkout: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  DailyActivity activity,  Workout? activeWorkout,  List<Routine> todaysRoutines,  int workoutsThisWeek,  double? latestWeightKg,  List<GoalProgress> goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.date,_that.activity,_that.activeWorkout,_that.todaysRoutines,_that.workoutsThisWeek,_that.latestWeightKg,_that.goals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  DailyActivity activity,  Workout? activeWorkout,  List<Routine> todaysRoutines,  int workoutsThisWeek,  double? latestWeightKg,  List<GoalProgress> goals)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.date,_that.activity,_that.activeWorkout,_that.todaysRoutines,_that.workoutsThisWeek,_that.latestWeightKg,_that.goals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  DailyActivity activity,  Workout? activeWorkout,  List<Routine> todaysRoutines,  int workoutsThisWeek,  double? latestWeightKg,  List<GoalProgress> goals)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.date,_that.activity,_that.activeWorkout,_that.todaysRoutines,_that.workoutsThisWeek,_that.latestWeightKg,_that.goals);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.date, required this.activity, this.activeWorkout,  List<Routine> todaysRoutines = const [], this.workoutsThisWeek = 0, this.latestWeightKg,  List<GoalProgress> goals = const []}): _todaysRoutines = todaysRoutines,_goals = goals;
  

@override final  DateTime date;
@override final  DailyActivity activity;
@override final  Workout? activeWorkout;
 final  List<Routine> _todaysRoutines;
@override@JsonKey() List<Routine> get todaysRoutines {
  if (_todaysRoutines is EqualUnmodifiableListView) return _todaysRoutines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todaysRoutines);
}

@override@JsonKey() final  int workoutsThisWeek;
@override final  double? latestWeightKg;
 final  List<GoalProgress> _goals;
@override@JsonKey() List<GoalProgress> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.date, date) || other.date == date)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.activeWorkout, activeWorkout) || other.activeWorkout == activeWorkout)&&const DeepCollectionEquality().equals(other.todaysRoutines, _todaysRoutines)&&(identical(other.workoutsThisWeek, workoutsThisWeek) || other.workoutsThisWeek == workoutsThisWeek)&&(identical(other.latestWeightKg, latestWeightKg) || other.latestWeightKg == latestWeightKg)&&const DeepCollectionEquality().equals(other.goals, _goals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,activity,activeWorkout,const DeepCollectionEquality().hash(_todaysRoutines),workoutsThisWeek,latestWeightKg,const DeepCollectionEquality().hash(_goals));
}

@override
String toString() {
    return 'DashboardSummary(date: $date, activity: $activity, activeWorkout: $activeWorkout, todaysRoutines: $todaysRoutines, workoutsThisWeek: $workoutsThisWeek, latestWeightKg: $latestWeightKg, goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DailyActivity activity, Workout? activeWorkout, List<Routine> todaysRoutines, int workoutsThisWeek, double? latestWeightKg, List<GoalProgress> goals
});


@override $DailyActivityCopyWith<$Res> get activity;@override $WorkoutCopyWith<$Res>? get activeWorkout;

}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? activity = null,Object? activeWorkout = freezed,Object? todaysRoutines = null,Object? workoutsThisWeek = null,Object? latestWeightKg = freezed,Object? goals = null,}) {
  return _then(_DashboardSummary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as DailyActivity,activeWorkout: freezed == activeWorkout ? _self.activeWorkout : activeWorkout // ignore: cast_nullable_to_non_nullable
as Workout?,todaysRoutines: null == todaysRoutines ? _self._todaysRoutines : todaysRoutines // ignore: cast_nullable_to_non_nullable
as List<Routine>,workoutsThisWeek: null == workoutsThisWeek ? _self.workoutsThisWeek : workoutsThisWeek // ignore: cast_nullable_to_non_nullable
as int,latestWeightKg: freezed == latestWeightKg ? _self.latestWeightKg : latestWeightKg // ignore: cast_nullable_to_non_nullable
as double?,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalProgress>,
  ));
}

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyActivityCopyWith<$Res> get activity {
  
  return $DailyActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res>? get activeWorkout {
    if (_self.activeWorkout == null) {
    return null;
  }

  return $WorkoutCopyWith<$Res>(_self.activeWorkout!, (value) {
    return _then(_self.copyWith(activeWorkout: value));
  });
}
}

// dart format on
