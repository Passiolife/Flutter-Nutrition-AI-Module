import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/action_buttons_widget.dart';
import '../../../common/widgets/app_slider.dart';
import '../../../common/widgets/app_text_field.dart';

typedef OnSaveNutritionTarget = Function(UserProfileModel? profileModel);

class DailyNutritionTargetDialog {
  DailyNutritionTargetDialog.show({
    required BuildContext context,
    UserProfileModel? profileModel,
    OnSaveNutritionTarget? onSave,
  }) {

    TextEditingController caloriesController =
        TextEditingController(text: '${profileModel?.caloriesTarget ?? 0}');
    TextEditingController carbsController = TextEditingController();
    TextEditingController proteinController = TextEditingController();
    TextEditingController fatController = TextEditingController();

    final FocusNode caloriesFocusNode = FocusNode();
    final FocusNode carbsFocusNode = FocusNode();
    final FocusNode proteinFocusNode = FocusNode();
    final FocusNode fatFocusNode = FocusNode();

    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState) {
          OkButtonWithKeyboard.setup(
            context: context,
            focusNode: caloriesFocusNode,
            onTap: () {
              setState(() {
                profileModel?.caloriesTarget =
                    int.tryParse(caloriesController.text) ?? 0;
              });
            },
          );

          OkButtonWithKeyboard.setup(
            context: context,
            focusNode: carbsFocusNode,
            onTap: () {
              setState(() {
                profileModel?.setCarbsPercentage(
                    int.tryParse(carbsController.text) ??
                        profileModel.carbsPercentage);
              });
            },
          );

          OkButtonWithKeyboard.setup(
            context: context,
            focusNode: proteinFocusNode,
            onTap: () {
              setState(() {
                profileModel?.setProteinPercentage(
                    int.tryParse(proteinController.text) ??
                        profileModel.proteinPercentage);
              });
            },
          );

          OkButtonWithKeyboard.setup(
            context: context,
            focusNode: fatFocusNode,
            onTap: () {
              setState(() {
                profileModel?.setFatPercentage(
                    int.tryParse(fatController.text) ??
                        profileModel.fatPercentage);
              });
            },
          );

          carbsController.text = profileModel?.carbsPercentage.toString() ?? '';
          proteinController.text =
              profileModel?.proteinPercentage.toString() ?? '';
          fatController.text = profileModel?.fatPercentage.toString() ?? '';

          int carbs = profileModel?.carbsPercentage ?? 0;
          int protein = profileModel?.proteinPercentage ?? 0;
          int fat = profileModel?.fatPercentage ?? 0;

          int carbsGrams = profileModel?.carbsGram ?? 0;
          int proteinGrams = profileModel?.proteinGram ?? 0;
          int fatGrams = profileModel?.fatGram ?? 0;

          return Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      children: [
                        Text(
                          context.localization?.dailyNutritionTarget ?? '',
                          style: AppTextStyle.textXl.addAll([
                            AppTextStyle.textXl.leading7,
                            AppTextStyle.bold
                          ]).copyWith(color: AppColors.gray900),
                        ),
                        4.verticalSpace,
                        Text(
                          context.localization
                                  ?.dailyNutritionTargetDescription ??
                              '',
                          style: AppTextStyle.textSm
                              .copyWith(color: AppColors.gray900),
                        ),
                        16.verticalSpace,
                        Text(
                          context.localization?.calorieGoal ?? '',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading4,
                            AppTextStyle.medium
                          ]),
                        ),
                        8.verticalSpace,
                        SizedBox(
                          width: 80.w,
                          child: AppTextField(
                            controller: caloriesController,
                            focusNode: caloriesFocusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: NutritionalGoalWidget(
                                controller: carbsController,
                                value: carbs,
                                gramsValue: carbsGrams,
                                focusNode: carbsFocusNode,
                                onChanged: (value) {
                                  profileModel
                                      ?.setCarbsPercentage(value.toInt());
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: NutritionalGoalWidget(
                                controller: proteinController,
                                value: protein,
                                gramsValue: proteinGrams,
                                focusNode: proteinFocusNode,
                                onChanged: (value) {
                                  profileModel
                                      ?.setProteinPercentage(value.toInt());
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: NutritionalGoalWidget(
                                controller: fatController,
                                value: fat,
                                gramsValue: fatGrams,
                                focusNode: fatFocusNode,
                                onChanged: (value) {
                                  profileModel?.setFatPercentage(value.toInt());
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        32.verticalSpace,
                        ActionButtonsWidget(
                          cancelButtonText: context.localization?.cancel,
                          saveButtonText: context.localization?.ok,
                          onTapCancel: () => Navigator.pop(context),
                          onTapSave: () {
                            Navigator.pop(context);
                            onSave?.call(profileModel);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class NutritionalGoalWidget extends StatelessWidget {
  const NutritionalGoalWidget({
    this.title,
    this.value = 0,
    this.gramsValue = 0,
    this.controller,
    this.onChanged,
    this.focusNode,
    super.key,
  });

  final String? title;
  final int value;
  final int gramsValue;
  final TextEditingController? controller;
  final ValueChanged<double>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading4, AppTextStyle.medium]),
        ),
        8.verticalSpace,
        SizedBox(
          width: 60.w,
          child: AppTextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {
              if ((int.tryParse(value) ?? 0) > 100) {
                controller?.text = '100';
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: AppDimens.w8),
              child: Text(
                '%',
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
            suffixIconConstraints:
                BoxConstraints(minHeight: AppTextStyle.textBase.fontSize ?? 14),
            style:
                AppTextStyle.textBase.addAll([AppTextStyle.textBase.leading6]),
          ),
        ),
        8.verticalSpace,
        Text(
          '$gramsValue g',
          style: AppTextStyle.textBase.addAll([AppTextStyle.textBase.leading6]),
        ),
        16.verticalSpace,
        SizedBox(
          height: 160.h,
          child: RotatedBox(
            quarterTurns: 3,
            child: AppSlider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
