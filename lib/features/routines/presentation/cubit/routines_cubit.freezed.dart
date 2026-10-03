// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routines_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoutinesState {

 ViewStatus get status; List<Routine> get routines; Failure? get failure;
/// Create a copy of RoutinesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutinesStateCopyWith<RoutinesState> get copyWith => _$RoutinesStateCopyWithImpl<RoutinesState>(this as RoutinesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoutinesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutinesState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.routines, _this.routines)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RoutinesState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.routines),_this.failure);
}

@override
String toString() {
  final _this = this as RoutinesState;
  return 'RoutinesState(status: ${_this.status}, routines: ${_this.routines}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RoutinesStateCopyWith<$Res>  {
  factory $RoutinesStateCopyWith(RoutinesState value, $Res Function(RoutinesState) _then) = _$RoutinesStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<Routine> routines, Failure? failure
});




}
/// @nodoc
class _$RoutinesStateCopyWithImpl<$Res>
    implements $RoutinesStateCopyWith<$Res> {
  _$RoutinesStateCopyWithImpl(this._self, this._then);

  final RoutinesState _self;
  final $Res Function(RoutinesState) _then;

/// Create a copy of RoutinesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? routines = null,Object? failure = freezed,}) {
  return _then(RoutinesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,routines: null == routines ? _self.routines : routines // ignore: cast_nullable_to_non_nullable
as List<Routine>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutinesState].
extension RoutinesStatePatterns on RoutinesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutinesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutinesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutinesState value)  $default,){
final _that = this;
switch (_that) {
case _RoutinesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutinesState value)?  $default,){
final _that = this;
switch (_that) {
case _RoutinesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<Routine> routines,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutinesState() when $default != null:
return $default(_that.status,_that.routines,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<Routine> routines,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RoutinesState():
return $default(_that.status,_that.routines,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<Routine> routines,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RoutinesState() when $default != null:
return $default(_that.status,_that.routines,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RoutinesState implements RoutinesState {
  const _RoutinesState({this.status = ViewStatus.initial,  List<Routine> routines = const [], this.failure}): _routines = routines;
  

@override@JsonKey() final  ViewStatus status;
 final  List<Routine> _routines;
@override@JsonKey() List<Routine> get routines {
  if (_routines is EqualUnmodifiableListView) return _routines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routines);
}

@override final  Failure? failure;

/// Create a copy of RoutinesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutinesStateCopyWith<_RoutinesState> get copyWith => __$RoutinesStateCopyWithImpl<_RoutinesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutinesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.routines, _routines)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_routines),failure);
}

@override
String toString() {
    return 'RoutinesState(status: $status, routines: $routines, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RoutinesStateCopyWith<$Res> implements $RoutinesStateCopyWith<$Res> {
  factory _$RoutinesStateCopyWith(_RoutinesState value, $Res Function(_RoutinesState) _then) = __$RoutinesStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<Routine> routines, Failure? failure
});




}
/// @nodoc
class __$RoutinesStateCopyWithImpl<$Res>
    implements _$RoutinesStateCopyWith<$Res> {
  __$RoutinesStateCopyWithImpl(this._self, this._then);

  final _RoutinesState _self;
  final $Res Function(_RoutinesState) _then;

/// Create a copy of RoutinesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? routines = null,Object? failure = freezed,}) {
  return _then(_RoutinesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,routines: null == routines ? _self._routines : routines // ignore: cast_nullable_to_non_nullable
as List<Routine>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
