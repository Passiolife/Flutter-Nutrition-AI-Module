import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_time_picker_utility.dart';

class CupertinoDateTimePicker implements DateTimePickerUtility {
  const CupertinoDateTimePicker();

  @override
  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime?>? onDateSelected,
  }) async {
    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () =>
                        Navigator.pop(context, initialDate ?? DateTime.now()),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate ?? DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    initialDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && onDateSelected != null) {
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
    final TimeOfDay? pickedTime = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () =>
                        Navigator.pop(context, initialTime ?? TimeOfDay.now()),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    initialTime?.hour ?? TimeOfDay.now().hour,
                    initialTime?.minute ?? TimeOfDay.now().minute,
                  ),
                  onDateTimeChanged: (DateTime newTime) {
                    initialTime = TimeOfDay.fromDateTime(newTime);
                  },
                ),
              ),
            ],
          ),
        );
      },
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
