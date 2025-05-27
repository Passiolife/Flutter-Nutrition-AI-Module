part of 'search_bloc.dart';

@freezed
abstract class SearchEvent with _$SearchEvent{
  const factory SearchEvent.doSearch({
    required String searchText,
  }) = DoSearchEvent;
}