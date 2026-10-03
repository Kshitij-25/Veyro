// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_metrics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BodyMetricsState {

 ViewStatus get status;/// Newest first.
 List<BodyMeasurement> get measurements; BodyProgress get progress;/// Number of days the progress/trend covers.
 int get progressDays; Failure? get failure;
/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyMetricsStateCopyWith<BodyMetricsState> get copyWith => _$BodyMetricsStateCopyWithImpl<BodyMetricsState>(this as BodyMetricsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BodyMetricsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyMetricsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.measurements, _this.measurements)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.progressDays, _this.progressDays) || other.progressDays == _this.progressDays)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as BodyMetricsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.measurements),_this.progress,_this.progressDays,_this.failure);
}

@override
String toString() {
  final _this = this as BodyMetricsState;
  return 'BodyMetricsState(status: ${_this.status}, measurements: ${_this.measurements}, progress: ${_this.progress}, progressDays: ${_this.progressDays}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $BodyMetricsStateCopyWith<$Res>  {
  factory $BodyMetricsStateCopyWith(BodyMetricsState value, $Res Function(BodyMetricsState) _then) = _$BodyMetricsStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<BodyMeasurement> measurements, BodyProgress progress, int progressDays, Failure? failure
});


$BodyProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$BodyMetricsStateCopyWithImpl<$Res>
    implements $BodyMetricsStateCopyWith<$Res> {
  _$BodyMetricsStateCopyWithImpl(this._self, this._then);

  final BodyMetricsState _self;
  final $Res Function(BodyMetricsState) _then;

/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? measurements = null,Object? progress = null,Object? progressDays = null,Object? failure = freezed,}) {
  return _then(BodyMetricsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,measurements: null == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<BodyMeasurement>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as BodyProgress,progressDays: null == progressDays ? _self.progressDays : progressDays // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyProgressCopyWith<$Res> get progress {
  
  return $BodyProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [BodyMetricsState].
extension BodyMetricsStatePatterns on BodyMetricsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyMetricsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyMetricsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyMetricsState value)  $default,){
final _that = this;
switch (_that) {
case _BodyMetricsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyMetricsState value)?  $default,){
final _that = this;
switch (_that) {
case _BodyMetricsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<BodyMeasurement> measurements,  BodyProgress progress,  int progressDays,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyMetricsState() when $default != null:
return $default(_that.status,_that.measurements,_that.progress,_that.progressDays,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<BodyMeasurement> measurements,  BodyProgress progress,  int progressDays,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _BodyMetricsState():
return $default(_that.status,_that.measurements,_that.progress,_that.progressDays,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<BodyMeasurement> measurements,  BodyProgress progress,  int progressDays,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BodyMetricsState() when $default != null:
return $default(_that.status,_that.measurements,_that.progress,_that.progressDays,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BodyMetricsState implements BodyMetricsState {
  const _BodyMetricsState({this.status = ViewStatus.initial,  List<BodyMeasurement> measurements = const [], this.progress = const BodyProgress(), this.progressDays = 90, this.failure}): _measurements = measurements;
  

@override@JsonKey() final  ViewStatus status;
/// Newest first.
 final  List<BodyMeasurement> _measurements;
/// Newest first.
@override@JsonKey() List<BodyMeasurement> get measurements {
  if (_measurements is EqualUnmodifiableListView) return _measurements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_measurements);
}

@override@JsonKey() final  BodyProgress progress;
/// Number of days the progress/trend covers.
@override@JsonKey() final  int progressDays;
@override final  Failure? failure;

/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyMetricsStateCopyWith<_BodyMetricsState> get copyWith => __$BodyMetricsStateCopyWithImpl<_BodyMetricsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyMetricsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.measurements, _measurements)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.progressDays, progressDays) || other.progressDays == progressDays)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_measurements),progress,progressDays,failure);
}

@override
String toString() {
    return 'BodyMetricsState(status: $status, measurements: $measurements, progress: $progress, progressDays: $progressDays, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BodyMetricsStateCopyWith<$Res> implements $BodyMetricsStateCopyWith<$Res> {
  factory _$BodyMetricsStateCopyWith(_BodyMetricsState value, $Res Function(_BodyMetricsState) _then) = __$BodyMetricsStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<BodyMeasurement> measurements, BodyProgress progress, int progressDays, Failure? failure
});


@override $BodyProgressCopyWith<$Res> get progress;

}
/// @nodoc
class __$BodyMetricsStateCopyWithImpl<$Res>
    implements _$BodyMetricsStateCopyWith<$Res> {
  __$BodyMetricsStateCopyWithImpl(this._self, this._then);

  final _BodyMetricsState _self;
  final $Res Function(_BodyMetricsState) _then;

/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? measurements = null,Object? progress = null,Object? progressDays = null,Object? failure = freezed,}) {
  return _then(_BodyMetricsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,measurements: null == measurements ? _self._measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<BodyMeasurement>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as BodyProgress,progressDays: null == progressDays ? _self.progressDays : progressDays // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of BodyMetricsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyProgressCopyWith<$Res> get progress {
  
  return $BodyProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
