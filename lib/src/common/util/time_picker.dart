import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../widgets/app_button.dart';
import 'context_extension.dart';

typedef OnDateTimeChanged = Function(DateTime dateTime);

class TimePicker {
  static Future showAdaptive({
    required BuildContext context,
    DateTime? selectedTime,
    OnDateTimeChanged? onDateTimeChanged,
  }) async {
    if (Platform.isIOS) {
      showIOSStyleTimePickerDialog(
        context: context,
        selectedTime: selectedTime,
        onDateTimeChanged: onDateTimeChanged,
      );
      return;
    }
    TimeOfDay? changedDateTime = await showAndroidStyleDatePickerDialog(
        context: context, selectedTime: selectedTime);
    if (changedDateTime != null) {
      final time = selectedTime?.copyWith(
          hour: changedDateTime.hour, minute: changedDateTime.minute);
      if (time != null) {
        onDateTimeChanged?.call(time);
      }
    }
  }

  static Future<TimeOfDay?> showAndroidStyleDatePickerDialog({
    required BuildContext context,
    DateTime? selectedTime,
  }) async {
    selectedTime ??= DateTime.now();
    return await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
      confirmText: context.localization?.save,
      barrierColor: AppColors.black75Opacity,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(useMaterial3: false).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.indigo600Main, // circle color
              onPrimary: Colors.white, // selected text color
              surface: AppColors.white,
              onSurface: AppColors.gray600, // default text color
            ),
            timePickerTheme: TimePickerThemeData(
              // Background color of the date picker
              backgroundColor: AppColors.white,
              dialBackgroundColor: AppColors.white,
              dialTextStyle: AppTextStyle.textSm.addAll([
                AppTextStyle.textLg.leading5,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
              // Style for the cancel button in the date picker
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.indigo700,
                textStyle: AppTextStyle.textBase.addAll([
                  AppTextStyle.textBase.leading6,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.indigo700),
              ),
              // Style for the confirm button in the date picker
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.indigo700,
                textStyle: AppTextStyle.textBase.addAll([
                  AppTextStyle.textBase.leading6,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.indigo700),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static void showIOSStyleTimePickerDialog({
    required BuildContext context,
    DateTime? selectedTime,
    OnDateTimeChanged? onDateTimeChanged,
  }) {
    DateTime updatedDateTime = DateTime.now();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: AppColors.black75Opacity,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppDimens.r16),
                        bottomRight: Radius.circular(AppDimens.r16),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: AppDimens.h280,
                          child: Padding(
                            padding: EdgeInsets.only(top: AppDimens.h64),
                            child: CupertinoDatePicker(
                              initialDateTime: selectedTime,
                              mode: CupertinoDatePickerMode.time,
                              dateOrder: DatePickerDateOrder.mdy,
                              // This is called when the user changes the date.
                              onDateTimeChanged: (DateTime newDate) {
                                updatedDateTime = newDate;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.h24),
                        Material(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: AppDimens.w16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    buttonText: context.localization?.today,
                                    appButtonModel: AppButtonStyles
                                        .simpleSecondary
                                        .addAll(AppShadows.sm.boxShadow ?? []),
                                    onTap: () {
                                      updatedDateTime = DateTime.now();
                                      onDateTimeChanged?.call(updatedDateTime);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(width: AppDimens.w24),
                                Expanded(
                                  child: AppButton(
                                    buttonText: context.localization?.save,
                                    appButtonModel: AppButtonStyles.primary
                                        .addAll(AppShadows.sm.boxShadow ?? []),
                                    onTap: () {
                                      onDateTimeChanged?.call(updatedDateTime);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.h24),
                      ],
                    ),
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
