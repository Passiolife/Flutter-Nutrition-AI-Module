import 'package:flutter/material.dart';

import 'date_time_picker_utility.dart';

class MaterialDateTimePicker implements DateTimePickerUtility {
  const MaterialDateTimePicker();

  @override
  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime?>? onDateSelected,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999, 12, 31),
    );

    if (onDateSelected != null) {
      onDateSelected(pickedDate);
    }
    return pickedDate;
  }

  @override
  Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay?>? onTimeSelected,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (onTimeSelected != null) {
      onTimeSelected(pickedTime);
    }
    return pickedTime;
  }

  @override
  Future<DateTime?> showDateTimePickerDialog({
    required BuildContext context,
    DateTime? initialDateTime,
    DateTime? firstDateTime,
    DateTime? lastDateTime,
    ValueChanged<DateTime?>? onDateTimeSelected,
  }) async {
    // Step 1: Get date
    DateTime? pickedDate = await showDatePickerDialog(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
    );

    // Early return if date selection was cancelled
    if (pickedDate == null || !context.mounted) {
      onDateTimeSelected?.call(null);
      return null;
    }

    // Step 2: Get time
    final initialTime = initialDateTime != null
        ? TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute)
        : TimeOfDay.now();

    final pickedTime =
        await showTimePickerDialog(context: context, initialTime: initialTime);

    // Early return if time selection was cancelled
    if (pickedTime == null) {
      onDateTimeSelected?.call(null);
      return null;
    }

    // Combine date and time into final result
    final combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Notify callback if provided
    onDateTimeSelected?.call(combinedDateTime);

    return combinedDateTime;
  }
}
