import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../my_foods/recipes/recipe_creator/ui/model/navigation_data_provider.dart'
    as recipe;
import '../../../my_foods/recipes/recipe_creator/ui/recipe_creator_page.dart';
import '../../bloc/edit_food_bloc.dart';
import '../dialogs/create_user_recipe_dialog.dart';
import '../edit_food_page.dart';

class IngredientsTitleWidget extends StatelessWidget {
  const IngredientsTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationParams = NavigationDataProvider.of(context).params;

    final foodRecord = context.watch<EditFoodBloc>().foodRecord;
    bool isRecipe = (foodRecord?.ingredients ?? []).length >= 2;
    return Padding(
      padding: AppPadding.pa16,
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.localization?.ingredients ?? '',
              style: AppTextStyle.textBase.addAll([AppTextStyle.semiBold]),
            ),
          ),
          navigationParams.visibleRecipeCreator ? AppButton(
            buttonText: isRecipe
                ? context.localization?.editRecipe
                : context.localization?.makeCustomRecipe,
            appButtonModel: AppButtonStyles.primary.copyWith(
              padding: AppPadding.pv8 + AppPadding.ph16,
            ),
            onTap: () => _handleRecipeTapped(
                context: context, isRecipe: isRecipe, foodRecord: foodRecord),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> _handleRecipeTapped({
    required BuildContext context,
    bool isRecipe = false,
    FoodRecord? foodRecord,
  }) async {
    if (foodRecord != null) {
      final navigationParams = NavigationDataProvider.of(context).params;
      if (navigationParams.source == AppCommonConstants.userRecipe) {
        await RecipeCreatorPage.navigate(
          context: context,
          params: recipe.NavigationData(recipeFoodRecord: foodRecord),
        );
        return;
      }

      final params = NavigationDataProvider.of(context).params;
      CreateUserRecipeDialog.show(
        context: context,
        isLogUpdateVisibleOnCreate:
            params.visibleLogUponCreate ?? foodRecord.id.isNotEmpty,
        foodRecord: foodRecord,
        onEdit: (sfContext, logUpdateOnCreate) {
          context.read<EditFoodBloc>().add(DoFetchUserCreatedRecipeEvent(
                foodRecord: foodRecord,
                logUpdateOnCreate: logUpdateOnCreate,
              ));
        },
      );
    }
  }
}
