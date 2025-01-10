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
        return ActionButtonsWidget(
          onTapCreateRecipe: () => _onTapCreateRecipe(context),
          createRecipeEnabled: state.viewModel.isCreateRecipeEnabled,
          logEnabled: state.viewModel.isLogEnabled,
          onTapLogSelected: () => _onTapLogSelected(context),
          isLogLoading: state.viewModel.isLogLoading,
        );
      },
    );
  }

  void _onTapCreateRecipe(BuildContext context) {
    context.read<TakePhotoResultBloc>().add(const CreateRecipeEvent());
  }

  void _onTapLogSelected(BuildContext context) {
    context.read<TakePhotoResultBloc>().add(const DoLogEvent());
  }
}
