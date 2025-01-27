import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/extension/context_extension.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../widgets/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({this.onPositiveTap, super.key});
  final VoidCallback? onPositiveTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
      buildWhen: (_, state) {
        return state is RefreshActionButtonsState;
      },
      builder: (context, state) {
        bool isUpdate = false;
        if (state is RefreshActionButtonsState) {
          isUpdate = state.isUpdate;
        }
        return ActionButtonsWidget(
          positiveText: isUpdate ? context.localization.updateAndLog : context.localization.saveAndLog,
          onCancel: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onPositiveTap: onPositiveTap,
        );
      },
    );
  }
}
