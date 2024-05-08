import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';

class LabeledWidgetRow extends StatelessWidget {
  final String? title;
  final Widget? child;

  const LabeledWidgetRow({
    this.title,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: AppTextStyle.textSm.addAll([
              AppTextStyle.textSm.leading5,
              AppTextStyle.medium
            ]).copyWith(color: AppColors.gray500),
          ),
        ),
        Expanded(child: child ?? const SizedBox.shrink()),
      ],
    );
  }
}
