import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/macro_item_model.dart';
import '../../../../../common/util/double_extensions.dart';

class MacrosValuesWidget extends StatelessWidget {
  const MacrosValuesWidget({required this.macros, super.key});

  final List<MacroItemModel> macros;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: macros
            .expand<Widget>((e) => [_MacrosItemWidget(macro: e)])
            .toList(),
      ),
    );
  }
}

class _MacrosItemWidget extends StatelessWidget {
  const _MacrosItemWidget({required this.macro, super.key});

  final MacroItemModel macro;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          macro.value.format(),
          style: AppTextStyle.textBase.addAll([
            AppTextStyle.textBase.leading6,
            AppTextStyle.bold
          ]).copyWith(color: macro.color),
        ),
        4.horizontalSpace,
        Text(
          macro.label,
          style: AppTextStyle.textBase
              .copyWith(color: context.textThemeColors.brandTextLight),
        ),
      ],
    );
  }
}
