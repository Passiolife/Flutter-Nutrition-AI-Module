import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_picker.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/widgets/app_text_field.dart';
import 'interfaces.dart';

class DateWidget extends StatefulWidget {
  DateWidget({
    this.selectedDate,
    this.listener,
  }) : super(key: ValueKey(selectedDate));

  final DateTime? selectedDate;
  final EditFoodListener? listener;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.selectedDate != null) {
      _controller.text = widget.selectedDate?.formatToString(format12) ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(AppDimens.r16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.date ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold
            ]).copyWith(color: AppColors.gray900),
          ),
          SizedBox(height: AppDimens.h16),
          AppTextField(
            controller: _controller,
            readOnly: true,
            onTap: () {
              DateTimePicker.showAdaptive(
                context: context,
                selectedDate: widget.selectedDate,
                onDateTimeChanged: (dateTime) {
                  _controller.text = dateTime.formatToString(format12);
                  widget.listener?.onChangeDate(dateTime);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
