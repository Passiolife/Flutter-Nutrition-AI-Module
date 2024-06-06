import 'package:flutter/material.dart';

import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/custom_calendar_app_bar_widget.dart';
import 'interfaces.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    required this.selectedDate,
    this.userName,
    this.listener,
    super.key,
  });

  final DateTime selectedDate;
  final String? userName;
  final HomeListener? listener;

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(
      title: '${context.localization?.welcome} ${userName ?? ''}!',
      children: [
        CustomCalendarAppBarWidget(
          selectedDate: selectedDate,
          onDateTimeChanged: (date) => listener?.onDateChanged.call(date, true),
        ),
      ],
    );
  }
}
