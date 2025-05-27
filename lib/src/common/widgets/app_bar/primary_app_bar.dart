import 'package:flutter/material.dart';

import '../../constant/app_constants.dart';
import '../../extension/core_extension.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    this.centerTitle = true,
    this.title,
    this.backgroundColor = AppColors.white,
    this.actions,
    this.iconTheme,
    super.key,
  });

  final bool centerTitle;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      iconTheme: iconTheme ??
          IconThemeData(color: context.iconThemeColors.brandIconLight),
      title: title != null
          ? Text(
              title!,
              style: AppTextStyle.text2xl.addAll([
                AppTextStyle.text2xl.leading8,
                AppTextStyle.extraBold,
              ]).copyWith(color: context.textThemeColors.brandTextDark),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
