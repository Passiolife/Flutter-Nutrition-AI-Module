part of 'search_bloc.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(<PassioFoodDataInfo>[]) List<PassioFoodDataInfo> results,
    @Default(<String>[]) List<String> alternatives,
  }) = InitialState;
}