import 'package:flutter/material.dart';

import '../../../common/constant/app_text_styles.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/extension/text_span_extension.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    this.isUpdate = false,
    this.visibleSubtitle = false,
    super.key,
  });

  final bool visibleSubtitle;
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.localization.editNutritionFacts,
          style: AppTextStyle.textXl.addAll([
            AppTextStyle.textXl.leading7,
            AppTextStyle.bold,
          ]),
        ),
        if (visibleSubtitle)
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children:
                  getNutritionFactsCustomFoodCreationMessage(context, isUpdate)
                      .generateSpans(
                defaultStyle: AppTextStyle.textSm,
                highlightStyles: {
                  context.localization.myFoods:
                      AppTextStyle.textSm.addAll([AppTextStyle.bold]),
                },
              ),
            ),
          ),
      ],
    );
  }

  String getNutritionFactsCustomFoodCreationMessage(
      BuildContext context, bool isUpdate) {
    String text = context.localization.nutritionFactsCustomFoodCreationMessage;
    if (isUpdate) {
      return text.replaceFirst(
          context.localization.create, context.localization.update);
    }
    return text;
  }
}
