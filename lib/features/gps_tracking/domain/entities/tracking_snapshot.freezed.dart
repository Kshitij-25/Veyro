// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingSnapshot {

 TrackingStatus get status; DateTime get startedAt; Duration get elapsed; double get distanceMeters; double get elevationGainMeters;/// Pace over the last ~20 seconds; `null` until enough data is available.
 double? get currentPaceSecondsPerKm; List<RoutePoint> get route;
/// Create a copy of TrackingSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingSnapshotCopyWith<TrackingSnapshot> get copyWith => _$TrackingSnapshotCopyWithImpl<TrackingSnapshot>(this as TrackingSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TrackingSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingSnapshot&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.elevationGainMeters, _this.elevationGainMeters) || other.elevationGainMeters == _this.elevationGainMeters)&&(identical(other.currentPaceSecondsPerKm, _this.currentPaceSecondsPerKm) || other.currentPaceSecondsPerKm == _this.currentPaceSecondsPerKm)&&const DeepCollectionEquality().equals(other.route, _this.route));
}


@override
int get hashCode {
  final _this = this as TrackingSnapshot;
  return Object.hash(runtimeType,_this.status,_this.startedAt,_this.elapsed,_this.distanceMeters,_this.elevationGainMeters,_this.currentPaceSecondsPerKm,const DeepCollectionEquality().hash(_this.route));
}

@override
String toString() {
  final _this = this as TrackingSnapshot;
  return 'TrackingSnapshot(status: ${_this.status}, startedAt: ${_this.startedAt}, elapsed: ${_this.elapsed}, distanceMeters: ${_this.distanceMeters}, elevationGainMeters: ${_this.elevationGainMeters}, currentPaceSecondsPerKm: ${_this.currentPaceSecondsPerKm}, route: ${_this.route})';
}


}

/// @nodoc
abstract mixin class $TrackingSnapshotCopyWith<$Res>  {
  factory $TrackingSnapshotCopyWith(TrackingSnapshot value, $Res Function(TrackingSnapshot) _then) = _$TrackingSnapshotCopyWithImpl;
@useResult
$Res call({
 TrackingStatus status, DateTime startedAt, Duration elapsed, double distanceMeters, double elevationGainMeters, double? currentPaceSecondsPerKm, List<RoutePoint> route
});




}
/// @nodoc
class _$TrackingSnapshotCopyWithImpl<$Res>
    implements $TrackingSnapshotCopyWith<$Res> {
  _$TrackingSnapshotCopyWithImpl(this._self, this._then);

  final TrackingSnapshot _self;
  final $Res Function(TrackingSnapshot) _then;

/// Create a copy of TrackingSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? startedAt = null,Object? elapsed = null,Object? distanceMeters = null,Object? elevationGainMeters = null,Object? currentPaceSecondsPerKm = freezed,Object? route = null,}) {
  return _then(TrackingSnapshot(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackingStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elevationGainMeters: null == elevationGainMeters ? _self.elevationGainMeters : elevationGainMeters // ignore: cast_nullable_to_non_nullable
as double,currentPaceSecondsPerKm: freezed == currentPaceSecondsPerKm ? _self.currentPaceSecondsPerKm : currentPaceSecondsPerKm // ignore: cast_nullable_to_non_nullable
as double?,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingSnapshot].
extension TrackingSnapshotPatterns on TrackingSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TrackingSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrackingStatus status,  DateTime startedAt,  Duration elapsed,  double distanceMeters,  double elevationGainMeters,  double? currentPaceSecondsPerKm,  List<RoutePoint> route)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingSnapshot() when $default != null:
return $default(_that.status,_that.startedAt,_that.elapsed,_that.distanceMeters,_that.elevationGainMeters,_that.currentPaceSecondsPerKm,_that.route);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrackingStatus status,  DateTime startedAt,  Duration elapsed,  double distanceMeters,  double elevationGainMeters,  double? currentPaceSecondsPerKm,  List<RoutePoint> route)  $default,) {final _that = this;
switch (_that) {
case _TrackingSnapshot():
return $default(_that.status,_that.startedAt,_that.elapsed,_that.distanceMeters,_that.elevationGainMeters,_that.currentPaceSecondsPerKm,_that.route);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrackingStatus status,  DateTime startedAt,  Duration elapsed,  double distanceMeters,  double elevationGainMeters,  double? currentPaceSecondsPerKm,  List<RoutePoint> route)?  $default,) {final _that = this;
switch (_that) {
case _TrackingSnapshot() when $default != null:
return $default(_that.status,_that.startedAt,_that.elapsed,_that.distanceMeters,_that.elevationGainMeters,_that.currentPaceSecondsPerKm,_that.route);case _:
  return null;

}
}

}

/// @nodoc


class _TrackingSnapshot extends TrackingSnapshot {
  const _TrackingSnapshot({required this.status, required this.startedAt, required this.elapsed, this.distanceMeters = 0, this.elevationGainMeters = 0, this.currentPaceSecondsPerKm,  List<RoutePoint> route = const []}): _route = route,super._();
  

@override final  TrackingStatus status;
@override final  DateTime startedAt;
@override final  Duration elapsed;
@override@JsonKey() final  double distanceMeters;
@override@JsonKey() final  double elevationGainMeters;
/// Pace over the last ~20 seconds; `null` until enough data is available.
@override final  double? currentPaceSecondsPerKm;
 final  List<RoutePoint> _route;
@override@JsonKey() List<RoutePoint> get route {
  if (_route is EqualUnmodifiableListView) return _route;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_route);
}


/// Create a copy of TrackingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingSnapshotCopyWith<_TrackingSnapshot> get copyWith => __$TrackingSnapshotCopyWithImpl<_TrackingSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingSnapshot&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.elevationGainMeters, elevationGainMeters) || other.elevationGainMeters == elevationGainMeters)&&(identical(other.currentPaceSecondsPerKm, currentPaceSecondsPerKm) || other.currentPaceSecondsPerKm == currentPaceSecondsPerKm)&&const DeepCollectionEquality().equals(other.route, _route));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,startedAt,elapsed,distanceMeters,elevationGainMeters,currentPaceSecondsPerKm,const DeepCollectionEquality().hash(_route));
}

@override
String toString() {
    return 'TrackingSnapshot(status: $status, startedAt: $startedAt, elapsed: $elapsed, distanceMeters: $distanceMeters, elevationGainMeters: $elevationGainMeters, currentPaceSecondsPerKm: $currentPaceSecondsPerKm, route: $route)';
}


}

/// @nodoc
abstract mixin class _$TrackingSnapshotCopyWith<$Res> implements $TrackingSnapshotCopyWith<$Res> {
  factory _$TrackingSnapshotCopyWith(_TrackingSnapshot value, $Res Function(_TrackingSnapshot) _then) = __$TrackingSnapshotCopyWithImpl;
@override @useResult
$Res call({
 TrackingStatus status, DateTime startedAt, Duration elapsed, double distanceMeters, double elevationGainMeters, double? currentPaceSecondsPerKm, List<RoutePoint> route
});




}
/// @nodoc
class __$TrackingSnapshotCopyWithImpl<$Res>
    implements _$TrackingSnapshotCopyWith<$Res> {
  __$TrackingSnapshotCopyWithImpl(this._self, this._then);

  final _TrackingSnapshot _self;
  final $Res Function(_TrackingSnapshot) _then;

/// Create a copy of TrackingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? startedAt = null,Object? elapsed = null,Object? distanceMeters = null,Object? elevationGainMeters = null,Object? currentPaceSecondsPerKm = freezed,Object? route = null,}) {
  return _then(_TrackingSnapshot(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackingStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elevationGainMeters: null == elevationGainMeters ? _self.elevationGainMeters : elevationGainMeters // ignore: cast_nullable_to_non_nullable
as double,currentPaceSecondsPerKm: freezed == currentPaceSecondsPerKm ? _self.currentPaceSecondsPerKm : currentPaceSecondsPerKm // ignore: cast_nullable_to_non_nullable
as double?,route: null == route ? _self._route : route // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}


}

// dart format on
