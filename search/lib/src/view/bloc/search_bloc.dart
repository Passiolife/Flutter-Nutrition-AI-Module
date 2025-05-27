import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const InitialState()) {
    on<DoSearchEvent>(_onDoSearch);
  }

  FutureOr<void> _onDoSearch(
    DoSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    final searchText = event.searchText;

    if (searchText.isEmpty) {
      emit(const InitialState());
      // return;
    }

    // final results = PassioConnector.instance.searchFood(searchText);
    // final alternatives = PassioConnector.instance.getSearchAlternatives(searchText);
    //
    // emit(SearchState(results: results, alternatives: alternatives));
  }
}
