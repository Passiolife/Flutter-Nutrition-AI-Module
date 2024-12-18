import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constant/app_border.dart';
import '../../../../../../common/constant/app_padding.dart';
import '../../../../../../common/constant/app_shadow.dart';
import '../../bloc/recipe_creator_bloc.dart';
import '../widgets/add_ingredient_widget.dart';
import '../widgets/ingredient_row_widget.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients =
        context.watch<RecipeCreatorBloc>().viewModel.foodRecord?.ingredients;
    return Column(
      children: [
        AddIngredientWidget(
          isExpanded: ingredients?.isNotEmpty ?? false,
        ),
        Container(
          decoration: AppShadows.base.copyWith(borderRadius: AppBorderCircular.bb16),
          child: ListView.builder(
            shrinkWrap: true,
            padding: (ingredients?.isNotEmpty ?? false) ? AppPadding.pv8 : EdgeInsets.zero,
            itemCount: ingredients?.length ?? 0,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final ingredient = ingredients![index];
              return IngredientRowWidget(
                index: index,
                ingredient: ingredient,
              );
            },
          ),
        ),
      ],
    );
  }
}
