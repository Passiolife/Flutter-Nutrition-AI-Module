import 'package:flutter/material.dart';

abstract class DateTimePickerUtility {
  const DateTimePickerUtility();

  /// Displays a date picker dialog that adapts to the platform (iOS/Android).
  /// [context] - The build context where the picker will be shown.
  /// [initialDate] - The initial date to show in the picker, defaults to the current date.
  /// [onDateSelected] - Callback that returns the selected date.
  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime?>? onDateSelected,
  });

  /// Displays a time picker dialog that adapts to the platform (iOS/Android).
  /// [context] - The build context where the picker will be shown.
  /// [initialTime] - The initial time to show in the picker, defaults to the current time.
  /// [onTimeSelected] - Callback that returns the selected time.
  Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay?>? onTimeSelected,
  });

  /// Displays a date and time picker dialog that adapts to the platform (iOS/Android).
  /// [context] - The build context where the picker will be shown.
  /// [initialDateTime] - The initial date and time to show in the picker, defaults to the current date and time.
  /// [onDateTimeSelected] - Callback that returns the selected date and time.
  Future<DateTime?> showDateTimePickerDialog({
    required BuildContext context,
    DateTime? initialDateTime,
    DateTime? firstDateTime,
    DateTime? lastDateTime,
    ValueChanged<DateTime?>? onDateTimeSelected,
  });
}
