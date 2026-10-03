// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_sync_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthSyncState {

 bool get loaded; HealthAccessStatus get access;/// The user connected Health before. iOS never says whether read access
/// was granted, so this is what tells us to keep syncing.
 bool get wasConnected; bool get isSyncing; DateTime? get lastSync; HealthSyncReport? get report;/// Whole-history import state.
 bool get isImportingHistory; HealthHistoryProgress? get historyProgress; bool get historyComplete; DateTime? get historyOldest; Failure? get failure;
/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthSyncStateCopyWith<HealthSyncState> get copyWith => _$HealthSyncStateCopyWithImpl<HealthSyncState>(this as HealthSyncState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HealthSyncState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthSyncState&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.access, _this.access) || other.access == _this.access)&&(identical(other.wasConnected, _this.wasConnected) || other.wasConnected == _this.wasConnected)&&(identical(other.isSyncing, _this.isSyncing) || other.isSyncing == _this.isSyncing)&&(identical(other.lastSync, _this.lastSync) || other.lastSync == _this.lastSync)&&(identical(other.report, _this.report) || other.report == _this.report)&&(identical(other.isImportingHistory, _this.isImportingHistory) || other.isImportingHistory == _this.isImportingHistory)&&(identical(other.historyProgress, _this.historyProgress) || other.historyProgress == _this.historyProgress)&&(identical(other.historyComplete, _this.historyComplete) || other.historyComplete == _this.historyComplete)&&(identical(other.historyOldest, _this.historyOldest) || other.historyOldest == _this.historyOldest)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as HealthSyncState;
  return Object.hash(runtimeType,_this.loaded,_this.access,_this.wasConnected,_this.isSyncing,_this.lastSync,_this.report,_this.isImportingHistory,_this.historyProgress,_this.historyComplete,_this.historyOldest,_this.failure);
}

@override
String toString() {
  final _this = this as HealthSyncState;
  return 'HealthSyncState(loaded: ${_this.loaded}, access: ${_this.access}, wasConnected: ${_this.wasConnected}, isSyncing: ${_this.isSyncing}, lastSync: ${_this.lastSync}, report: ${_this.report}, isImportingHistory: ${_this.isImportingHistory}, historyProgress: ${_this.historyProgress}, historyComplete: ${_this.historyComplete}, historyOldest: ${_this.historyOldest}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $HealthSyncStateCopyWith<$Res>  {
  factory $HealthSyncStateCopyWith(HealthSyncState value, $Res Function(HealthSyncState) _then) = _$HealthSyncStateCopyWithImpl;
@useResult
$Res call({
 bool loaded, HealthAccessStatus access, bool wasConnected, bool isSyncing, DateTime? lastSync, HealthSyncReport? report, bool isImportingHistory, HealthHistoryProgress? historyProgress, bool historyComplete, DateTime? historyOldest, Failure? failure
});




}
/// @nodoc
class _$HealthSyncStateCopyWithImpl<$Res>
    implements $HealthSyncStateCopyWith<$Res> {
  _$HealthSyncStateCopyWithImpl(this._self, this._then);

  final HealthSyncState _self;
  final $Res Function(HealthSyncState) _then;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? access = null,Object? wasConnected = null,Object? isSyncing = null,Object? lastSync = freezed,Object? report = freezed,Object? isImportingHistory = null,Object? historyProgress = freezed,Object? historyComplete = null,Object? historyOldest = freezed,Object? failure = freezed,}) {
  return _then(HealthSyncState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,wasConnected: null == wasConnected ? _self.wasConnected : wasConnected // ignore: cast_nullable_to_non_nullable
as bool,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as HealthSyncReport?,isImportingHistory: null == isImportingHistory ? _self.isImportingHistory : isImportingHistory // ignore: cast_nullable_to_non_nullable
as bool,historyProgress: freezed == historyProgress ? _self.historyProgress : historyProgress // ignore: cast_nullable_to_non_nullable
as HealthHistoryProgress?,historyComplete: null == historyComplete ? _self.historyComplete : historyComplete // ignore: cast_nullable_to_non_nullable
as bool,historyOldest: freezed == historyOldest ? _self.historyOldest : historyOldest // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthSyncState].
extension HealthSyncStatePatterns on HealthSyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthSyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthSyncState value)  $default,){
final _that = this;
switch (_that) {
case _HealthSyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthSyncState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loaded,  HealthAccessStatus access,  bool wasConnected,  bool isSyncing,  DateTime? lastSync,  HealthSyncReport? report,  bool isImportingHistory,  HealthHistoryProgress? historyProgress,  bool historyComplete,  DateTime? historyOldest,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
return $default(_that.loaded,_that.access,_that.wasConnected,_that.isSyncing,_that.lastSync,_that.report,_that.isImportingHistory,_that.historyProgress,_that.historyComplete,_that.historyOldest,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loaded,  HealthAccessStatus access,  bool wasConnected,  bool isSyncing,  DateTime? lastSync,  HealthSyncReport? report,  bool isImportingHistory,  HealthHistoryProgress? historyProgress,  bool historyComplete,  DateTime? historyOldest,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _HealthSyncState():
return $default(_that.loaded,_that.access,_that.wasConnected,_that.isSyncing,_that.lastSync,_that.report,_that.isImportingHistory,_that.historyProgress,_that.historyComplete,_that.historyOldest,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loaded,  HealthAccessStatus access,  bool wasConnected,  bool isSyncing,  DateTime? lastSync,  HealthSyncReport? report,  bool isImportingHistory,  HealthHistoryProgress? historyProgress,  bool historyComplete,  DateTime? historyOldest,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _HealthSyncState() when $default != null:
return $default(_that.loaded,_that.access,_that.wasConnected,_that.isSyncing,_that.lastSync,_that.report,_that.isImportingHistory,_that.historyProgress,_that.historyComplete,_that.historyOldest,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _HealthSyncState extends HealthSyncState {
  const _HealthSyncState({this.loaded = false, this.access = HealthAccessStatus.unknown, this.wasConnected = false, this.isSyncing = false, this.lastSync, this.report, this.isImportingHistory = false, this.historyProgress, this.historyComplete = false, this.historyOldest, this.failure}): super._();
  

@override@JsonKey() final  bool loaded;
@override@JsonKey() final  HealthAccessStatus access;
/// The user connected Health before. iOS never says whether read access
/// was granted, so this is what tells us to keep syncing.
@override@JsonKey() final  bool wasConnected;
@override@JsonKey() final  bool isSyncing;
@override final  DateTime? lastSync;
@override final  HealthSyncReport? report;
/// Whole-history import state.
@override@JsonKey() final  bool isImportingHistory;
@override final  HealthHistoryProgress? historyProgress;
@override@JsonKey() final  bool historyComplete;
@override final  DateTime? historyOldest;
@override final  Failure? failure;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthSyncStateCopyWith<_HealthSyncState> get copyWith => __$HealthSyncStateCopyWithImpl<_HealthSyncState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthSyncState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.access, access) || other.access == access)&&(identical(other.wasConnected, wasConnected) || other.wasConnected == wasConnected)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&(identical(other.report, report) || other.report == report)&&(identical(other.isImportingHistory, isImportingHistory) || other.isImportingHistory == isImportingHistory)&&(identical(other.historyProgress, historyProgress) || other.historyProgress == historyProgress)&&(identical(other.historyComplete, historyComplete) || other.historyComplete == historyComplete)&&(identical(other.historyOldest, historyOldest) || other.historyOldest == historyOldest)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loaded,access,wasConnected,isSyncing,lastSync,report,isImportingHistory,historyProgress,historyComplete,historyOldest,failure);
}

@override
String toString() {
    return 'HealthSyncState(loaded: $loaded, access: $access, wasConnected: $wasConnected, isSyncing: $isSyncing, lastSync: $lastSync, report: $report, isImportingHistory: $isImportingHistory, historyProgress: $historyProgress, historyComplete: $historyComplete, historyOldest: $historyOldest, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$HealthSyncStateCopyWith<$Res> implements $HealthSyncStateCopyWith<$Res> {
  factory _$HealthSyncStateCopyWith(_HealthSyncState value, $Res Function(_HealthSyncState) _then) = __$HealthSyncStateCopyWithImpl;
@override @useResult
$Res call({
 bool loaded, HealthAccessStatus access, bool wasConnected, bool isSyncing, DateTime? lastSync, HealthSyncReport? report, bool isImportingHistory, HealthHistoryProgress? historyProgress, bool historyComplete, DateTime? historyOldest, Failure? failure
});




}
/// @nodoc
class __$HealthSyncStateCopyWithImpl<$Res>
    implements _$HealthSyncStateCopyWith<$Res> {
  __$HealthSyncStateCopyWithImpl(this._self, this._then);

  final _HealthSyncState _self;
  final $Res Function(_HealthSyncState) _then;

/// Create a copy of HealthSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? access = null,Object? wasConnected = null,Object? isSyncing = null,Object? lastSync = freezed,Object? report = freezed,Object? isImportingHistory = null,Object? historyProgress = freezed,Object? historyComplete = null,Object? historyOldest = freezed,Object? failure = freezed,}) {
  return _then(_HealthSyncState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,wasConnected: null == wasConnected ? _self.wasConnected : wasConnected // ignore: cast_nullable_to_non_nullable
as bool,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as HealthSyncReport?,isImportingHistory: null == isImportingHistory ? _self.isImportingHistory : isImportingHistory // ignore: cast_nullable_to_non_nullable
as bool,historyProgress: freezed == historyProgress ? _self.historyProgress : historyProgress // ignore: cast_nullable_to_non_nullable
as HealthHistoryProgress?,historyComplete: null == historyComplete ? _self.historyComplete : historyComplete // ignore: cast_nullable_to_non_nullable
as bool,historyOldest: freezed == historyOldest ? _self.historyOldest : historyOldest // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
