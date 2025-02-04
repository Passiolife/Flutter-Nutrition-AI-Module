import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/constant/app_text_styles.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/router/routes.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';

class NoResultsFoundWidget extends StatelessWidget {
  const NoResultsFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: AppPadding.ph16 + AppPadding.pb16,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.localization.noResultsFound,
                    style: AppTextStyle.textXl.addAll(
                        [AppTextStyle.textXl.leading7, AppTextStyle.bold]),
                  ),
                  4.verticalSpace,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: context.localization.noResultsFoundDescription,
                          style: AppTextStyle.textSm,
                        ),
                        TextSpan(
                          text: context.localization.searchManually,
                          style: AppTextStyle.textSm
                              .addAll([AppTextStyle.bold]).copyWith(
                                  color: context.theme.primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                Routes.foodSearch,
                                arguments: false,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
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
                16.horizontalSpace,
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
      ),
    );
  }
}
