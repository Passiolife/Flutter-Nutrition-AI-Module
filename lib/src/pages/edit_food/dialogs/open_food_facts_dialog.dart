import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

class OpenFoodFactsDialog {
  OpenFoodFactsDialog.show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'The nutrition information provided can be found from ',
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: AppColors.gray900),
                    children: [
                      TextSpan(
                        text: 'Open Food Facts,',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url =
                                Uri.parse('https://en.openfoodfacts.org');
                            try {
                              await launchUrl(url);
                            } on Exception {
                              // ignored
                            }
                          },
                        style: AppTextStyle.textSm
                            .addAll([AppTextStyle.textSm.leading5]).copyWith(
                                color: AppColors.indigo600Main),
                      ),
                      TextSpan(
                        text: ' Which is made available under the ',
                        style: AppTextStyle.textSm
                            .addAll([AppTextStyle.textSm.leading5]).copyWith(
                                color: AppColors.gray900),
                      ),
                      TextSpan(
                        text: 'Open Database License.',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                                'https://opendatacommons.org/licenses/odbl/1-0');
                            try {
                              await launchUrl(url);
                            } on Exception {
                              // ignored
                            }
                          },
                        style: AppTextStyle.textSm
                            .addAll([AppTextStyle.textSm.leading5]).copyWith(
                                color: AppColors.indigo600Main),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Material(
                  child: AppButton(
                    buttonText: context.localization?.ok,
                    appButtonModel: AppButtonStyles.primary,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
