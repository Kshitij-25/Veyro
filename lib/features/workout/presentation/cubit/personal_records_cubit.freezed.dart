// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_records_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalRecordsState {

 ViewStatus get status; List<PersonalRecord> get records; Failure? get failure;
/// Create a copy of PersonalRecordsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalRecordsStateCopyWith<PersonalRecordsState> get copyWith => _$PersonalRecordsStateCopyWithImpl<PersonalRecordsState>(this as PersonalRecordsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PersonalRecordsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalRecordsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.records, _this.records)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as PersonalRecordsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.records),_this.failure);
}

@override
String toString() {
  final _this = this as PersonalRecordsState;
  return 'PersonalRecordsState(status: ${_this.status}, records: ${_this.records}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $PersonalRecordsStateCopyWith<$Res>  {
  factory $PersonalRecordsStateCopyWith(PersonalRecordsState value, $Res Function(PersonalRecordsState) _then) = _$PersonalRecordsStateCopyWithImpl;
@useResult
$Res call({
 ViewStatus status, List<PersonalRecord> records, Failure? failure
});




}
/// @nodoc
class _$PersonalRecordsStateCopyWithImpl<$Res>
    implements $PersonalRecordsStateCopyWith<$Res> {
  _$PersonalRecordsStateCopyWithImpl(this._self, this._then);

  final PersonalRecordsState _self;
  final $Res Function(PersonalRecordsState) _then;

/// Create a copy of PersonalRecordsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? records = null,Object? failure = freezed,}) {
  return _then(PersonalRecordsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<PersonalRecord>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalRecordsState].
extension PersonalRecordsStatePatterns on PersonalRecordsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalRecordsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalRecordsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalRecordsState value)  $default,){
final _that = this;
switch (_that) {
case _PersonalRecordsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalRecordsState value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalRecordsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewStatus status,  List<PersonalRecord> records,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalRecordsState() when $default != null:
return $default(_that.status,_that.records,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewStatus status,  List<PersonalRecord> records,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PersonalRecordsState():
return $default(_that.status,_that.records,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewStatus status,  List<PersonalRecord> records,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PersonalRecordsState() when $default != null:
return $default(_that.status,_that.records,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalRecordsState implements PersonalRecordsState {
  const _PersonalRecordsState({this.status = ViewStatus.initial,  List<PersonalRecord> records = const [], this.failure}): _records = records;
  

@override@JsonKey() final  ViewStatus status;
 final  List<PersonalRecord> _records;
@override@JsonKey() List<PersonalRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override final  Failure? failure;

/// Create a copy of PersonalRecordsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalRecordsStateCopyWith<_PersonalRecordsState> get copyWith => __$PersonalRecordsStateCopyWithImpl<_PersonalRecordsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalRecordsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.records, _records)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_records),failure);
}

@override
String toString() {
    return 'PersonalRecordsState(status: $status, records: $records, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PersonalRecordsStateCopyWith<$Res> implements $PersonalRecordsStateCopyWith<$Res> {
  factory _$PersonalRecordsStateCopyWith(_PersonalRecordsState value, $Res Function(_PersonalRecordsState) _then) = __$PersonalRecordsStateCopyWithImpl;
@override @useResult
$Res call({
 ViewStatus status, List<PersonalRecord> records, Failure? failure
});




}
/// @nodoc
class __$PersonalRecordsStateCopyWithImpl<$Res>
    implements _$PersonalRecordsStateCopyWith<$Res> {
  __$PersonalRecordsStateCopyWithImpl(this._self, this._then);

  final _PersonalRecordsState _self;
  final $Res Function(_PersonalRecordsState) _then;

/// Create a copy of PersonalRecordsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? records = null,Object? failure = freezed,}) {
  return _then(_PersonalRecordsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewStatus,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<PersonalRecord>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
