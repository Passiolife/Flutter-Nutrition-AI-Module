import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';

class EditPickerWidget extends StatelessWidget {
  const EditPickerWidget({this.title, this.selectedValue, super.key});

  final String? title;
  final String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.h16,
            vertical: Dimens.h12,
          ),
          child: Text(
            title ?? '',
            style: AppStyles.style17,
          ),
        ),
        Expanded(
          child: Text(
            selectedValue ?? '',
            style: AppStyles.style17,
            textAlign: TextAlign.end,
          ),
        ),
        Dimens.w20.horizontalSpace,
      ],
    );
  }
}
