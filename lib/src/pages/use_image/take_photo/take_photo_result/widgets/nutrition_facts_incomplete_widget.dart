import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/passio_image_widget.dart';

class NutritionFactsIncompleteWidget extends StatelessWidget {
  const NutritionFactsIncompleteWidget({this.onAddImage, super.key,});

  final VoidCallback? onAddImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base.copyWith(color: AppColors.rose50),
      padding: AppPadding.pa8 + AppPadding.pv16,
      margin: AppPadding.ph16 + AppPadding.pt16,
      child: Row(
        spacing: 8.w,
        children: [
          PassioImageWidget(
            iconId: '',
            radius: 20.r,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.barcodeMissingData ?? '',
                  style: AppTextStyle.textSm.addAll(
                      [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
                ),
                Text(
                  context.localization.barcodeMissingDataDescription ?? '',
                  style: AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]).copyWith(
                      color: context.textThemeColors.brandTextLight),
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: context.localization.editNutrition ?? '',
            padding: AppPadding.pa8,
            onTap: onAddImage,
          ),
        ],
      ),
    );
  }
}
