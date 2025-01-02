import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/take_photo_result_bloc.dart';
import '../widgets/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial ||
            state is UpdateActionButtonsState;
      },
      builder: (context, state) {
        if (state is! UpdateActionButtonsState) return const SizedBox.shrink();
        final logEnabled = state.logEnabled;
        final createRecipeEnabled = state.createRecipeEnabled;
        return ActionButtonsWidget(
          onTapCreateRecipe: () {},
          createRecipeEnabled: createRecipeEnabled,
          logEnabled: logEnabled,
          onTapLogSelected: () {},
        );
      },
    );
  }
}
