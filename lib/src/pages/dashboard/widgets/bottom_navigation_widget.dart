import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/constant/app_text_styles.dart';
import '../../../common/util/context_extension.dart';

class NavigationItem {
  final String imagePath;
  final String name;
  final bool isSelected;

  // Constructor for NavigationItem class
  const NavigationItem({
    required this.imagePath,
    required this.name,
    this.isSelected = false,
  });
}

// Callback function type for when a navigation item changes
typedef OnNavigationItemChange = Function(NavigationItem? item, int index);

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    this.selectedPage,
    this.onNavigationItemChange,
    super.key,
  });

  final String? selectedPage;
  final OnNavigationItemChange? onNavigationItemChange;

  // Create a list of NavigationItem objects
  List<NavigationItem> navigationItems(BuildContext context) => [
        // Home NavigationItem
        NavigationItem(
          imagePath: AppImages.icHome,
          name: context.localization?.home ?? '',
          isSelected: (selectedPage != null)
              ? (selectedPage == context.localization?.home)
              : true,
        ),
        // Diary NavigationItem
        NavigationItem(
          imagePath: AppImages.icDiary,
          name: context.localization?.diary ?? '',
          isSelected: (selectedPage != null)
              ? (selectedPage == context.localization?.diary)
              : false,
        ),
        // To show empty space in center for notch button.
        const NavigationItem(
          imagePath: '',
          name: '',
          isSelected: false,
        ),
        // Meal Plan NavigationItem
        NavigationItem(
          imagePath: AppImages.icMealPlan,
          name: context.localization?.mealPlan ?? '',
          isSelected: (selectedPage != null)
              ? (selectedPage == context.localization?.mealPlan)
              : false,
        ),
        // Progress NavigationItem
        NavigationItem(
          imagePath: AppImages.icProgress,
          name: context.localization?.progress ?? '',
          isSelected: (selectedPage != null)
              ? (selectedPage == context.localization?.progress)
              : false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.only(
        top: AppDimens.h16,
        bottom: context.bottomPadding + AppDimens.h16,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: navigationItems(context)
              .asMap()
              .map(
                (index, item) => MapEntry(
                  index,
                  (index == 2)
                      ? SizedBox(
                          width: AppDimens.r56,
                          height: AppDimens.r56,
                        )
                      : _BottomNavigationItem(
                          index: index,
                          navigationItem: item,
                          onNavigationItemChange: onNavigationItemChange,
                        ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.index,
    required this.navigationItem,
    this.onNavigationItemChange,
  });

  final int index;
  final NavigationItem? navigationItem;
  final OnNavigationItemChange? onNavigationItemChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onNavigationItemChange?.call(navigationItem, index),
      child: SizedBox(
        width: AppDimens.w79,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SVG icon for the navigation item
            SvgPicture.asset(
              navigationItem?.imagePath ?? '',
              width: AppDimens.r24,
              height: AppDimens.w24,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(
                (navigationItem?.isSelected ?? false)
                    ? AppColors.indigo500Normal
                    : AppColors.gray400,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: AppDimens.h8),
            // Text label for the navigation item
            Text(
              navigationItem?.name ?? '',
              style: AppTextStyle.textXs.copyWith(
                color: (navigationItem?.isSelected ?? false)
                    ? AppColors.indigo600Main
                    : AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
