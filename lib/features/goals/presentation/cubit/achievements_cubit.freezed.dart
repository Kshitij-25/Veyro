// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievements_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AchievementsState {

 ViewStatus get status; List<Achievement> get achievements;/// Unlocked by the latest evaluation, so the UI can celebrate them.
 List<Achievement> get newlyUnlocked; Failure? get failure;
/// Create a copy of AchievementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementsStateCopyWith<AchievementsState> get copyWith => _$AchievementsStateCopyWithImpl<AchievementsState>(this as AchievementsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AchievementsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AchievementsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.achievements, _this.achievements)&&const DeepCollectionEquality().equals(other.newlyUnlocked, _this.newlyUnlocked)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as AchievementsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.achievements),const DeepCollectionEquality().hash(_this.newlyUnlocked),_this.failure);
}

@override
String toString() {
  final _this = this as AchievementsState;
  return 'AchievementsState(status: ${_this.status}, achievements: ${_this.achievements}, newlyUnlocked: ${_this.newlyUnlocked}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $AchievementsStateCopyWith<$Res>  {
  factory $AchievementsStateCopyWith(AchievementsState value, $Res Function(AchievementsState) _then) = _$AchievementsStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<Achievement> achievements, List<Achievement> newlyUnlocked, Failure? failure
});




}
/// @nodoc
class _$AchievementsStateCopyWithImpl<$Res>
    implements $AchievementsStateCopyWith<$Res> {
  _$AchievementsStateCopyWithImpl(this._self, this._then);

  final AchievementsState _self;
  final $Res Function(AchievementsState) _then;

/// Create a copy of AchievementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? achievements = null,Object? newlyUnlocked = null,Object? failure = freezed,}) {
  return _then(AchievementsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<Achievement>,newlyUnlocked: null == newlyUnlocked ? _self.newlyUnlocked : newlyUnlocked // ignore: cast_nullable_to_non_nullable
as List<Achievement>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AchievementsState].
extension AchievementsStatePatterns on AchievementsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AchievementsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AchievementsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AchievementsState value)  $default,){
final _that = this;
switch (_that) {
case _AchievementsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AchievementsState value)?  $default,){
final _that = this;
switch (_that) {
case _AchievementsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<Achievement> achievements,  List<Achievement> newlyUnlocked,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AchievementsState() when $default != null:
return $default(_that.status,_that.achievements,_that.newlyUnlocked,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<Achievement> achievements,  List<Achievement> newlyUnlocked,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AchievementsState():
return $default(_that.status,_that.achievements,_that.newlyUnlocked,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<Achievement> achievements,  List<Achievement> newlyUnlocked,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AchievementsState() when $default != null:
return $default(_that.status,_that.achievements,_that.newlyUnlocked,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AchievementsState implements AchievementsState {
  const _AchievementsState({this.status = ViewStatus.initial,  List<Achievement> achievements = const [],  List<Achievement> newlyUnlocked = const [], this.failure}): _achievements = achievements,_newlyUnlocked = newlyUnlocked;
  

@override@JsonKey() final  ViewStatus status;
 final  List<Achievement> _achievements;
@override@JsonKey() List<Achievement> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}

/// Unlocked by the latest evaluation, so the UI can celebrate them.
 final  List<Achievement> _newlyUnlocked;
/// Unlocked by the latest evaluation, so the UI can celebrate them.
@override@JsonKey() List<Achievement> get newlyUnlocked {
  if (_newlyUnlocked is EqualUnmodifiableListView) return _newlyUnlocked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newlyUnlocked);
}

@override final  Failure? failure;

/// Create a copy of AchievementsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementsStateCopyWith<_AchievementsState> get copyWith => __$AchievementsStateCopyWithImpl<_AchievementsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AchievementsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.achievements, _achievements)&&const DeepCollectionEquality().equals(other.newlyUnlocked, _newlyUnlocked)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_achievements),const DeepCollectionEquality().hash(_newlyUnlocked),failure);
}

@override
String toString() {
    return 'AchievementsState(status: $status, achievements: $achievements, newlyUnlocked: $newlyUnlocked, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AchievementsStateCopyWith<$Res> implements $AchievementsStateCopyWith<$Res> {
  factory _$AchievementsStateCopyWith(_AchievementsState value, $Res Function(_AchievementsState) _then) = __$AchievementsStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<Achievement> achievements, List<Achievement> newlyUnlocked, Failure? failure
});




}
/// @nodoc
class __$AchievementsStateCopyWithImpl<$Res>
    implements _$AchievementsStateCopyWith<$Res> {
  __$AchievementsStateCopyWithImpl(this._self, this._then);

  final _AchievementsState _self;
  final $Res Function(_AchievementsState) _then;

/// Create a copy of AchievementsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? achievements = null,Object? newlyUnlocked = null,Object? failure = freezed,}) {
  return _then(_AchievementsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<Achievement>,newlyUnlocked: null == newlyUnlocked ? _self._newlyUnlocked : newlyUnlocked // ignore: cast_nullable_to_non_nullable
as List<Achievement>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
