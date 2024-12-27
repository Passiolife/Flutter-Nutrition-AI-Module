import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_constants.dart';
import '../extension/context_extension.dart';
import '../extension/string_extensions.dart';
import '../widgets/app_button.dart';

class DeleteConfirmationDialog {
  DeleteConfirmationDialog.show({
    required BuildContext context,
    VoidCallback? onConfirm,
  }) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                    DefaultTextStyle(
                      style: AppTextStyle.textXl.addAll([
                        AppTextStyle.textSm.leading7,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.gray900),
                      child: Text(
                        context.localization?.delete ?? '',
                      ),
                    ),
                    DefaultTextStyle(
                      style: AppTextStyle.textSm
                          .addAll([AppTextStyle.textSm.leading5]).copyWith(
                              color: AppColors.gray900),
                      child: Text(
                        context.localization?.deleteDescription ?? '',
                      ),
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            child: AppButton(
                              buttonText:
                                  context.localization?.cancel?.toCapitalized(),
                              appButtonModel: AppButtonStyles.primaryBordered,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Material(
                            child: AppButton(
                              buttonText:
                                  context.localization?.delete?.toCapitalized(),
                              appButtonModel: AppButtonStyles.delete,
                              onTap: () async {
                                Navigator.pop(dContext);
                                onConfirm?.call();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
