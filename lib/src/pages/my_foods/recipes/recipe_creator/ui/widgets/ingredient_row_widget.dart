import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/constant/app_padding.dart';
import '../../../../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../../../../common/models/food_record/food_record_ingredient.dart';
import '../../../../../../common/extension/context_extension.dart';
import '../../../../../../common/util/double_extensions.dart';
import '../../../../../../common/extension/string_extensions.dart';
import '../../../../../../common/widgets/food_item_row_widget.dart';
import '../../../../../edit_food/ui/edit_food_page.dart';
import '../../bloc/recipe_creator_bloc.dart';

class IngredientRowWidget extends StatelessWidget {
  const IngredientRowWidget({
    required this.index,
    this.ingredient,
    super.key,
  });

  final int index;
  final FoodRecordIngredient? ingredient;

  String get foodSize =>
      '${ingredient?.selectedQuantity.format(places: 1)} ${ingredient?.selectedUnit.toUpperCaseWord} (${ingredient?.computedWeight.value.format(places: 0)} ${ingredient?.computedWeight.symbol})';

  String getCalories(BuildContext context) {
    return '${ingredient?.nutrientsSelectedSize().calories?.value.round() ?? 0} ${context.localization?.cal}';
  }

  @override
  Widget build(BuildContext context) {
    return FoodItemRowWidget(
      data: FoodItemRowData(
        index: index,
        outerPadding: AppPadding.pv8,
        decoration: BoxDecoration(),
        iconId: ingredient?.iconId,
        title: ingredient?.name ?? '',
        subtitle: foodSize,
        isAddVisible: false,
        suffix: Text(
          getCalories(context),
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
        ),
        onTap: () => onEdit(context),
        onTapEdit: () => onEdit(context),
        onTapDelete: (forced) => onDelete(context: context, forced: forced),
      ),
    );
  }

  void onDelete({
    required BuildContext context,
    required bool forced,
  }) {
    final recipeCreatorBloc = context.read<RecipeCreatorBloc>();

    // Handle forced deletion directly
    if (forced) {
      _deleteIngredient(recipeCreatorBloc);
    } else {
      _showDeleteConfirmationDialog(context, recipeCreatorBloc);
    }
  }

  // Function to show the delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, RecipeCreatorBloc bloc) {
    DeleteConfirmationDialog.show(
      context: context,
      onConfirm: () => _deleteIngredient(bloc),
    );
  }

  // Function to handle deletion of the ingredient
  void _deleteIngredient(RecipeCreatorBloc bloc) {
    bloc.add(DoDeleteIngredientEvent(index: index));
  }

  Future<void> onEdit(BuildContext context) async {
    final ingredientCopy = ingredient?.clone();
    final foodRecord = await EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodRecordIngredient: ingredientCopy,
        visibleMealTimeView: false,
        visibleDateView: false,
        visibleAddIngredient: false,
        needsReturn: true,
        title: context.localization?.editIngredient,
        positiveButtonText: context.localization?.save,
      ),
    );
    if (foodRecord != null && context.mounted) {
      context.read<RecipeCreatorBloc>().add(DoUpdateIngredients(
            index: index,
            foodRecord: foodRecord,
            isUpdate: true,
          ));
    }
  }
}
