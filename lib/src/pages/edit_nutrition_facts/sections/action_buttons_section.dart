import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/router/routes.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../models/edit_nutrition_facts_navigation_data_provider.dart';
import '../widgets/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection(
      {this.positiveButtonText,
      this.onPositiveTap,
      this.onNegativeTap,
      super.key});

  final VoidCallback? onPositiveTap;
  final String? positiveButtonText;
  final VoidCallback? onNegativeTap;

  String? getRouteName(BuildContext context) {
    return EditNutritionFactsNavigationDataProvider.of(context).routeName;
  }

  String getPositiveButtonText(BuildContext context, bool isUpdate) {
    if (positiveButtonText != null) {
      return positiveButtonText!;
    }
    String? routeName = getRouteName(context);
    if (routeName.isNotNullOrEmpty == true) {
      if(routeName == Routes.photoPreview) {
        return isUpdate ? context.localization.updateAndLog : context
            .localization.saveAndLog;
      }
    }

    return isUpdate ? context.localization.update : context.localization.save;
  }

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
          positiveText: getPositiveButtonText(context, isUpdate),
          onCancel: () async {
            onNegativeTap?.call();
            Navigator.pop(context);
          },
          onPositiveTap: onPositiveTap,
        );
      },
    );
  }
}
