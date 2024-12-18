import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../bloc/food_search_bloc.dart';
import '../widgets/alternative_list_widget.dart';

class AlternativeSection extends StatelessWidget {
  const AlternativeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final alternatives = context.watch<FoodSearchBloc>().alternatives;
    if (alternatives.isNotEmpty) {
      return Padding(
        padding: AppPadding.pt16,
        child: AlternativeListWidget(
          alternatives: alternatives,
          onSelectAlternative: (alternative) => _onSelectAlternative(context: context, alternative: alternative),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _onSelectAlternative({required BuildContext context, required String alternative}) {
    context.read<FoodSearchBloc>().add(DoUpdateSearchEvent(searchText: alternative));
  }
}
