import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_search_bloc.dart';
import '../widgets/keep_typing_widget.dart';

class KeepTypingSection extends StatelessWidget {
  const KeepTypingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSearchBloc, FoodSearchState>(
      builder: (context, state) {
        return state is KeepTypingState
            ? const KeepTypingWidget()
            : const SizedBox.shrink();
      },
    );
  }
}
