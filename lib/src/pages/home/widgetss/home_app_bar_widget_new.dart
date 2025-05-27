import 'package:flutter/material.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/util/date_picker.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/date_time/custom_calendar_app_bar_widget.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    required this.selectedDate,
    this.userName,
    this.onDateChanged,
    super.key,
  });

  final DateTime selectedDate;
  final String? userName;
  final OnDateTimeChanged? onDateChanged;

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(
      title: '${context.localization.welcome} ${userName ?? ''}!',
      children: [
        CustomCalendarAppBarWidget(
          selectedDate: selectedDate,
          onDateTimeChanged: onDateChanged,
        ),
      ],
    );
  }
}
