import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/button/primary_button.dart';

class CaptureNutritionFactsLabelWidget extends StatelessWidget {
  const CaptureNutritionFactsLabelWidget({
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;

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
            context.localization.captureNutritionFactsLabel ?? '',
            style: AppTextStyle.textXl
                .addAll([AppTextStyle.textXl.leading7, AppTextStyle.bold]),
          ),
          Text(
            context.localization.captureNutritionFactsLabelDescription ?? '',
            style: AppTextStyle.textSm.addAll([AppTextStyle.textSm]),
          ),
          16.verticalSpace,
          VectorGraphic(
            loader: AssetBytesLoader(AppImages.icNutritionFactsLabel),
            width: 200.r,
            height: 200.r,
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                text: context.localization.ok,
                padding: AppPadding.pv12 + AppPadding.ph72,
                onTap: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
