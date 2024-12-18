import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_search_bloc.dart';
import '../widgets/search_widget.dart';

class SearchAppBarSection extends StatelessWidget {
  const SearchAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSearchBloc, FoodSearchState>(
      buildWhen: (_, state) => state is UpdateSearchState,
      builder: (context, state) {
        final initialText = state is UpdateSearchState ? (state).searchText : null;
        return SearchWidget(
          onChange: (term) => _onChange(context: context, term: term),
          initialText: initialText,
        );
      },
    );
  }

  void _onChange({required BuildContext context, required String term}) {
    context.read<FoodSearchBloc>().add(DoFoodSearchEvent(searchText: term));
  }
}
