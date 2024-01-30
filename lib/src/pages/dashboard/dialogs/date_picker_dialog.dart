import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

typedef OnTapSave = Function(DateTime dateTime);

class LogDatePickerDialog {
  LogDatePickerDialog.show({required BuildContext context, required DateTime initialDate, OnTapSave? onTapSave}) {
    DateTime selectedDate = initialDate;
    if (Platform.isIOS) {
      /// Display a CupertinoDatePicker in date picker mode.
      showCupertinoModalPopup<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) => Container(
          height: context.height,
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: Container(
              color: AppColors.passioLowContrast,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: Dimens.h214,
                    child: CupertinoDatePicker(
                      initialDateTime: selectedDate,
                      mode: CupertinoDatePickerMode.date,
                      // This shows day of week alongside day of month
                      showDayOfWeek: true,
                      dateOrder: DatePickerDateOrder.dmy,
                      maximumDate: DateTime.now(),
                      // This is called when the user changes the date.
                      onDateTimeChanged: (DateTime newDate) {
                        selectedDate = newDate;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                          child: AppButton(
                            buttonName: context.localization?.today ?? '',
                            onTap: () {
                              Navigator.pop(dialogContext);
                              selectedDate = DateTime.now();
                              onTapSave?.call(selectedDate);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                          child: AppButton(
                            buttonName: context.localization?.ok ?? '',
                            onTap: () {
                              Navigator.pop(dialogContext);
                              onTapSave?.call(selectedDate);
                              // widget.onDateChange?.call(_selectedDate);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.h8),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2018),
        lastDate: DateTime.now(),
      ).then((newDate) {
        if (newDate != null) {
          selectedDate = newDate;
        }
      });
    }
  }
}
