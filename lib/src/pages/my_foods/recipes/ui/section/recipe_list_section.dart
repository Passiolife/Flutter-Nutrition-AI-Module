import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/food_item_row_widget.dart';
import '../../../../edit_food/ui/edit_food_page.dart';
import '../../bloc/recipes_bloc.dart';
import '../../recipe_creator/ui/model/navigation_data_provider.dart';
import '../../recipe_creator/ui/recipe_creator_page.dart';

class RecipeListSection extends StatelessWidget {
  const RecipeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.watch<RecipesBloc>().userRecipes;
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: list?.length ?? 0,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final data = list?.elementAt(index);
          if (data == null) return const SizedBox.shrink();
          return FoodItemRowWidget(
            data: FoodItemRowData(
              rippleColor: AppColors.white,
              padding: AppPadding.pa8,
              index: index,
              foodRecord: data,
              title: data.name,
              iconId: data.iconId,
              subtitle: data.additionalData,
              onTap: () => _doOpenRecord(context: context, foodRecord: data),
              onTapAdd: () => _doLogRecord(context: context, foodRecord: data),
              onTapEdit: () =>
                  _doEditRecord(context: context, foodRecord: data),
              onTapDelete: (forced) => _doDeleteRecord(
                context: context,
                foodRecord: data,
                forced: forced,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return 8.verticalSpace;
        },
      ),
    );
  }

  Future<void> _doOpenRecord(
      {required BuildContext context, required FoodRecord foodRecord}) async {
    final record = foodRecord.clone();
    record.refCode = '${FoodRecord.userRecipePrefix}${record.id}';
    EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodRecord: record,
        message: context.localization?.itemAddedToDiary,
        source: AppCommonConstants.userRecipe,
        visibleRecipeCreator: true,
        redirectToDiaryOnLog: true,
      ),
    );
  }

  Future<void> _doLogRecord(
      {required BuildContext context, required FoodRecord foodRecord}) async {
    context.read<RecipesBloc>().add(DoFoodLogEvent(foodRecord: foodRecord));
  }

  Future<void> _doEditRecord({
    required BuildContext context,
    required FoodRecord foodRecord,
  }) async {
    await RecipeCreatorPage.navigate(
      context: context,
      params: NavigationData(recipeFoodRecord: foodRecord),
    );
  }

  void _doDeleteRecord({
    required BuildContext context,
    required FoodRecord foodRecord,
    required bool forced,
  }) {
    if (forced) {
      context
          .read<RecipesBloc>()
          .add(DoDeleteUserRecipeEvent(foodRecord: foodRecord));
      return;
    }
    DeleteConfirmationDialog.show(
      context: context,
      onConfirm: () => context
          .read<RecipesBloc>()
          .add(DoDeleteUserRecipeEvent(foodRecord: foodRecord)),
    );
  }
}
