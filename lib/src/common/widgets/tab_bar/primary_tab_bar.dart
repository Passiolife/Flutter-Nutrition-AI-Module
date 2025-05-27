import 'package:flutter/material.dart';

import '../../constant/app_constants.dart';
import 'base_tab_bar.dart';

class PrimaryTabBar extends StatelessWidget {
  const PrimaryTabBar({
    required this.tabs,
    this.tabController,
    this.onTap,
    this.initialIndex = 0,
    super.key,
  });

  final List<Tab> tabs;
  final int initialIndex;
  final TabController? tabController;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        tabBarTheme: TabBarTheme(
          indicatorColor: AppColors.indigo600Main,
          labelStyle: AppTextStyle.textXl.addAll([
            AppTextStyle.textXl.leading7,
            AppTextStyle.semiBold
          ]).copyWith(color: AppColors.indigo600Main),
          unselectedLabelStyle: AppTextStyle.textXl
              .addAll([AppTextStyle.textXl.leading7]).copyWith(
              color: AppColors.gray900),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      child: Container(
        decoration: AppShadows.base,
        child: BaseTabBar(
          initialIndex: initialIndex,
          controller: tabController,
          tabs: tabs,
          onTap: onTap,
        ),
      ),
    );
  }
}
