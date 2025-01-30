/*
import 'package:flutter/material.dart';

class MaterialDateTimePicker implements DateTimePickerUtility {
  @override
  Future<void> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
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
    // Combine date and time pickers for Material
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
