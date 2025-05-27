import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_loading_button_widget.dart';
import '../../../../common/widgets/app_switch.dart';
import '../../../my_foods_old/custom_foods/food_creator/food_creator_page.dart';

class CreateUserFoodDialog {
  static Future<bool> show({
    required BuildContext context,
    bool isLogUpdateVisibleOnCreate = true,
    FoodRecord? foodRecord,
    ValueChanged<bool>? onLogUpdateVisibleOnCreateChanged,
    Function(BuildContext context, bool logUpdateOnCreate)? onEdit,
  }) async {
    bool logUpdateOnCreate = isLogUpdateVisibleOnCreate ? true : false;
    bool loadingEdit = false;
    bool includeEdit = foodRecord?.refCode.startsWith(AppCommonConstants.userFood) ?? false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dContext) {
            return StatefulBuilder(
                builder: (BuildContext sfContext, StateSetter setState) {
              return IgnorePointer(
                ignoring: loadingEdit,
                child: Align(
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
                            (includeEdit
                                    ? context.localization.createOrEditUserFood
                                    : context.localization.createUserFood) ??
                                '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DefaultTextStyle(
                          style: AppTextStyle.textSm
                              .addAll([AppTextStyle.textSm.leading5]).copyWith(
                                  color: AppColors.gray900),
                          child: Text(
                            (includeEdit
                                    ? context.localization
                                        .createOrEditUserFoodDescription
                                    : context.localization
                                        .createUserFoodDescription) ??
                                '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                child: AppButton(
                                  buttonText: context.localization.cancel
                                      ?.toCapitalized(),
                                  appButtonModel:
                                      AppButtonStyles.primaryBordered,
                                  onTap: () {
                                    Navigator.pop(dContext);
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: includeEdit,
                              child: Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.w),
                                  child: Material(
                                    child: AppButton(
                                      buttonText: context.localization.edit
                                          ?.toCapitalized(),
                                      appButtonModel: AppButtonStyles.primary,
                                      onTap: () async {
                                        Navigator.pop(dContext);

                                        setState(() {
                                          loadingEdit = true;
                                        });
                                        onEdit?.call(
                                            context, logUpdateOnCreate);
                                      },
                                      isLoading: loadingEdit,
                                      loadingWidget:
                                          AppLoadingButtonWidget.secondary(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: Material(
                                child: AppButton(
                                  buttonText: context.localization.create
                                      ?.toCapitalized(),
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
                        if (isLogUpdateVisibleOnCreate)
                          Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: AppTextStyle.textSm.addAll([
                                    AppTextStyle.textSm.leading5
                                  ]).copyWith(color: AppColors.gray900),
                                  child: Text(
                                    context.localization
                                            .updateLogUponCreating ??
                                        '',
                                  ),
                                ),
                                16.horizontalSpace,
                                AppSwitch(
                                  value: logUpdateOnCreate,
                                  onChanged: (value) {
                                    setState(() {
                                      logUpdateOnCreate = value;
                                      onLogUpdateVisibleOnCreateChanged
                                          ?.call(logUpdateOnCreate);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ) ??
        false;
  }
}
