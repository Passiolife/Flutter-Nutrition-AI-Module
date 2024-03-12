import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_picker.dart';
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
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimens.h40),
          CustomAppBarWidget(
            title: context.localization?.myDiary,
            isMenuVisible: false,
          ),
          CustomCalendarAppBarWidget(
            selectedDate: selectedDate,
            onDateTimeChanged: onDateTimeChanged,
          ),
        ],
      ),
    );
  }
}
