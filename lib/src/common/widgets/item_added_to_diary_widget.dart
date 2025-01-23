import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_constants.dart';
import '../extension/context_extension.dart';
import '../extension/string_extensions.dart';
import '../router/routes.dart';
import 'button/primary_button.dart';
import 'button/secondary_button.dart';
import 'icons/icon_check_mark_widget.dart';

class ItemAddedToDiaryWidget extends StatelessWidget {
  const ItemAddedToDiaryWidget({
    this.negativeText,
    this.positiveText,
    this.onTapNegative,
    this.onTapPositive,
    super.key,
  });

  /// Negative Button
  /// Default text: View Diary
  final String? negativeText;
  final VoidCallback? onTapNegative;

  /// Positive Button
  /// Default text: Add More
  final String? positiveText;
  final VoidCallback? onTapPositive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorderCircular.ba16,
            ),
            padding: AppPadding.pa16,
            margin: AppPadding.ph16 + AppPadding.pb64,
            child: Column(
              children: [
                IconCheckMarkWidget(
                  width: 40.r,
                  height: 40.r,
                ),
                SizedBox(height: AppDimens.h16),
                Text(
                  context.localization.itemAddedToDiary ?? '',
                  style: AppTextStyle.textXl.addAll([AppTextStyle.bold]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.localization.itemAddedToDiaryDescription ?? '',
                  style: AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.h16),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: negativeText ?? context.localization.viewDiary,
                        padding: AppPadding.pv12,
                        onTap: () {
                          Navigator.pop(context);
                          onTapNegative?.call();
                        },
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: PrimaryButton(
                        text: positiveText ??
                            context.localization.continueScanning.toUpperCaseWord,
                        padding: AppPadding.pv12,
                        onTap: () {
                          Navigator.pop(context);
                          onTapPositive?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
