import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_constants.dart';
import '../../constant/app_padding.dart';
import '../../extension/context_extension.dart';
import '../app_button.dart';
import 'base_bottom_sheet.dart';

class NoResultsFoundBottomSheet extends StatelessWidget {
  const NoResultsFoundBottomSheet({
    this.height,
    this.title,
    this.description,
    this.positiveButtonText,
    this.onTapPositive,
    this.negativeButtonText,
    this.onTapNegative,
    super.key,
  });

  final double? height;

  final String? title;
  final String? description;

  // Positive Button Properties
  final String? positiveButtonText;
  final VoidCallback? onTapPositive;

  // Negative Button Properties
  final String? negativeButtonText;
  final VoidCallback? onTapNegative;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      height: height,
      child: Padding(
        padding: AppPadding.pv16,
        child: Column(
          children: [
            Text(
              title ?? context.localization?.noResultsFound ?? '',
              style: AppTextStyle.textXl
                  .addAll([AppTextStyle.textXl.leading7, AppTextStyle.bold]),
            ),
            4.verticalSpace,
            Text(
              description ??
                  context.localization?.voiceLoggingNoResultsFoundDescription ??
                  '',
              style: AppTextStyle.textSm,
              textAlign: TextAlign.center,
            ),
            40.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    buttonText:
                        negativeButtonText ?? context.localization?.tryAgain,
                    appButtonModel: AppButtonStyles.primaryBordered,
                    onTap: onTapNegative,
                  ),
                ),
                SizedBox(width: AppDimens.w16),
                Expanded(
                  child: AppButton(
                    buttonText: context.localization?.searchManually,
                    appButtonModel: AppButtonStyles.primary,
                    onTap: onTapPositive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
