import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_button.dart';

class AddedToDiaryWidget extends StatelessWidget {
  const AddedToDiaryWidget({
    this.onTapViewDiary,
    this.onTapContinue,
    super.key,
  });

  final VoidCallback? onTapViewDiary;
  final VoidCallback? onTapContinue;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r16),
        ),
        padding: EdgeInsets.all(AppDimens.r16),
        margin: EdgeInsets.symmetric(
          horizontal: AppDimens.r16,
          vertical: AppDimens.r64,
        ),
        child: Material(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          child: Column(
            children: [
              SvgPicture.asset(
                AppImages.icCheckMark,
                width: AppDimens.r40,
                height: AppDimens.r40,
              ),
              SizedBox(height: AppDimens.h16),
              Text(
                context.localization?.itemAddedToDiary ?? '',
                style: AppTextStyle.textXl.addAll([AppTextStyle.bold]).copyWith(
                    color: AppColors.green500Success),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                context.localization?.itemAddedToDiaryDescription ?? '',
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
                  Expanded(
                    child: AppButton(
                      buttonText: context.localization?.viewDiary,
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
                          .localization?.continueScanning.toUpperCaseWord,
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
        ),
      ),
    );
  }
}
