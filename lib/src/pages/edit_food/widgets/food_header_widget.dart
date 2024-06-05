import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/chart_model/chart_data_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/nutritional_graph_widget.dart';
import '../../../common/widgets/passio_image_widget.dart';

abstract interface class FoodHeaderListener {
  void onOpenFoodFactsTapped();
  void onMoreDetailsTapped();
  void onFavoriteChanged(bool isFavorite);
}

class FoodHeaderWidget extends StatelessWidget {
  FoodHeaderWidget({
    required this.iconId,
    this.title,
    this.subtitle,
    this.entityType = PassioIDEntityType.item,
    this.calories = 0,
    this.carbs = 0,
    this.proteins = 0,
    this.fat = 0,
    this.isFavorite = false,
    this.visibleFavorite = true,
    this.visibleOpenFoodFacts = true,
    this.visibleMoreDetails = true,
    this.iconHeroTag,
    this.titleHeroTag,
    this.subTitleHeroTag,
    this.listener,
  }) : super(
            key: ValueKey(
                '$iconId-$title-$subtitle-$calories-$carbs-$proteins-$fat'));

  final String iconId;
  final String? title;
  final String? subtitle;
  final double calories;
  final double carbs;
  final double proteins;
  final double fat;
  final bool isFavorite;
  final FoodHeaderListener? listener;
  final PassioIDEntityType entityType;
  final bool visibleOpenFoodFacts;
  final bool visibleMoreDetails;
  final bool visibleFavorite;

  // Hero tags
  final String? iconHeroTag;
  final String? titleHeroTag;
  final String? subTitleHeroTag;

  List<ChartDataModel>? get chartData => [
        ChartDataModel(
            y: _fatPercentage,
            color: _fatPercentage > 0
                ? AppColors.purple500
                : AppColors.transparent),
        ChartDataModel(
            y: _proteinsPercentage,
            color: _proteinsPercentage > 0
                ? AppColors.green500Normal
                : AppColors.transparent),
        ChartDataModel(
            y: _carbsPercentage,
            color: _carbsPercentage > 0
                ? AppColors.lBlue500Normal
                : AppColors.transparent),
        ChartDataModel(
          y: _fatPercentage <= 0 &&
                  _proteinsPercentage <= 0 &&
                  _carbsPercentage <= 0
              ? 100
              : 0,
          color: AppColors.gray200,
        ),
      ];

  double get sum => 4 * (carbs + proteins) + 9 * fat;

  double get _carbsPercentage => carbs > 0 ? (4 * carbs / sum * 100) : 0;

  double get _proteinsPercentage =>
      proteins > 0 ? (4 * proteins / sum * 100) : 0;

  double get _fatPercentage => fat > 0 ? (9 * fat / sum * 100) : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(AppDimens.r16),
                child: Row(
                  children: [
                    PassioImageWidget(
                      key: ValueKey(iconId),
                      iconId: iconId,
                      radius: AppDimens.r20,
                      type: entityType,
                    ),
                    SizedBox(width: AppDimens.w8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: titleHeroTag ?? UniqueKey(),
                            child: Text(
                              title?.toUpperCaseWord ?? '',
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                                AppTextStyle.semiBold,
                              ]).copyWith(color: AppColors.gray900),
                              softWrap: true,
                            ),
                          ),
                          (subtitle?.isNotEmpty ?? false)
                              ? Hero(
                                  tag: subTitleHeroTag ?? UniqueKey(),
                                  child: Text(
                                    subtitle ?? '',
                                    style: AppTextStyle.textSm.addAll([
                                      AppTextStyle.textSm.leading5,
                                    ]).copyWith(color: AppColors.gray500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(width: AppDimens.w16),
                  ],
                ),
              ),
              Visibility(
                visible: visibleFavorite,
                child: Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => listener?.onFavoriteChanged(isFavorite),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.r, right: 8.r),
                      child: SvgPicture.asset(
                        isFavorite
                            ? AppImages.icFavoriteFilled
                            : AppImages.icFavoriteOutline,
                        width: AppDimens.r20,
                        height: AppDimens.r20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.indigo600Main, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          NutritionalGraphWidget(
            key: ValueKey('$calories-$carbs-$proteins-$fat'),
            calories: calories,
            carbs: carbs,
            carbsPercentage: _carbsPercentage,
            proteins: proteins,
            proteinsPercentage: _proteinsPercentage,
            fat: fat,
            fatPercentage: _fatPercentage,
            chartData: chartData,
          ),
          Visibility(
            visible: visibleOpenFoodFacts || visibleMoreDetails,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppDimens.r16,
                left: AppDimens.r16,
                right: AppDimens.r16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: visibleOpenFoodFacts,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => listener?.onOpenFoodFactsTapped(),
                      child: Text(
                        context.localization?.openFoodFacts ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading5,
                        ]).copyWith(
                          color: AppColors.indigo600Main,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.indigo600Main,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleMoreDetails,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => listener?.onMoreDetailsTapped(),
                      child: Text(
                        context.localization?.moreDetails ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading5,
                        ]).copyWith(
                          color: AppColors.indigo600Main,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.indigo600Main,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimens.h16),
        ],
      ),
    );
  }
}
