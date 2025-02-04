import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../extension/context_extension.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/secondary_button.dart';

enum DateTimePickerMode { date, time, dateAndTime }

typedef OnDateTimeChanged = Function(DateTime dateTime);

class DateTimePicker {
  const DateTimePicker._();

  static Future<void> showAdaptive({
    required BuildContext context,
    required DateTimePickerMode mode,
    DateTime? initialDateTime,
    OnDateTimeChanged? onDateTimeChanged,
  }) async {
    final DateTime initial = initialDateTime ?? DateTime.now();

    if (Platform.isIOS) {
      _showIOSPicker(
        context: context,
        mode: mode,
        initialDateTime: initial,
        onDateTimeChanged: onDateTimeChanged,
      );
    } else {
      final DateTime? result = await _showAndroidPicker(
        context: context,
        mode: mode,
        initialDateTime: initial,
      );

      if (result != null) {
        onDateTimeChanged?.call(result);
      }
    }
  }

  static Future<DateTime?> _showAndroidPicker({
    required BuildContext context,
    required DateTimePickerMode mode,
    required DateTime initialDateTime,
  }) async {
    switch (mode) {
      case DateTimePickerMode.date:
        return await _showAndroidDatePicker(context, initialDateTime);
      case DateTimePickerMode.time:
        return await _showAndroidTimePicker(context, initialDateTime);
      case DateTimePickerMode.dateAndTime:
        final DateTime? date =
            await _showAndroidDatePicker(context, initialDateTime);
        if (date == null) return null;

        final DateTime? time = await _showAndroidTimePicker(context, date);
        return time;
    }
  }

  static Future<DateTime?> _showAndroidDatePicker(
    BuildContext context,
    DateTime initialDate,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => _androidThemeWrapper(context, child),
    );
  }

  static Future<DateTime?> _showAndroidTimePicker(
    BuildContext context,
    DateTime initialTime,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
      builder: (context, child) => _androidThemeWrapper(context, child),
    );

    return time?.toDateTime(initialTime);
  }

  static Widget _androidThemeWrapper(BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.indigo600Main,
          onPrimary: Colors.white,
          surface: AppColors.white,
          onSurface: AppColors.gray600,
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.white,
          hourMinuteTextColor: AppColors.gray900,
          dayPeriodTextColor: AppColors.gray700,
          dialHandColor: AppColors.indigo600Main,
        ),
        // Keep existing date picker theme configuration
      ),
      child: child!,
    );
  }

  static void _showIOSPicker({
    required BuildContext context,
    required DateTimePickerMode mode,
    required DateTime initialDateTime,
    OnDateTimeChanged? onDateTimeChanged,
  }) {
    DateTime updatedDateTime = initialDateTime;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => _iosPickerContainer(
        context,
        updatedDateTime,
        mode,
        onDateTimeChanged,
      ),
    );
  }

  static Widget _iosPickerContainer(
    BuildContext context,
    DateTime initialDateTime,
    DateTimePickerMode mode,
    OnDateTimeChanged? onChanged,
  ) {
    DateTime updatedDateTime = initialDateTime;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: AppColors.black75Opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 280,
                      child: CupertinoDatePicker(
                        initialDateTime: initialDateTime,
                        mode: mode.toCupertinoMode(),
                        onDateTimeChanged: (dt) => updatedDateTime = dt,
                      ),
                    ),
                    Material(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                text: context.localization.cancel,
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton(
                                text: context.localization.save,
                                onTap: () => _handleIOSPickerSelection(
                                  context,
                                  updatedDateTime,
                                  onChanged,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    // _iosPickerButtons(context, updatedDateTime, onChanged),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _iosPickerButtons(
    BuildContext context,
    DateTime selectedDateTime,
    OnDateTimeChanged? onChanged,
  ) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: context.localization.cancel,
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                text: context.localization.save,
                onTap: () => _handleIOSPickerSelection(
                  context,
                  selectedDateTime,
                  onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _handleIOSPickerSelection(
    BuildContext context,
    DateTime dateTime,
    OnDateTimeChanged? onChanged,
  ) {
    onChanged?.call(dateTime);
    Navigator.pop(context);
  }
}

extension on DateTimePickerMode {
  CupertinoDatePickerMode toCupertinoMode() {
    switch (this) {
      case DateTimePickerMode.date:
        return CupertinoDatePickerMode.date;
      case DateTimePickerMode.time:
        return CupertinoDatePickerMode.time;
      case DateTimePickerMode.dateAndTime:
        return CupertinoDatePickerMode.dateAndTime;
    }
  }
}

extension on TimeOfDay {
  DateTime toDateTime(DateTime initialDate) {
    return DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
      hour,
      minute,
    );
  }
}
