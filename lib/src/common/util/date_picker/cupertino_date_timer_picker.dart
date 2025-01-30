/*
import 'package:flutter/cupertino.dart';

class CupertinoDateTimePicker implements DateTimePickerUtility {
  @override
  Future<void> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
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
                    onPressed: () => Navigator.pop(context, initialDate ?? DateTime.now()),
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
  }

  @override
  Future<void> showTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onTimeSelected,
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
                    onPressed: () => Navigator.pop(context, initialTime ?? TimeOfDay.now()),
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

    if (pickedTime != null && onTimeSelected != null) {
      onTimeSelected(pickedTime);
    }
  }

  @override
  Future<void> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateTimeSelected,
  }) async {
    // Combine date and time pickers for Cupertino
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );

      if (pickedTime != null && onDateTimeSelected != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(selectedDateTime);
      }
    }
  }
}*/
