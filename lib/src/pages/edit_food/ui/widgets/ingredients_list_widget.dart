import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/util/string_extensions.dart';
import '../../../../common/widgets/food_item_row_widget.dart';
import '../../bloc/edit_food_bloc.dart';
import '../edit_food_page.dart';

class IngredientsListWidget extends StatelessWidget {
  const IngredientsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients =
        context.watch<EditFoodBloc>().foodRecord?.ingredients ?? [];
    if (ingredients.length <= 1) return SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: AppColors.gray50),
        SlidableAutoCloseBehavior(
          child: ListView.builder(
            itemCount: ingredients.length,
            shrinkWrap: true,
            padding: AppPadding.ph8 + AppPadding.pb8,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final ingredient = ingredients.elementAt(index);

              final iconId = ingredient.iconId;
              final title = ingredient.name.toUpperCaseWord;
              final subtitle =
                  '${ingredient.selectedQuantity.format(places: 2)} ${ingredient.selectedUnit.toUpperCaseWord} (${ingredient.computedWeight.value.format(places: 0)} ${ingredient.computedWeight.symbol})';

              final calories =
                  '${ingredient.nutrientsSelectedSize().calories?.value.round() ?? 0} ${context.localization?.cal}';

              return FoodItemRowWidget(
                data: FoodItemRowData(
                  isAddVisible: false,
                  outerPadding: AppPadding.pv8,
                  iconId: iconId,
                  title: title,
                  subtitle: subtitle,
                  decoration: const BoxDecoration(),
                  suffix: Text(
                    calories,
                    style: AppTextStyle.textSm.addAll(
                        [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
                  ),
                  onTap: () => _handleIngredientTap(
                      context: context, index: index, ingredient: ingredient),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleIngredientTap(
      {required BuildContext context,
      required int index,
      required FoodRecordIngredient ingredient}) async {
    final data = await EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodRecordIngredient:
            FoodRecordIngredient.fromJson(ingredient.toJson()),
        iconHeroTag: '${ingredient.iconId}$index',
        needsReturn: true,
        visibleMealTimeView: false,
        visibleDateView: false,
        visibleAddIngredient: false,
        visibleFavorite: false,
      ),
    );
    if (data != null && data is FoodRecord && context.mounted) {
      context
          .read<EditFoodBloc>()
          .add(DoReplaceIngredientEvent(index: index, ingredient: data));
    }
  }
}
