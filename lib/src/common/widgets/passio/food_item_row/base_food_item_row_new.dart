import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constant/app_constants.dart';
import '../../loading/shimmer_loading.dart';

class BaseFoodItemRow extends StatelessWidget {
  const BaseFoodItemRow({
    this.index,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.rippleColor,
    this.isLoading = false,
    this.enableSlidable = false,
    this.endActionPane,
    super.key,
  });

  final int? index;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final bool isLoading;
  final bool enableSlidable;
  final ActionPane? endActionPane;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enableSlidable,
      key: UniqueKey(),
      endActionPane: endActionPane,
      child: ShimmerLoading(
        isLoading: isLoading,
        child: Container(
          decoration: AppShadows.base,
          child: Material(
            color: Colors.transparent,
            borderRadius: AppShadows.base.borderRadius,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0,
              onTap: onTap,
              leading: leading,
              title: title,
              subtitle: subtitle,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }
}
