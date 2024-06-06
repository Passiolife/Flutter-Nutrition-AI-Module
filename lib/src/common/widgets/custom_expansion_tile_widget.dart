import 'package:flutter/material.dart';

import '../constant/app_constants.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  const CustomExpansionTileWidget({
    this.title,
    this.children = const [],
    this.initiallyExpanded = false,
    super.key,
  });

  final String? title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Theme(
        data: ThemeData(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.r16),
          ),
          collapsedShape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.r16),
          ),
          title: Text(
            title ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]).copyWith(color: AppColors.gray900),
          ),
          children: [
            children.isNotEmpty
                ? const Divider(color: AppColors.gray200)
                : const SizedBox.shrink(),
            Column(children: children),
            children.isNotEmpty
                ? SizedBox(height: AppDimens.h8)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
