import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../widgets/app_button.dart';
import 'context_extension.dart';

typedef OnDateTimeChanged = Function(DateTime dateTime);

class DatePicker {
  static Future showAdaptive({
    required BuildContext context,
    DateTime? selectedDate,
    OnDateTimeChanged? onDateTimeChanged,
  }) async {
    if (Platform.isIOS) {
      showIOSStyleDatePickerDialog(
        context: context,
        selectedDate: selectedDate,
        onDateTimeChanged: onDateTimeChanged,
      );
      return;
    }
    DateTime? changedDateTime = await showAndroidStyleDatePickerDialog(
        context: context, selectedDate: selectedDate);
    if (changedDateTime != null) {
      onDateTimeChanged?.call(changedDateTime);
    }
  }

  static Future<DateTime?> showAndroidStyleDatePickerDialog({
    required BuildContext context,
    DateTime? selectedDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1),
      lastDate: DateTime(2100),
      confirmText: context.localization?.save,
      barrierColor: AppColors.black75Opacity,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.indigo600Main, // circle color
              onPrimary: Colors.white, // selected text color
              surface: AppColors.white,
              onSurface: AppColors.gray600, // default text color
            ),
            datePickerTheme: DatePickerThemeData(
              // Background color of the date picker
              backgroundColor: AppColors.white,
              // Surface tint color of the date picker
              surfaceTintColor: AppColors.white,
              // Custom style for the help text in the header
              headerHelpStyle: AppTextStyle.textSm.addAll([
                AppTextStyle.textLg.leading5,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
              // Custom style for the headline text in the header
              headerHeadlineStyle: AppTextStyle.text3xl.addAll([
                AppTextStyle.textLg.leading6,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
              yearStyle: AppTextStyle.textXs.addAll([
                AppTextStyle.textXs.leading4,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.red800),
              // Styles for the weekdays displayed in the date picker
              weekdayStyle: AppTextStyle.textXs.addAll([
                AppTextStyle.textXs.leading4,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.gray700),
              // Overlay color for selected days in the date picker
              dayOverlayColor: WidgetStateProperty.all(AppColors.white),
              // Styles for individual days in the date picker
              dayStyle: AppTextStyle.textXs.addAll([
                AppTextStyle.textXs.leading4,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray700),
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

  static void showIOSStyleDatePickerDialog({
    required BuildContext context,
    DateTime? selectedDate,
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
                              initialDateTime: selectedDate,
                              mode: CupertinoDatePickerMode.date,
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
