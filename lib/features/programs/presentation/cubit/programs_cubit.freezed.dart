// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'programs_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgramsState {

 bool get loaded; bool get isBusy;/// `null` when not enrolled.
 ProgramProgress? get progress; Failure? get failure;
/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramsStateCopyWith<ProgramsState> get copyWith => _$ProgramsStateCopyWithImpl<ProgramsState>(this as ProgramsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgramsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsState&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.isBusy, _this.isBusy) || other.isBusy == _this.isBusy)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ProgramsState;
  return Object.hash(runtimeType,_this.loaded,_this.isBusy,_this.progress,_this.failure);
}

@override
String toString() {
  final _this = this as ProgramsState;
  return 'ProgramsState(loaded: ${_this.loaded}, isBusy: ${_this.isBusy}, progress: ${_this.progress}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ProgramsStateCopyWith<$Res>  {
  factory $ProgramsStateCopyWith(ProgramsState value, $Res Function(ProgramsState) _then) = _$ProgramsStateCopyWithImpl;
@useResult
$Res call({
 bool loaded, bool isBusy, ProgramProgress? progress, Failure? failure
});




}
/// @nodoc
class _$ProgramsStateCopyWithImpl<$Res>
    implements $ProgramsStateCopyWith<$Res> {
  _$ProgramsStateCopyWithImpl(this._self, this._then);

  final ProgramsState _self;
  final $Res Function(ProgramsState) _then;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? isBusy = null,Object? progress = freezed,Object? failure = freezed,}) {
  return _then(ProgramsState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as ProgramProgress?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramsState].
extension ProgramsStatePatterns on ProgramsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramsState value)  $default,){
final _that = this;
switch (_that) {
case _ProgramsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loaded,  bool isBusy,  ProgramProgress? progress,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramsState() when $default != null:
return $default(_that.loaded,_that.isBusy,_that.progress,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loaded,  bool isBusy,  ProgramProgress? progress,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ProgramsState():
return $default(_that.loaded,_that.isBusy,_that.progress,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loaded,  bool isBusy,  ProgramProgress? progress,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ProgramsState() when $default != null:
return $default(_that.loaded,_that.isBusy,_that.progress,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ProgramsState implements ProgramsState {
  const _ProgramsState({this.loaded = false, this.isBusy = false, this.progress, this.failure});
  

@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool isBusy;
/// `null` when not enrolled.
@override final  ProgramProgress? progress;
@override final  Failure? failure;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramsStateCopyWith<_ProgramsState> get copyWith => __$ProgramsStateCopyWithImpl<_ProgramsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramsState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loaded,isBusy,progress,failure);
}

@override
String toString() {
    return 'ProgramsState(loaded: $loaded, isBusy: $isBusy, progress: $progress, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ProgramsStateCopyWith<$Res> implements $ProgramsStateCopyWith<$Res> {
  factory _$ProgramsStateCopyWith(_ProgramsState value, $Res Function(_ProgramsState) _then) = __$ProgramsStateCopyWithImpl;
@override @useResult
$Res call({
 bool loaded, bool isBusy, ProgramProgress? progress, Failure? failure
});




}
/// @nodoc
class __$ProgramsStateCopyWithImpl<$Res>
    implements _$ProgramsStateCopyWith<$Res> {
  __$ProgramsStateCopyWithImpl(this._self, this._then);

  final _ProgramsState _self;
  final $Res Function(_ProgramsState) _then;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? isBusy = null,Object? progress = freezed,Object? failure = freezed,}) {
  return _then(_ProgramsState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as ProgramProgress?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
