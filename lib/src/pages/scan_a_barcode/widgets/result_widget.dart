import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_button_styles.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/extension/string_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/food_item_row_widget.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    required this.iconId,
    this.title,
    this.subtitle,
    this.onEdit,
    this.onLog,
    super.key,
  });

  final String iconId;
  final String? title;
  final String? subtitle;
  final VoidCallback? onEdit;
  final VoidCallback? onLog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.pv16,
      child: Column(
        children: [
          FoodItemRowWidget(
            key: ValueKey(iconId),
            data: FoodItemRowData(
              iconId: iconId,
              title: title?.toUpperCaseWord ?? '',
              subtitle: subtitle,
              padding: AppPadding.pa8,
              enableSlidable: false,
              isAddVisible: false,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonText: context.localization.edit,
                  appButtonModel: AppButtonStyles.primaryBordered,
                  onTap: onEdit,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  buttonText: context.localization.log,
                  appButtonModel: AppButtonStyles.primary,
                  onTap: onLog,
                ),
              ),
            ],
          ),
          (context.bottomPaddingValue).verticalSpace,
        ],
      ),
    );
  }
}
