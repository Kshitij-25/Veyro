// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoutePoint {

 double get latitude; double get longitude; DateTime get timestamp; double? get altitudeMeters; double? get accuracyMeters;
/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutePointCopyWith<RoutePoint> get copyWith => _$RoutePointCopyWithImpl<RoutePoint>(this as RoutePoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoutePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutePoint&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.altitudeMeters, _this.altitudeMeters) || other.altitudeMeters == _this.altitudeMeters)&&(identical(other.accuracyMeters, _this.accuracyMeters) || other.accuracyMeters == _this.accuracyMeters));
}


@override
int get hashCode {
  final _this = this as RoutePoint;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.timestamp,_this.altitudeMeters,_this.accuracyMeters);
}

@override
String toString() {
  final _this = this as RoutePoint;
  return 'RoutePoint(latitude: ${_this.latitude}, longitude: ${_this.longitude}, timestamp: ${_this.timestamp}, altitudeMeters: ${_this.altitudeMeters}, accuracyMeters: ${_this.accuracyMeters})';
}


}

/// @nodoc
abstract mixin class $RoutePointCopyWith<$Res>  {
  factory $RoutePointCopyWith(RoutePoint value, $Res Function(RoutePoint) _then) = _$RoutePointCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, DateTime timestamp, double? altitudeMeters, double? accuracyMeters
});




}
/// @nodoc
class _$RoutePointCopyWithImpl<$Res>
    implements $RoutePointCopyWith<$Res> {
  _$RoutePointCopyWithImpl(this._self, this._then);

  final RoutePoint _self;
  final $Res Function(RoutePoint) _then;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? timestamp = null,Object? altitudeMeters = freezed,Object? accuracyMeters = freezed,}) {
  return _then(RoutePoint(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,altitudeMeters: freezed == altitudeMeters ? _self.altitudeMeters : altitudeMeters // ignore: cast_nullable_to_non_nullable
as double?,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutePoint].
extension RoutePointPatterns on RoutePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutePoint value)  $default,){
final _that = this;
switch (_that) {
case _RoutePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutePoint value)?  $default,){
final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  DateTime timestamp,  double? altitudeMeters,  double? accuracyMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
return $default(_that.latitude,_that.longitude,_that.timestamp,_that.altitudeMeters,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  DateTime timestamp,  double? altitudeMeters,  double? accuracyMeters)  $default,) {final _that = this;
switch (_that) {
case _RoutePoint():
return $default(_that.latitude,_that.longitude,_that.timestamp,_that.altitudeMeters,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  DateTime timestamp,  double? altitudeMeters,  double? accuracyMeters)?  $default,) {final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
return $default(_that.latitude,_that.longitude,_that.timestamp,_that.altitudeMeters,_that.accuracyMeters);case _:
  return null;

}
}

}

/// @nodoc


class _RoutePoint implements RoutePoint {
  const _RoutePoint({required this.latitude, required this.longitude, required this.timestamp, this.altitudeMeters, this.accuracyMeters});
  

@override final  double latitude;
@override final  double longitude;
@override final  DateTime timestamp;
@override final  double? altitudeMeters;
@override final  double? accuracyMeters;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutePointCopyWith<_RoutePoint> get copyWith => __$RoutePointCopyWithImpl<_RoutePoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutePoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.altitudeMeters, altitudeMeters) || other.altitudeMeters == altitudeMeters)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,timestamp,altitudeMeters,accuracyMeters);
}

@override
String toString() {
    return 'RoutePoint(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, altitudeMeters: $altitudeMeters, accuracyMeters: $accuracyMeters)';
}


}

/// @nodoc
abstract mixin class _$RoutePointCopyWith<$Res> implements $RoutePointCopyWith<$Res> {
  factory _$RoutePointCopyWith(_RoutePoint value, $Res Function(_RoutePoint) _then) = __$RoutePointCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, DateTime timestamp, double? altitudeMeters, double? accuracyMeters
});




}
/// @nodoc
class __$RoutePointCopyWithImpl<$Res>
    implements _$RoutePointCopyWith<$Res> {
  __$RoutePointCopyWithImpl(this._self, this._then);

  final _RoutePoint _self;
  final $Res Function(_RoutePoint) _then;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? timestamp = null,Object? altitudeMeters = freezed,Object? accuracyMeters = freezed,}) {
  return _then(_RoutePoint(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,altitudeMeters: freezed == altitudeMeters ? _self.altitudeMeters : altitudeMeters // ignore: cast_nullable_to_non_nullable
as double?,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
