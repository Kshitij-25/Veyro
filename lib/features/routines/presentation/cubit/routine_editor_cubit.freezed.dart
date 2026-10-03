// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoutineEditorState {

 ViewStatus get status; RoutineDraft get draft; bool get isSaving; bool get saved; Failure? get failure;
/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineEditorStateCopyWith<RoutineEditorState> get copyWith => _$RoutineEditorStateCopyWithImpl<RoutineEditorState>(this as RoutineEditorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoutineEditorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineEditorState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RoutineEditorState;
  return Object.hash(runtimeType,_this.status,_this.draft,_this.isSaving,_this.saved,_this.failure);
}

@override
String toString() {
  final _this = this as RoutineEditorState;
  return 'RoutineEditorState(status: ${_this.status}, draft: ${_this.draft}, isSaving: ${_this.isSaving}, saved: ${_this.saved}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RoutineEditorStateCopyWith<$Res>  {
  factory $RoutineEditorStateCopyWith(RoutineEditorState value, $Res Function(RoutineEditorState) _then) = _$RoutineEditorStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, RoutineDraft draft, bool isSaving, bool saved, Failure? failure
});


$RoutineDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$RoutineEditorStateCopyWithImpl<$Res>
    implements $RoutineEditorStateCopyWith<$Res> {
  _$RoutineEditorStateCopyWithImpl(this._self, this._then);

  final RoutineEditorState _self;
  final $Res Function(RoutineEditorState) _then;

/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? draft = null,Object? isSaving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(RoutineEditorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as RoutineDraft,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoutineDraftCopyWith<$Res> get draft {
  
  return $RoutineDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoutineEditorState].
extension RoutineEditorStatePatterns on RoutineEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineEditorState value)  $default,){
final _that = this;
switch (_that) {
case _RoutineEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  RoutineDraft draft,  bool isSaving,  bool saved,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineEditorState() when $default != null:
return $default(_that.status,_that.draft,_that.isSaving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  RoutineDraft draft,  bool isSaving,  bool saved,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RoutineEditorState():
return $default(_that.status,_that.draft,_that.isSaving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  RoutineDraft draft,  bool isSaving,  bool saved,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RoutineEditorState() when $default != null:
return $default(_that.status,_that.draft,_that.isSaving,_that.saved,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RoutineEditorState implements RoutineEditorState {
  const _RoutineEditorState({this.status = ViewStatus.success, this.draft = const RoutineDraft(), this.isSaving = false, this.saved = false, this.failure});
  

@override@JsonKey() final  ViewStatus status;
@override@JsonKey() final  RoutineDraft draft;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool saved;
@override final  Failure? failure;

/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineEditorStateCopyWith<_RoutineEditorState> get copyWith => __$RoutineEditorStateCopyWithImpl<_RoutineEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineEditorState&&(identical(other.status, status) || other.status == status)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,draft,isSaving,saved,failure);
}

@override
String toString() {
    return 'RoutineEditorState(status: $status, draft: $draft, isSaving: $isSaving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RoutineEditorStateCopyWith<$Res> implements $RoutineEditorStateCopyWith<$Res> {
  factory _$RoutineEditorStateCopyWith(_RoutineEditorState value, $Res Function(_RoutineEditorState) _then) = __$RoutineEditorStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, RoutineDraft draft, bool isSaving, bool saved, Failure? failure
});


@override $RoutineDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$RoutineEditorStateCopyWithImpl<$Res>
    implements _$RoutineEditorStateCopyWith<$Res> {
  __$RoutineEditorStateCopyWithImpl(this._self, this._then);

  final _RoutineEditorState _self;
  final $Res Function(_RoutineEditorState) _then;

/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? draft = null,Object? isSaving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_RoutineEditorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as RoutineDraft,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of RoutineEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoutineDraftCopyWith<$Res> get draft {
  
  return $RoutineDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
