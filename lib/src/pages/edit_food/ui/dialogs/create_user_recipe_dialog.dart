import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/string_extensions.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_loading_button_widget.dart';
import '../../../../common/widgets/app_switch.dart';
import '../../../my_foods/recipes/recipe_creator/ui/model/navigation_data_provider.dart';
import '../../../my_foods/recipes/recipe_creator/ui/recipe_creator_page.dart';

class CreateUserRecipeDialog {
  static Future<bool> show({
    required BuildContext context,
    bool isLogUpdateVisibleOnCreate = true,
    FoodRecord? foodRecord,
    ValueChanged<bool>? onLogUpdateVisibleOnCreateChanged,
    Function(BuildContext context, bool logUpdateOnCreate)? onEdit,
  }) async {
    bool logUpdateOnCreate = isLogUpdateVisibleOnCreate ? true : false;
    bool loadingEdit = false;
    bool includeEdit = foodRecord?.hasUserRecipeReference ?? false;

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
                                    ? context.localization?.createOrEditUserRecipe
                                    : context.localization?.createUserRecipe) ??
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
                                        ?.createOrEditUserRecipeDescription
                                    : context.localization
                                        ?.createUserRecipeDescription) ??
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
                                  buttonText: context.localization?.cancel
                                      ?.toCapitalized(),
                                  appButtonModel:
                                      AppButtonStyles.primaryBordered,
                                  onTap: () {
                                    Navigator.pop(context);
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
                                      buttonText: context.localization?.edit
                                          ?.toCapitalized(),
                                      appButtonModel: AppButtonStyles.primary,
                                      onTap: () async {
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
                                  buttonText: context.localization?.create
                                      ?.toCapitalized(),
                                  appButtonModel: AppButtonStyles.primary,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    RecipeCreatorPage.navigate(
                                      context: context,
                                      params: NavigationData(
                                        loggedFoodRecord: foodRecord,
                                        logUponCreate: logUpdateOnCreate,
                                      ),
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
                                            ?.updateLogUponCreating ??
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
