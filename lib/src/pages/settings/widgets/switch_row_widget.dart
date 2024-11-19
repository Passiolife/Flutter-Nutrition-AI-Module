import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/app_switch.dart';

class SwitchRowWidget extends StatelessWidget {
  final String? title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchRowWidget({
    super.key,
    this.title,
    this.value = false,
    this.onChanged,
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
        AppSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
