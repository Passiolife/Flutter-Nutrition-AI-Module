import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/icons/icon_pencil_alt_widget.dart';
import '../../../../../common/widgets/passio_image_widget.dart';

class IncompleteFoodItemWidget extends StatelessWidget {
  const IncompleteFoodItemWidget({
    required this.iconId,
    required this.title,
    this.onTap,
    super.key,
  });

  final String iconId, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppShadows.base.copyWith(color: AppColors.rose50),
        padding: AppPadding.pa8 + AppPadding.pv16,
        margin: AppPadding.ph16 + AppPadding.pt16,
        child: Row(
          spacing: 8.w,
          children: [
            PassioImageWidget(
              iconId: iconId,
              radius: 20.r,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
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
            const IconPencilAltWidget(),
            /*PrimaryButton(
              text: context.localization.editNutrition ?? '',
              padding: AppPadding.pa8,
              onTap: onTap,
            ),*/
          ],
        ),
      ),
    );
  }
}
