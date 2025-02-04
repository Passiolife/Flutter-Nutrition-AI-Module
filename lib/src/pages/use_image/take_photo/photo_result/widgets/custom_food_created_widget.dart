import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/text_span_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';

class CustomFoodCreatedWidget extends StatelessWidget {
  const CustomFoodCreatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderCircular.ba16,
      ),
      margin: AppPadding.pa16,
      padding: AppPadding.pa16,
      child: Column(
        children: [
          Text(
            context.localization.customFoodHasBeenCreated,
            style: AppTextStyle.textXl
                .addAll([AppTextStyle.textXl.leading7, AppTextStyle.bold]),
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: context
                  .localization.customFoodCreatedDescription
                  .generateSpans(
                defaultStyle: AppTextStyle.textSm,
                highlightStyles: {
                  context.localization.myFoods:
                      AppTextStyle.textSm.addAll([AppTextStyle.bold]),
                },
              ),
            ),
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                text: context.localization.ok,
                padding: AppPadding.ph72 + AppPadding.pv12,
                onTap: () => Navigator.of(context).pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
