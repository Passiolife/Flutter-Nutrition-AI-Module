import 'package:flutter/material.dart';

import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/date_time_extension.dart';
import '../../../../../common/util/date_picker.dart';
// import '../../../../../common/util/date_time_utility.dart';
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
    return _selectedDate!.isToday ? 'Today' : '${_selectedDate?.formatToString(DateFormatStrings.monthDayYear)}';
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
      labelText: context.localization.date,
      initialValue: _formattedDate,
      hintText: '',
      isDense: true,
      readOnly: true,
      onTap: () {
        DatePicker.showAdaptive(context: context, selectedDate: _selectedDate, onDateTimeChanged: (dateTime) {
          setState(() {
            _selectedDate = dateTime;
            widget.onSelected?.call(_selectedDate!);
          });
        });
      },
    );
  }
}
