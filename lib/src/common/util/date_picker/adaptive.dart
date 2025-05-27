
import 'dart:io';

import 'package:flutter/material.dart';

import 'cupertino_date_timer_picker.dart';
import 'date_time_picker_utility.dart';
import 'material_date_time_picker.dart';

class AdaptiveDateTimePicker implements DateTimePickerUtility {
  final DateTimePickerUtility _pickerUtility;

  AdaptiveDateTimePicker()
      : _pickerUtility = Platform.isIOS
      ? CupertinoDateTimePicker()
      : MaterialDateTimePicker();

  @override
  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime?>? onDateSelected,
  }) async {
    return _pickerUtility.showDatePickerDialog(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateSelected: onDateSelected,
    );
  }

  @override
  Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay?>? onTimeSelected,
  }) async {
    return _pickerUtility.showTimePickerDialog(
      context: context,
      initialTime: initialTime,
      onTimeSelected: onTimeSelected,
    );
  }

  @override
  Future<DateTime?> showDateTimePickerDialog({
    required BuildContext context,
    DateTime? initialDateTime,
    DateTime? firstDateTime,
    DateTime? lastDateTime,
    ValueChanged<DateTime?>? onDateTimeSelected,
  }) async {
    return _pickerUtility.showDateTimePickerDialog(
      context: context,
      initialDateTime: initialDateTime,
      firstDateTime: firstDateTime,
      lastDateTime: lastDateTime,
      onDateTimeSelected: onDateTimeSelected,
    );
  }
}
