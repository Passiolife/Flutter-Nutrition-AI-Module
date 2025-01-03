import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../../common/constant/app_border.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/button/primary_button.dart';
import '../../../../common/widgets/button/secondary_button.dart';

class FailedToAnalyzeImageWidget extends StatelessWidget {
  const FailedToAnalyzeImageWidget({super.key});

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
            context.localization.failedToAnalyzeImage ?? '',
            style: AppTextStyle.textXl
                .addAll([AppTextStyle.textXl.leading7, AppTextStyle.bold]),
          ),
          Text(
            context.localization.failedToAnalyzeImageDescription ?? '',
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
            spacing: 16.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SecondaryButton(
                  text: context.localization.cancel,
                  padding: AppPadding.pv12,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: PrimaryButton(
                  text: context.localization.tryAgain,
                  padding: AppPadding.pv12,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
