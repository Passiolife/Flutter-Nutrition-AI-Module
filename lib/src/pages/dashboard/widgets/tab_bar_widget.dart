import 'package:flutter/material.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';

class TabBarWidgetDelegate extends SliverPersistentHeaderDelegate {
  TabBarWidgetDelegate({required this.controller, required this.tabs});

  final TabController controller;
  final List<String> tabs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
      child: Container(
        height: Dimens.h40,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.passioBlack10,
          borderRadius: BorderRadius.circular(Dimens.r4),
        ),
        padding: EdgeInsets.all(Dimens.r2),
        child: TabBar(
          padding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: AppColors.customBase,
            border: null,
            borderRadius: BorderRadius.circular(Dimens.r4),
          ),
          controller: controller,
          labelStyle: AppStyles.style12,
          unselectedLabelStyle: AppStyles.style12,
          unselectedLabelColor: AppColors.blackColor,
          labelColor: AppColors.passioInset,
          labelPadding: EdgeInsets.zero,
          tabs: List.generate(
            tabs.length,
            (index) => SizedBox(
              width: double.infinity,
              height: Dimens.h40,
              child: Tab(
                text: tabs.elementAt(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => Dimens.h40;

  @override
  double get minExtent => Dimens.h40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
