import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../dialogs/date_picker_dialog.dart';

typedef OnDateChange = Function(DateTime dateTime);

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DashboardAppBar(
      {required this.selectedDateTime,
      this.onDateChange,
      this.onTapMore,
      super.key});

  /// [onTapMore] will executes when gesture detector calls.
  final OnDateChange? onDateChange;

  /// [onTapMore] will executes when gesture detector calls.
  final VoidCallback? onTapMore;

  final DateTime selectedDateTime;

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.passioBackgroundWhite,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: GestureDetector(
        onTap: () => _showDatePicker(context),
        child: Text(
          _selectedDate.format(format8),
          style: AppStyles.style17,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: widget.onTapMore,
          behavior: HitTestBehavior.translucent,
          child: Text(
            context.localization?.more ?? '',
            // navigatorKey.currentContext?.localization?.more ?? '',
            style: AppStyles.style17,
          ),
        ),
        Dimens.w8.horizontalSpace,
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    LogDatePickerDialog.show(
      context: context,
      initialDate: _selectedDate,
      onTapSave: (date) {
        setState(() {
          _selectedDate = date;
          widget.onDateChange?.call(_selectedDate);
        });
      },
    );
  }
}
