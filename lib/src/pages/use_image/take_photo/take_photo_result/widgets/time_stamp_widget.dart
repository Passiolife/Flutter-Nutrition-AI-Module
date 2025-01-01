import 'package:flutter/material.dart';

import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/util/date_time_utility.dart';
import '../../../../../common/widgets/text_input/primary_text_input.dart';

class TimeStampWidget extends StatefulWidget {
  const TimeStampWidget({this.initialValue, this.onSelected, super.key});
  final DateTime? initialValue;
  final ValueChanged<DateTime>? onSelected;

  @override
  State<TimeStampWidget> createState() => _TimeStampWidgetState();
}

class _TimeStampWidgetState extends State<TimeStampWidget> {

  DateTime? _selectedDate;

  String get _formattedDate {
    if (_selectedDate == null) return '';
    return _selectedDate!.isToday() ? 'Today' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  @override
  void initState() {
    _selectedDate = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimeStampWidget oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedDate = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextInput(
      key: ValueKey(_formattedDate),
      labelText: context.localization.timestamp,
      initialValue: _formattedDate,
      hintText: '',
      isDense: true,
      readOnly: true,
      onTap: () {
        setState(() {
          _selectedDate = DateTime.now();
          widget.onSelected?.call(_selectedDate!);
        });
      },
    );
  }
}
