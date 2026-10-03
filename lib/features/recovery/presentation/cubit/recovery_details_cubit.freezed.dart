// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recovery_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecoveryDetailsState {

 ViewStatus get status; RecoveryDetails? get details; Failure? get failure;
/// Create a copy of RecoveryDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecoveryDetailsStateCopyWith<RecoveryDetailsState> get copyWith => _$RecoveryDetailsStateCopyWithImpl<RecoveryDetailsState>(this as RecoveryDetailsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecoveryDetailsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecoveryDetailsState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RecoveryDetailsState;
  return Object.hash(runtimeType,_this.status,_this.details,_this.failure);
}

@override
String toString() {
  final _this = this as RecoveryDetailsState;
  return 'RecoveryDetailsState(status: ${_this.status}, details: ${_this.details}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RecoveryDetailsStateCopyWith<$Res>  {
  factory $RecoveryDetailsStateCopyWith(RecoveryDetailsState value, $Res Function(RecoveryDetailsState) _then) = _$RecoveryDetailsStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, RecoveryDetails? details, Failure? failure
});




}
/// @nodoc
class _$RecoveryDetailsStateCopyWithImpl<$Res>
    implements $RecoveryDetailsStateCopyWith<$Res> {
  _$RecoveryDetailsStateCopyWithImpl(this._self, this._then);

  final RecoveryDetailsState _self;
  final $Res Function(RecoveryDetailsState) _then;

/// Create a copy of RecoveryDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? details = freezed,Object? failure = freezed,}) {
  return _then(RecoveryDetailsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RecoveryDetails?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecoveryDetailsState].
extension RecoveryDetailsStatePatterns on RecoveryDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecoveryDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecoveryDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecoveryDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _RecoveryDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecoveryDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _RecoveryDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  RecoveryDetails? details,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecoveryDetailsState() when $default != null:
return $default(_that.status,_that.details,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  RecoveryDetails? details,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RecoveryDetailsState():
return $default(_that.status,_that.details,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  RecoveryDetails? details,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RecoveryDetailsState() when $default != null:
return $default(_that.status,_that.details,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RecoveryDetailsState implements RecoveryDetailsState {
  const _RecoveryDetailsState({this.status = ViewStatus.initial, this.details, this.failure});
  

@override@JsonKey() final  ViewStatus status;
@override final  RecoveryDetails? details;
@override final  Failure? failure;

/// Create a copy of RecoveryDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecoveryDetailsStateCopyWith<_RecoveryDetailsState> get copyWith => __$RecoveryDetailsStateCopyWithImpl<_RecoveryDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecoveryDetailsState&&(identical(other.status, status) || other.status == status)&&(identical(other.details, details) || other.details == details)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,details,failure);
}

@override
String toString() {
    return 'RecoveryDetailsState(status: $status, details: $details, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RecoveryDetailsStateCopyWith<$Res> implements $RecoveryDetailsStateCopyWith<$Res> {
  factory _$RecoveryDetailsStateCopyWith(_RecoveryDetailsState value, $Res Function(_RecoveryDetailsState) _then) = __$RecoveryDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, RecoveryDetails? details, Failure? failure
});




}
/// @nodoc
class __$RecoveryDetailsStateCopyWithImpl<$Res>
    implements _$RecoveryDetailsStateCopyWith<$Res> {
  __$RecoveryDetailsStateCopyWithImpl(this._self, this._then);

  final _RecoveryDetailsState _self;
  final $Res Function(_RecoveryDetailsState) _then;

/// Create a copy of RecoveryDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? details = freezed,Object? failure = freezed,}) {
  return _then(_RecoveryDetailsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RecoveryDetails?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
