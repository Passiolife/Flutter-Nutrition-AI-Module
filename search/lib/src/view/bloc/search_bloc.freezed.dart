// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {

 String get searchText;
/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchEventCopyWith<SearchEvent> get copyWith => _$SearchEventCopyWithImpl<SearchEvent>(this as SearchEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent&&(identical(other.searchText, searchText) || other.searchText == searchText));
}


@override
int get hashCode => Object.hash(runtimeType,searchText);

@override
String toString() {
  return 'SearchEvent(searchText: $searchText)';
}


}

/// @nodoc
abstract mixin class $SearchEventCopyWith<$Res>  {
  factory $SearchEventCopyWith(SearchEvent value, $Res Function(SearchEvent) _then) = _$SearchEventCopyWithImpl;
@useResult
$Res call({
 String searchText
});




}
/// @nodoc
class _$SearchEventCopyWithImpl<$Res>
    implements $SearchEventCopyWith<$Res> {
  _$SearchEventCopyWithImpl(this._self, this._then);

  final SearchEvent _self;
  final $Res Function(SearchEvent) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchText = null,}) {
  return _then(_self.copyWith(
searchText: null == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class DoSearchEvent implements SearchEvent {
  const DoSearchEvent({required this.searchText});
  

@override final  String searchText;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoSearchEventCopyWith<DoSearchEvent> get copyWith => _$DoSearchEventCopyWithImpl<DoSearchEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoSearchEvent&&(identical(other.searchText, searchText) || other.searchText == searchText));
}


@override
int get hashCode => Object.hash(runtimeType,searchText);

@override
String toString() {
  return 'SearchEvent.doSearch(searchText: $searchText)';
}


}

/// @nodoc
abstract mixin class $DoSearchEventCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $DoSearchEventCopyWith(DoSearchEvent value, $Res Function(DoSearchEvent) _then) = _$DoSearchEventCopyWithImpl;
@override @useResult
$Res call({
 String searchText
});




}
/// @nodoc
class _$DoSearchEventCopyWithImpl<$Res>
    implements $DoSearchEventCopyWith<$Res> {
  _$DoSearchEventCopyWithImpl(this._self, this._then);

  final DoSearchEvent _self;
  final $Res Function(DoSearchEvent) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchText = null,}) {
  return _then(DoSearchEvent(
searchText: null == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SearchState {

 List<PassioFoodDataInfo> get results; List<String> get alternatives;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&const DeepCollectionEquality().equals(other.results, results)&&const DeepCollectionEquality().equals(other.alternatives, alternatives));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),const DeepCollectionEquality().hash(alternatives));

@override
String toString() {
  return 'SearchState(results: $results, alternatives: $alternatives)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 List<PassioFoodDataInfo> results, List<String> alternatives
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? alternatives = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<PassioFoodDataInfo>,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc


class InitialState implements SearchState {
  const InitialState({final  List<PassioFoodDataInfo> results = const <PassioFoodDataInfo>[], final  List<String> alternatives = const <String>[]}): _results = results,_alternatives = alternatives;
  

 final  List<PassioFoodDataInfo> _results;
@override@JsonKey() List<PassioFoodDataInfo> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<String> _alternatives;
@override@JsonKey() List<String> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialStateCopyWith<InitialState> get copyWith => _$InitialStateCopyWithImpl<InitialState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialState&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_alternatives));

@override
String toString() {
  return 'SearchState(results: $results, alternatives: $alternatives)';
}


}

/// @nodoc
abstract mixin class $InitialStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $InitialStateCopyWith(InitialState value, $Res Function(InitialState) _then) = _$InitialStateCopyWithImpl;
@override @useResult
$Res call({
 List<PassioFoodDataInfo> results, List<String> alternatives
});




}
/// @nodoc
class _$InitialStateCopyWithImpl<$Res>
    implements $InitialStateCopyWith<$Res> {
  _$InitialStateCopyWithImpl(this._self, this._then);

  final InitialState _self;
  final $Res Function(InitialState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? alternatives = null,}) {
  return _then(InitialState(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<PassioFoodDataInfo>,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
