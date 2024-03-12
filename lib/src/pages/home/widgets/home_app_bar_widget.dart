import 'package:flutter/material.dart';

import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_picker.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/custom_calendar_app_bar_widget.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    required this.selectedDate,
    this.onDateTimeChanged,
    this.customAppBarKey,
    super.key,
  });

  final DateTime selectedDate;
  final OnDateTimeChanged? onDateTimeChanged;
  final GlobalKey? customAppBarKey;

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
            key: customAppBarKey,
            title: '${context.localization?.welcome} Sahil!',
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
