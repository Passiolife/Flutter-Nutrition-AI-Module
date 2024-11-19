import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../my_foods/custom_foods/food_creator/food_creator_page.dart';

class UserFoodNotFoundDialog {
  UserFoodNotFoundDialog.show({
    required BuildContext context,
    required bool logUpdateOnCreate,
    FoodRecord? foodRecord,
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
                      context.localization?.foodNotFound ?? '',
                    ),
                  ),
                  DefaultTextStyle(
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: AppColors.gray900),
                    child: Text(
                      context.localization?.createUserFoodDescription ?? '',
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
                                context.localization?.create?.toCapitalized(),
                            appButtonModel: AppButtonStyles.primary,
                            onTap: () async {
                              Navigator.pop(dContext);
                              FoodCreatorPage.navigate(
                                context: context,
                                loggedFoodRecord: foodRecord,
                                logUponCreate: logUpdateOnCreate,
                              );
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
        });
      },
    );
  }
}
