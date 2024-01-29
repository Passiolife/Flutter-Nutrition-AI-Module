import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    this.isBackVisible = false,
    this.backPageName,
    this.backPageNameColor,
    this.title,
    this.titleColor,
    this.onBackTap,
    this.foregroundColor = AppColors.passioInset,
    this.leading,
    this.leadingWidth,
    super.key,
  });

  final String? title;
  final Color? titleColor;
  final bool isBackVisible;
  final String? backPageName;
  final Color? backPageNameColor;
  final VoidCallback? onBackTap;
  final Color foregroundColor;
  final Widget? leading;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.passioBackgroundWhite,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: leadingWidth,
      leading: isBackVisible
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onBackTap,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: backPageNameColor ?? foregroundColor,
                  ),
                  Hero(
                    tag: backPageName ?? '',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        backPageName ?? '',
                        style: AppStyles.style14.copyWith(
                            color: backPageNameColor ?? foregroundColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : leading,
      title: Hero(
        tag: title ?? '',
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            title ?? '',
            style: AppStyles.style18
                .copyWith(color: titleColor ?? foregroundColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
