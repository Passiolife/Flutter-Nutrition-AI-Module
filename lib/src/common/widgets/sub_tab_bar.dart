import 'package:flutter/material.dart';

import '../constant/app_constants.dart';

abstract interface class TabChangeListener {
  void onTabChange(String tab);
}

class SubTabBar extends StatelessWidget {
  const SubTabBar({
    required this.tabs,
    this.selectedTab,
    this.onTabChange,
    super.key,
  });

  final List<String?> tabs;
  final String? selectedTab;
  final TabChangeListener? onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      height: AppDimens.h42,
      child: Row(
        children: tabs
            .map((e) => _TabRow(
                  isActive: e == selectedTab,
                  text: e,
                  onTap: () => onTabChange?.onTabChange(e ?? ''),
                ))
            .toList(),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    this.isActive = false,
    this.text,
    this.onTap,
  });

  final bool isActive;
  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: AppColors.blue50,
        highlightColor: AppColors.blue50,
        onTap: onTap,
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.indigo600Main,
                  borderRadius: BorderRadius.circular(AppDimens.r6),
                )
              : null,
          child: Center(
            child: Text(
              text ?? '',
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.medium
              ]).copyWith(
                  color: isActive ? AppColors.white : AppColors.gray700),
            ),
          ),
        ),
      ),
    );
  }
}
