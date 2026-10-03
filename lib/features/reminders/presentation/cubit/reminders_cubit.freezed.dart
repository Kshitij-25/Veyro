// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminders_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemindersState {

 ViewStatus get status; List<Reminder> get reminders;/// The OS refused notification permission, so reminders won't fire.
 bool get notificationsDenied; Failure? get failure;
/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersStateCopyWith<RemindersState> get copyWith => _$RemindersStateCopyWithImpl<RemindersState>(this as RemindersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemindersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.reminders, _this.reminders)&&(identical(other.notificationsDenied, _this.notificationsDenied) || other.notificationsDenied == _this.notificationsDenied)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RemindersState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.reminders),_this.notificationsDenied,_this.failure);
}

@override
String toString() {
  final _this = this as RemindersState;
  return 'RemindersState(status: ${_this.status}, reminders: ${_this.reminders}, notificationsDenied: ${_this.notificationsDenied}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RemindersStateCopyWith<$Res>  {
  factory $RemindersStateCopyWith(RemindersState value, $Res Function(RemindersState) _then) = _$RemindersStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<Reminder> reminders, bool notificationsDenied, Failure? failure
});




}
/// @nodoc
class _$RemindersStateCopyWithImpl<$Res>
    implements $RemindersStateCopyWith<$Res> {
  _$RemindersStateCopyWithImpl(this._self, this._then);

  final RemindersState _self;
  final $Res Function(RemindersState) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reminders = null,Object? notificationsDenied = null,Object? failure = freezed,}) {
  return _then(RemindersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,notificationsDenied: null == notificationsDenied ? _self.notificationsDenied : notificationsDenied // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RemindersState].
extension RemindersStatePatterns on RemindersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemindersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemindersState value)  $default,){
final _that = this;
switch (_that) {
case _RemindersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemindersState value)?  $default,){
final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<Reminder> reminders,  bool notificationsDenied,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
return $default(_that.status,_that.reminders,_that.notificationsDenied,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<Reminder> reminders,  bool notificationsDenied,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RemindersState():
return $default(_that.status,_that.reminders,_that.notificationsDenied,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<Reminder> reminders,  bool notificationsDenied,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
return $default(_that.status,_that.reminders,_that.notificationsDenied,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RemindersState implements RemindersState {
  const _RemindersState({this.status = ViewStatus.initial,  List<Reminder> reminders = const [], this.notificationsDenied = false, this.failure}): _reminders = reminders;
  

@override@JsonKey() final  ViewStatus status;
 final  List<Reminder> _reminders;
@override@JsonKey() List<Reminder> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

/// The OS refused notification permission, so reminders won't fire.
@override@JsonKey() final  bool notificationsDenied;
@override final  Failure? failure;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemindersStateCopyWith<_RemindersState> get copyWith => __$RemindersStateCopyWithImpl<_RemindersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemindersState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.reminders, _reminders)&&(identical(other.notificationsDenied, notificationsDenied) || other.notificationsDenied == notificationsDenied)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_reminders),notificationsDenied,failure);
}

@override
String toString() {
    return 'RemindersState(status: $status, reminders: $reminders, notificationsDenied: $notificationsDenied, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RemindersStateCopyWith<$Res> implements $RemindersStateCopyWith<$Res> {
  factory _$RemindersStateCopyWith(_RemindersState value, $Res Function(_RemindersState) _then) = __$RemindersStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<Reminder> reminders, bool notificationsDenied, Failure? failure
});




}
/// @nodoc
class __$RemindersStateCopyWithImpl<$Res>
    implements _$RemindersStateCopyWith<$Res> {
  __$RemindersStateCopyWithImpl(this._self, this._then);

  final _RemindersState _self;
  final $Res Function(_RemindersState) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reminders = null,Object? notificationsDenied = null,Object? failure = freezed,}) {
  return _then(_RemindersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,notificationsDenied: null == notificationsDenied ? _self.notificationsDenied : notificationsDenied // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
