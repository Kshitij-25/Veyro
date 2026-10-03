// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_catalog_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodCatalogState {

 String get query; bool get isSearching;/// Results for [query]; empty when the query is empty.
 List<CatalogFood> get results;/// Online sources that couldn't be reached for the last search.
 List<String> get unreachable; List<CatalogFood> get recents; List<CatalogFood> get favorites; List<CatalogFood> get mine; Failure? get failure;
/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCatalogStateCopyWith<FoodCatalogState> get copyWith => _$FoodCatalogStateCopyWithImpl<FoodCatalogState>(this as FoodCatalogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodCatalogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodCatalogState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isSearching, _this.isSearching) || other.isSearching == _this.isSearching)&&const DeepCollectionEquality().equals(other.results, _this.results)&&const DeepCollectionEquality().equals(other.unreachable, _this.unreachable)&&const DeepCollectionEquality().equals(other.recents, _this.recents)&&const DeepCollectionEquality().equals(other.favorites, _this.favorites)&&const DeepCollectionEquality().equals(other.mine, _this.mine)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as FoodCatalogState;
  return Object.hash(runtimeType,_this.query,_this.isSearching,const DeepCollectionEquality().hash(_this.results),const DeepCollectionEquality().hash(_this.unreachable),const DeepCollectionEquality().hash(_this.recents),const DeepCollectionEquality().hash(_this.favorites),const DeepCollectionEquality().hash(_this.mine),_this.failure);
}

@override
String toString() {
  final _this = this as FoodCatalogState;
  return 'FoodCatalogState(query: ${_this.query}, isSearching: ${_this.isSearching}, results: ${_this.results}, unreachable: ${_this.unreachable}, recents: ${_this.recents}, favorites: ${_this.favorites}, mine: ${_this.mine}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $FoodCatalogStateCopyWith<$Res>  {
  factory $FoodCatalogStateCopyWith(FoodCatalogState value, $Res Function(FoodCatalogState) _then) = _$FoodCatalogStateCopyWithImpl;
@useResult
$Res call({
 String query, bool isSearching, List<CatalogFood> results, List<String> unreachable, List<CatalogFood> recents, List<CatalogFood> favorites, List<CatalogFood> mine, Failure? failure
});




}
/// @nodoc
class _$FoodCatalogStateCopyWithImpl<$Res>
    implements $FoodCatalogStateCopyWith<$Res> {
  _$FoodCatalogStateCopyWithImpl(this._self, this._then);

  final FoodCatalogState _self;
  final $Res Function(FoodCatalogState) _then;

/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? isSearching = null,Object? results = null,Object? unreachable = null,Object? recents = null,Object? favorites = null,Object? mine = null,Object? failure = freezed,}) {
  return _then(FoodCatalogState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,unreachable: null == unreachable ? _self.unreachable : unreachable // ignore: cast_nullable_to_non_nullable
as List<String>,recents: null == recents ? _self.recents : recents // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodCatalogState].
extension FoodCatalogStatePatterns on FoodCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _FoodCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  bool isSearching,  List<CatalogFood> results,  List<String> unreachable,  List<CatalogFood> recents,  List<CatalogFood> favorites,  List<CatalogFood> mine,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
return $default(_that.query,_that.isSearching,_that.results,_that.unreachable,_that.recents,_that.favorites,_that.mine,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  bool isSearching,  List<CatalogFood> results,  List<String> unreachable,  List<CatalogFood> recents,  List<CatalogFood> favorites,  List<CatalogFood> mine,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FoodCatalogState():
return $default(_that.query,_that.isSearching,_that.results,_that.unreachable,_that.recents,_that.favorites,_that.mine,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  bool isSearching,  List<CatalogFood> results,  List<String> unreachable,  List<CatalogFood> recents,  List<CatalogFood> favorites,  List<CatalogFood> mine,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
return $default(_that.query,_that.isSearching,_that.results,_that.unreachable,_that.recents,_that.favorites,_that.mine,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FoodCatalogState implements FoodCatalogState {
  const _FoodCatalogState({this.query = '', this.isSearching = false,  List<CatalogFood> results = const [],  List<String> unreachable = const [],  List<CatalogFood> recents = const [],  List<CatalogFood> favorites = const [],  List<CatalogFood> mine = const [], this.failure}): _results = results,_unreachable = unreachable,_recents = recents,_favorites = favorites,_mine = mine;
  

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;
/// Results for [query]; empty when the query is empty.
 final  List<CatalogFood> _results;
/// Results for [query]; empty when the query is empty.
@override@JsonKey() List<CatalogFood> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

/// Online sources that couldn't be reached for the last search.
 final  List<String> _unreachable;
/// Online sources that couldn't be reached for the last search.
@override@JsonKey() List<String> get unreachable {
  if (_unreachable is EqualUnmodifiableListView) return _unreachable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unreachable);
}

 final  List<CatalogFood> _recents;
@override@JsonKey() List<CatalogFood> get recents {
  if (_recents is EqualUnmodifiableListView) return _recents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recents);
}

 final  List<CatalogFood> _favorites;
@override@JsonKey() List<CatalogFood> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

 final  List<CatalogFood> _mine;
@override@JsonKey() List<CatalogFood> get mine {
  if (_mine is EqualUnmodifiableListView) return _mine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mine);
}

@override final  Failure? failure;

/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCatalogStateCopyWith<_FoodCatalogState> get copyWith => __$FoodCatalogStateCopyWithImpl<_FoodCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodCatalogState&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other.results, _results)&&const DeepCollectionEquality().equals(other.unreachable, _unreachable)&&const DeepCollectionEquality().equals(other.recents, _recents)&&const DeepCollectionEquality().equals(other.favorites, _favorites)&&const DeepCollectionEquality().equals(other.mine, _mine)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,isSearching,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_unreachable),const DeepCollectionEquality().hash(_recents),const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_mine),failure);
}

@override
String toString() {
    return 'FoodCatalogState(query: $query, isSearching: $isSearching, results: $results, unreachable: $unreachable, recents: $recents, favorites: $favorites, mine: $mine, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FoodCatalogStateCopyWith<$Res> implements $FoodCatalogStateCopyWith<$Res> {
  factory _$FoodCatalogStateCopyWith(_FoodCatalogState value, $Res Function(_FoodCatalogState) _then) = __$FoodCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 String query, bool isSearching, List<CatalogFood> results, List<String> unreachable, List<CatalogFood> recents, List<CatalogFood> favorites, List<CatalogFood> mine, Failure? failure
});




}
/// @nodoc
class __$FoodCatalogStateCopyWithImpl<$Res>
    implements _$FoodCatalogStateCopyWith<$Res> {
  __$FoodCatalogStateCopyWithImpl(this._self, this._then);

  final _FoodCatalogState _self;
  final $Res Function(_FoodCatalogState) _then;

/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? isSearching = null,Object? results = null,Object? unreachable = null,Object? recents = null,Object? favorites = null,Object? mine = null,Object? failure = freezed,}) {
  return _then(_FoodCatalogState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,unreachable: null == unreachable ? _self._unreachable : unreachable // ignore: cast_nullable_to_non_nullable
as List<String>,recents: null == recents ? _self._recents : recents // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,mine: null == mine ? _self._mine : mine // ignore: cast_nullable_to_non_nullable
as List<CatalogFood>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
