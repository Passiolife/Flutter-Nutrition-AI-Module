import 'package:flutter/material.dart';

import '../../../pages/scan_a_barcode/widgets/help_widget.dart';
import '../../constant/app_colors.dart';
import '../../constant/app_padding.dart';
import '../../constant/app_text_styles.dart';
import '../../extension/context_extension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.centerTitle = true,
    this.title,
    this.backgroundColor = AppColors.transparent,
    this.actions,
    super.key,
  });

  final bool centerTitle;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph8,
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: context.iconThemeColors.brandIconLight),
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
      ),
    );
  }
}
