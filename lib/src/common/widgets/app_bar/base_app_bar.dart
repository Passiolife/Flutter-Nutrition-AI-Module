import 'package:flutter/material.dart';

import '../../constant/app_constants.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    this.centerTitle = true,
    this.title,
    this.backgroundColor = AppColors.white,
    this.actions,
    this.iconTheme,
    super.key,
  });

  final bool centerTitle;
  final Widget? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      iconTheme: iconTheme,
      title: title,
      actions: actions,
    );
  }
}
