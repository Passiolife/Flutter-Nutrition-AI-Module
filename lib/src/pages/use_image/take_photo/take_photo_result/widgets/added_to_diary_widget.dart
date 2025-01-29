/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/widgets/icons/icon_check_mark_widget.dart';

class AddedToDiaryWidget extends StatelessWidget {
  const AddedToDiaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderCircular.ba16,
      ),
      padding: AppPadding.pa16,
      child: Column(
        children: [
          const IconCheckMarkWidget(),
          16.verticalSpace,
          Text(
            context.localization.itemAddedToDiary ?? '',
            style: AppTextStyle.textXl.addAll([AppTextStyle.bold]).copyWith(
                color: AppColors.green500Success),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            context.localization.itemAddedToDiaryDescription ?? '',
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5]).copyWith(
                color: AppColors.gray900),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.h16),
          Row(
            children: [
              Expanded(child: child)
              Expanded(
                child: AppButton(
                  buttonText: context.localization.viewDiary,
                  appButtonModel: AppButtonStyles.primaryBordered.copyWith(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h13),
                  ),
                  onTap: onTapViewDiary,
                ),
              ),
              SizedBox(width: AppDimens.w16),
              Expanded(
                child: AppButton(
                  buttonText: context
                      .localization.continueScanning.toUpperCaseWord,
                  appButtonModel: AppButtonStyles.primary.copyWith(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h13),
                  ),
                  onTap: onTapContinue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
