/*
import 'package:flutter/material.dart';

class AdaptiveDateTimePicker implements DateTimePickerUtility {
  final DateTimePickerUtility _pickerUtility;

  AdaptiveDateTimePicker(BuildContext context)
      : _pickerUtility = Theme.of(context).platform == TargetPlatform.iOS
      ? CupertinoDateTimePicker()
      : MaterialDateTimePicker();

  @override
  Future<void> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
  }) async {
    return _pickerUtility.showDatePicker(
      context: context,
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    );
  }

  @override
  Future<void> showTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onTimeSelected,
  }) async {
    return _pickerUtility.showTimePicker(
      context: context,
      initialTime: initialTime,
      onTimeSelected: onTimeSelected,
    );
  }

  @override
  Future<void> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateTimeSelected,
  }) async {
    return _pickerUtility.showDateTimePicker(
      context: context,
      initialDate: initialDate,
      onDateTimeSelected: onDateTimeSelected,
    );
  }
}*/
