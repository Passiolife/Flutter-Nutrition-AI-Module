import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/extension/context_extension.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../../../common/widgets/edit_nutrition_facts/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({this.positiveButtonText, this.onPositiveTap, this.onNegativeTap, super.key});
  final VoidCallback? onPositiveTap;
  final String? positiveButtonText;
  final  VoidCallback? onNegativeTap;

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
          positiveText: positiveButtonText ?? context.localization.save,
          onCancel: () async{
            onNegativeTap?.call();
            Navigator.pop(context);
          },
          onPositiveTap: onPositiveTap,
        );
      },
    );
  }
}
