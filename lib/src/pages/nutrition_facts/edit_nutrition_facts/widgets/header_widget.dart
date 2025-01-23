import 'package:flutter/material.dart';

import '../../../../common/constant/app_text_styles.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/text_span_extension.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.localization.editNutritionFacts ?? '',
          style: AppTextStyle.textXl.addAll([
            AppTextStyle.textXl.leading7,
            AppTextStyle.bold,
          ]),
        ),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: context
                .localization.nutritionFactsCustomFoodCreationMessage
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
}
