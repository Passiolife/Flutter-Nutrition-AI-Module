import 'package:flutter/material.dart';
import '../../../../common/constant/app_constants.dart';
import '../widgets/ingredients_list_widget.dart';
import '../widgets/ingredients_title_widget.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({
    required this.visibleAddIngredient,
    super.key,
  });

  final bool visibleAddIngredient;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibleAddIngredient,
      child: Container(
        decoration: AppShadows.base,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IngredientsTitleWidget(),
            const IngredientsListWidget(),
          ],
        ),
      ),
    );
  }
}
