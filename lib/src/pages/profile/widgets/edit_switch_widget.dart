import 'package:flutter/cupertino.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';

typedef OnChangeSegment = void Function(String? value);

class EditSwitchWidget extends StatelessWidget {
  const EditSwitchWidget({
    required this.items,
    this.title,
    this.selected,
    this.onChangeSegment,
    super.key,
  });

  final String? title;
  final List<String?> items;
  final String? selected;
  final OnChangeSegment? onChangeSegment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.w16, vertical: Dimens.h12),
          child: Text(
            title ?? '',
            style: AppStyles.style17,
          ),
        ),
        const Spacer(),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimens.w16, vertical: Dimens.h8),
          child: CupertinoSlidingSegmentedControl<String>(
            // This represents the currently selected segmented control.
            groupValue: selected,
            backgroundColor: AppColors.passioInset,
            thumbColor: AppColors.customBase,
            children: {
              for (var v in items)
                (v)?.toLowerCase() ?? '': Text(
                  v ?? '',
                  style: AppStyles.style12.copyWith(
                      color: selected?.toLowerCase() == (v)?.toLowerCase()
                          ? AppColors.passioInset
                          : AppColors.blackColor),
                )
            },
            onValueChanged: (value) => onChangeSegment?.call(value),
          ),
        ),
      ],
    );
  }
}
