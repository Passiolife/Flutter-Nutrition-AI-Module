import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/edit_nutrition_facts/header_widget.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../models/edit_nutrition_facts_navigation_data_provider.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  bool getVisibleSubtitle(BuildContext context) =>
      EditNutritionFactsNavigationDataProvider.of(context).visibleSubtitle;

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
        return HeaderWidget(
          isUpdate: isUpdate,
          visibleSubtitle: getVisibleSubtitle(context),
        );
      },
    );
  }
}
