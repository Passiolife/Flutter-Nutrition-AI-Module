import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/passio_image_widget.dart';
import '../../../common/widgets/shimmer_widget.dart';

abstract interface class MealListener {
  void onTappedLogEntireMeal(
      List<PassioFoodDataInfo>? listOfPassioFoodData, PassioMealTime? mealTime);

  void onTappedMealItem(PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime);

  void onTappedAdd(PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime);
}

class MealWidget extends StatelessWidget {
  const MealWidget({
    this.title,
    this.mealTime,
    this.listOfFoodData,
    this.listener,
    this.isLoading = false,
    this.isLogMealLoading = false,
    super.key,
  });

  final String? title;
  final PassioMealTime? mealTime;
  final List<PassioFoodDataInfo>? listOfFoodData;
  final MealListener? listener;
  final bool isLoading;
  final bool isLogMealLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: AppTextStyle.textBase.addAll([
                      AppTextStyle.textBase.leading6,
                      AppTextStyle.semiBold
                    ]),
                  ),
                ),
                isLogMealLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const AppLoadingButtonWidget(),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => listener?.onTappedLogEntireMeal(
                            listOfFoodData, mealTime),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Text(
                            context.localization?.logEntireMeal ?? '',
                            style: AppTextStyle.textSm.addAll([
                              AppTextStyle.textSm.leading5,
                              AppTextStyle.medium
                            ]).copyWith(color: AppColors.indigo600Main),
                          ),
                        ),
                      )
              ],
            ),
          ),
          const Divider(color: AppColors.gray200),
          8.verticalSpace,
          ListView.separated(
            itemCount: isLoading ? 2 : listOfFoodData?.length ?? 0,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = isLoading ? null : listOfFoodData?.elementAt(index);
              return _FoodItemRowWidget(
                isLoading: isLoading,
                index: index,
                iconId: data?.iconID,
                title: data?.foodName.toUpperCaseWord,
                subtitle:
                    '${data?.nutritionPreview.servingQuantity.format() ?? ''} ${data?.nutritionPreview.servingUnit.toUpperCaseWord ?? ''} (${data?.nutritionPreview.weightQuantity.format()} ${data?.nutritionPreview.weightUnit}) | ${data?.nutritionPreview.calories ?? 0} ${context.localization?.cal.toUpperCaseWord ?? ''}',
                onTap: () => listener?.onTappedMealItem(data, mealTime),
                onTapAdd: () => listener?.onTappedAdd(data, mealTime),
              );
            },
            separatorBuilder: (context, index) {
              return 16.verticalSpace;
            },
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}

class _FoodItemRowWidget extends StatelessWidget {
  const _FoodItemRowWidget({
    required this.index,
    this.iconId,
    this.title,
    this.subtitle,
    this.onTap,
    this.onTapAdd,
    this.isLoading = false,
  });

  final int index;
  final String? iconId;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const _SkeletonWidget()
        : Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppColors.blue50,
              highlightColor: AppColors.blue50,
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    PassioImageWidget(
                      key: ValueKey(iconId),
                      iconId: iconId ?? '',
                      radius: 20.r,
                      heroTag: '$iconId$index',
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: '$title$index',
                            child: Text(
                              title ?? '',
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                                AppTextStyle.semiBold
                              ]).copyWith(color: AppColors.gray900),
                            ),
                          ),
                          subtitle?.isNotEmpty ?? false
                              ? Text(
                                  subtitle ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.textSm
                                      .copyWith(color: AppColors.gray500),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        AppImages.icPlusSolid,
                        width: 24.r,
                        height: 24.r,
                        colorFilter: const ColorFilter.mode(
                            AppColors.gray400, BlendMode.srcIn),
                      ),
                      onPressed: onTapAdd,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class _SkeletonWidget extends StatelessWidget {
  const _SkeletonWidget();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            ShimmerWidget.circular(
              height: 40.r,
              width: 40.r,
              baseColor: AppColors.gray300,
              highlightColor: AppColors.gray200,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    width: 184.w,
                    height: 14.h,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                  SizedBox(height: 4.h),
                  ShimmerWidget.rectangular(
                    width: 79.w,
                    height: 14.h,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
