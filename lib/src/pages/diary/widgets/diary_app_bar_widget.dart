import 'package:flutter/material.dart';

import '../../../common/util/context_extension.dart';
import '../../../common/util/date_picker.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/custom_calendar_app_bar_widget.dart';

class DiaryAppBarWidget extends StatelessWidget {
  const DiaryAppBarWidget({
    required this.selectedDate,
    this.onDateTimeChanged,
    super.key,
  });

  final DateTime selectedDate;
  final OnDateTimeChanged? onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(
      title: context.localization?.myDiary,
      children: [
        CustomCalendarAppBarWidget(
          selectedDate: selectedDate,
          onDateTimeChanged: onDateTimeChanged,
        ),
      ],
    );
  }
}
