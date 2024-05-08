import 'package:flutter/material.dart';

import '../constant/app_constants.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({required this.tabs, this.controller, super.key});

  final List<Tab> tabs;
  final TabController? controller;

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
        child: TabBar(
          padding: EdgeInsets.zero,
          controller: controller,
          tabs: tabs,
        ),
      ),
    );
  }
}
