// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 ViewStatus get status; DashboardSummary? get summary;/// Achievements unlocked by the latest refresh.
 List<Achievement> get newlyUnlocked; Failure? get failure;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.newlyUnlocked, _this.newlyUnlocked)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as DashboardState;
  return Object.hash(runtimeType,_this.status,_this.summary,const DeepCollectionEquality().hash(_this.newlyUnlocked),_this.failure);
}

@override
String toString() {
  final _this = this as DashboardState;
  return 'DashboardState(status: ${_this.status}, summary: ${_this.summary}, newlyUnlocked: ${_this.newlyUnlocked}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, DashboardSummary? summary, List<Achievement> newlyUnlocked, Failure? failure
});


$DashboardSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? summary = freezed,Object? newlyUnlocked = null,Object? failure = freezed,}) {
  return _then(DashboardState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary?,newlyUnlocked: null == newlyUnlocked ? _self.newlyUnlocked : newlyUnlocked // ignore: cast_nullable_to_non_nullable
as List<Achievement>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $DashboardSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  DashboardSummary? summary,  List<Achievement> newlyUnlocked,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.status,_that.summary,_that.newlyUnlocked,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  DashboardSummary? summary,  List<Achievement> newlyUnlocked,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.status,_that.summary,_that.newlyUnlocked,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  DashboardSummary? summary,  List<Achievement> newlyUnlocked,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.status,_that.summary,_that.newlyUnlocked,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({this.status = ViewStatus.initial, this.summary,  List<Achievement> newlyUnlocked = const [], this.failure}): _newlyUnlocked = newlyUnlocked;
  

@override@JsonKey() final  ViewStatus status;
@override final  DashboardSummary? summary;
/// Achievements unlocked by the latest refresh.
 final  List<Achievement> _newlyUnlocked;
/// Achievements unlocked by the latest refresh.
@override@JsonKey() List<Achievement> get newlyUnlocked {
  if (_newlyUnlocked is EqualUnmodifiableListView) return _newlyUnlocked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newlyUnlocked);
}

@override final  Failure? failure;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.newlyUnlocked, _newlyUnlocked)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,summary,const DeepCollectionEquality().hash(_newlyUnlocked),failure);
}

@override
String toString() {
    return 'DashboardState(status: $status, summary: $summary, newlyUnlocked: $newlyUnlocked, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, DashboardSummary? summary, List<Achievement> newlyUnlocked, Failure? failure
});


@override $DashboardSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? summary = freezed,Object? newlyUnlocked = null,Object? failure = freezed,}) {
  return _then(_DashboardState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary?,newlyUnlocked: null == newlyUnlocked ? _self._newlyUnlocked : newlyUnlocked // ignore: cast_nullable_to_non_nullable
as List<Achievement>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $DashboardSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
