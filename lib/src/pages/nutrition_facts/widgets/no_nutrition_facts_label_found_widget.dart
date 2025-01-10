import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/button/primary_button.dart';
import '../../../common/widgets/button/secondary_button.dart';

class NoNutritionFactsLabelFoundWidget extends StatelessWidget {
  const NoNutritionFactsLabelFoundWidget({
    this.onTapNegative,
    this.onTapPositive,
    super.key,
  });

  final VoidCallback? onTapNegative;
  final VoidCallback? onTapPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.pa16,
      margin: AppPadding.ph16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderCircular.ba16,
      ),
      child: Column(
        children: [
          Text(
            context.localization.noNutritionFactsLabelFound ?? '',
            style: AppTextStyle.textXl
                .addAll([AppTextStyle.textXl.leading7, AppTextStyle.bold]),
          ),
          Text(
            context.localization.noNutritionFactsLabelFoundDescription ?? '',
            style: AppTextStyle.textSm.addAll([AppTextStyle.textSm]),
          ),
          16.verticalSpace,
          VectorGraphic(
            loader: AssetBytesLoader(AppImages.icNoNutritionFactsLabelFound),
            width: 200.r,
            height: 200.r,
          ),
          16.verticalSpace,
          Row(
            spacing: 16.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SecondaryButton(
                  text: context.localization.tryAgain,
                  padding: AppPadding.pv12,
                  onTap: onTapNegative,
                ),
              ),
              Expanded(
                child: PrimaryButton(
                  text: context.localization.enterManually,
                  padding: AppPadding.pv12,
                  onTap: onTapPositive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
