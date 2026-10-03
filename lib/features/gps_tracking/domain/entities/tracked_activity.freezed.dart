// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracked_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackedActivity {

 String get id; TrackedActivityType get type; String? get title; DateTime get startedAt; DateTime get endedAt; Duration get movingDuration; double get distanceMeters; double get elevationGainMeters; double get caloriesKcal; List<RoutePoint> get route;
/// Create a copy of TrackedActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackedActivityCopyWith<TrackedActivity> get copyWith => _$TrackedActivityCopyWithImpl<TrackedActivity>(this as TrackedActivity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TrackedActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedActivity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.movingDuration, _this.movingDuration) || other.movingDuration == _this.movingDuration)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.elevationGainMeters, _this.elevationGainMeters) || other.elevationGainMeters == _this.elevationGainMeters)&&(identical(other.caloriesKcal, _this.caloriesKcal) || other.caloriesKcal == _this.caloriesKcal)&&const DeepCollectionEquality().equals(other.route, _this.route));
}


@override
int get hashCode {
  final _this = this as TrackedActivity;
  return Object.hash(runtimeType,_this.id,_this.type,_this.title,_this.startedAt,_this.endedAt,_this.movingDuration,_this.distanceMeters,_this.elevationGainMeters,_this.caloriesKcal,const DeepCollectionEquality().hash(_this.route));
}

@override
String toString() {
  final _this = this as TrackedActivity;
  return 'TrackedActivity(id: ${_this.id}, type: ${_this.type}, title: ${_this.title}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, movingDuration: ${_this.movingDuration}, distanceMeters: ${_this.distanceMeters}, elevationGainMeters: ${_this.elevationGainMeters}, caloriesKcal: ${_this.caloriesKcal}, route: ${_this.route})';
}


}

/// @nodoc
abstract mixin class $TrackedActivityCopyWith<$Res>  {
  factory $TrackedActivityCopyWith(TrackedActivity value, $Res Function(TrackedActivity) _then) = _$TrackedActivityCopyWithImpl;
@useResult
$Res call({
 String id, TrackedActivityType type, String? title, DateTime startedAt, DateTime endedAt, Duration movingDuration, double distanceMeters, double elevationGainMeters, double caloriesKcal, List<RoutePoint> route
});




}
/// @nodoc
class _$TrackedActivityCopyWithImpl<$Res>
    implements $TrackedActivityCopyWith<$Res> {
  _$TrackedActivityCopyWithImpl(this._self, this._then);

  final TrackedActivity _self;
  final $Res Function(TrackedActivity) _then;

/// Create a copy of TrackedActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? startedAt = null,Object? endedAt = null,Object? movingDuration = null,Object? distanceMeters = null,Object? elevationGainMeters = null,Object? caloriesKcal = null,Object? route = null,}) {
  return _then(TrackedActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TrackedActivityType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,movingDuration: null == movingDuration ? _self.movingDuration : movingDuration // ignore: cast_nullable_to_non_nullable
as Duration,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elevationGainMeters: null == elevationGainMeters ? _self.elevationGainMeters : elevationGainMeters // ignore: cast_nullable_to_non_nullable
as double,caloriesKcal: null == caloriesKcal ? _self.caloriesKcal : caloriesKcal // ignore: cast_nullable_to_non_nullable
as double,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackedActivity].
extension TrackedActivityPatterns on TrackedActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackedActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackedActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackedActivity value)  $default,){
final _that = this;
switch (_that) {
case _TrackedActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackedActivity value)?  $default,){
final _that = this;
switch (_that) {
case _TrackedActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TrackedActivityType type,  String? title,  DateTime startedAt,  DateTime endedAt,  Duration movingDuration,  double distanceMeters,  double elevationGainMeters,  double caloriesKcal,  List<RoutePoint> route)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackedActivity() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.startedAt,_that.endedAt,_that.movingDuration,_that.distanceMeters,_that.elevationGainMeters,_that.caloriesKcal,_that.route);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TrackedActivityType type,  String? title,  DateTime startedAt,  DateTime endedAt,  Duration movingDuration,  double distanceMeters,  double elevationGainMeters,  double caloriesKcal,  List<RoutePoint> route)  $default,) {final _that = this;
switch (_that) {
case _TrackedActivity():
return $default(_that.id,_that.type,_that.title,_that.startedAt,_that.endedAt,_that.movingDuration,_that.distanceMeters,_that.elevationGainMeters,_that.caloriesKcal,_that.route);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TrackedActivityType type,  String? title,  DateTime startedAt,  DateTime endedAt,  Duration movingDuration,  double distanceMeters,  double elevationGainMeters,  double caloriesKcal,  List<RoutePoint> route)?  $default,) {final _that = this;
switch (_that) {
case _TrackedActivity() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.startedAt,_that.endedAt,_that.movingDuration,_that.distanceMeters,_that.elevationGainMeters,_that.caloriesKcal,_that.route);case _:
  return null;

}
}

}

/// @nodoc


class _TrackedActivity extends TrackedActivity {
  const _TrackedActivity({required this.id, required this.type, this.title, required this.startedAt, required this.endedAt, required this.movingDuration, required this.distanceMeters, this.elevationGainMeters = 0, this.caloriesKcal = 0,  List<RoutePoint> route = const []}): _route = route,super._();
  

@override final  String id;
@override final  TrackedActivityType type;
@override final  String? title;
@override final  DateTime startedAt;
@override final  DateTime endedAt;
@override final  Duration movingDuration;
@override final  double distanceMeters;
@override@JsonKey() final  double elevationGainMeters;
@override@JsonKey() final  double caloriesKcal;
 final  List<RoutePoint> _route;
@override@JsonKey() List<RoutePoint> get route {
  if (_route is EqualUnmodifiableListView) return _route;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_route);
}


/// Create a copy of TrackedActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackedActivityCopyWith<_TrackedActivity> get copyWith => __$TrackedActivityCopyWithImpl<_TrackedActivity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackedActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.movingDuration, movingDuration) || other.movingDuration == movingDuration)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.elevationGainMeters, elevationGainMeters) || other.elevationGainMeters == elevationGainMeters)&&(identical(other.caloriesKcal, caloriesKcal) || other.caloriesKcal == caloriesKcal)&&const DeepCollectionEquality().equals(other.route, _route));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,title,startedAt,endedAt,movingDuration,distanceMeters,elevationGainMeters,caloriesKcal,const DeepCollectionEquality().hash(_route));
}

@override
String toString() {
    return 'TrackedActivity(id: $id, type: $type, title: $title, startedAt: $startedAt, endedAt: $endedAt, movingDuration: $movingDuration, distanceMeters: $distanceMeters, elevationGainMeters: $elevationGainMeters, caloriesKcal: $caloriesKcal, route: $route)';
}


}

/// @nodoc
abstract mixin class _$TrackedActivityCopyWith<$Res> implements $TrackedActivityCopyWith<$Res> {
  factory _$TrackedActivityCopyWith(_TrackedActivity value, $Res Function(_TrackedActivity) _then) = __$TrackedActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, TrackedActivityType type, String? title, DateTime startedAt, DateTime endedAt, Duration movingDuration, double distanceMeters, double elevationGainMeters, double caloriesKcal, List<RoutePoint> route
});




}
/// @nodoc
class __$TrackedActivityCopyWithImpl<$Res>
    implements _$TrackedActivityCopyWith<$Res> {
  __$TrackedActivityCopyWithImpl(this._self, this._then);

  final _TrackedActivity _self;
  final $Res Function(_TrackedActivity) _then;

/// Create a copy of TrackedActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = freezed,Object? startedAt = null,Object? endedAt = null,Object? movingDuration = null,Object? distanceMeters = null,Object? elevationGainMeters = null,Object? caloriesKcal = null,Object? route = null,}) {
  return _then(_TrackedActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TrackedActivityType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,movingDuration: null == movingDuration ? _self.movingDuration : movingDuration // ignore: cast_nullable_to_non_nullable
as Duration,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elevationGainMeters: null == elevationGainMeters ? _self.elevationGainMeters : elevationGainMeters // ignore: cast_nullable_to_non_nullable
as double,caloriesKcal: null == caloriesKcal ? _self.caloriesKcal : caloriesKcal // ignore: cast_nullable_to_non_nullable
as double,route: null == route ? _self._route : route // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}


}

// dart format on
