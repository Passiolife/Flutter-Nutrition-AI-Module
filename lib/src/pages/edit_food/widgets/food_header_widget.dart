import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/chart_model/chart_data_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'interfaces.dart';

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
  final EditFoodListener? listener;
  final PassioIDEntityType entityType;
  final bool visibleOpenFoodFacts;
  final bool visibleMoreDetails;

  // Hero tags
  final String? iconHeroTag;
  final String? titleHeroTag;
  final String? subTitleHeroTag;

  List<ChartDataModel>? get chartData => [
        ChartDataModel(y: 3, color: AppColors.purple500),
        ChartDataModel(y: 11, color: AppColors.green500Normal),
        ChartDataModel(y: 19, color: AppColors.lBlue500Normal),
      ];

  double get sum => 4 * (carbs + proteins) + 9 * fat;

  double get _carbsPercentage => (4 * carbs / sum * 100);

  double get _proteinsPercentage => (4 * proteins / sum * 100);

  double get _fatPercentage => (9 * fat / sum * 100);

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
                      iconId: iconId,
                      radius: AppDimens.r20,
                      heroTag: iconHeroTag,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              Positioned(
                top: AppDimens.r8,
                right: AppDimens.r8,
                child: GestureDetector(
                  onTap: () => listener?.onChangeFavorite(false),
                  child: SvgPicture.asset(
                    AppImages.icFavoriteFilled,
                    width: AppDimens.r20,
                    height: AppDimens.r20,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DonutGraph(
                key: UniqueKey(),
                chartData: chartData,
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${calories.round()}',
                      maxLines: 1,
                      style: AppTextStyle.text2xl.addAll([
                        AppTextStyle.text2xl.leading8,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.yellow500),
                    ),
                    Text(
                      context.localization?.calories ?? '',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading4,
                        AppTextStyle.medium
                      ]).copyWith(color: AppColors.gray900),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimens.w16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${context.localization?.carbs ?? ''}:',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading4,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.gray900),
                  ),
                  SizedBox(height: AppDimens.h8),
                  Text(
                    '${context.localization?.protein ?? ''}:',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading4,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.gray900),
                  ),
                  SizedBox(height: AppDimens.h8),
                  Text(
                    '${context.localization?.fat ?? ''}:',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading4,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.gray900),
                  ),
                ],
              ),
              SizedBox(width: AppDimens.w4),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${carbs.formatNumber()} ${context.localization?.g}',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.lBlue500Normal),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SizedBox(width: AppDimens.w4),
                        ),
                        TextSpan(
                          text:
                              '(${_carbsPercentage.formatNumber()}%)',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                          ]).copyWith(color: AppColors.gray500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.h4),
                  Text.rich(
                    TextSpan(
                      text: '${proteins.formatNumber()} ${context.localization?.g}',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.green500Normal),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SizedBox(width: AppDimens.w4),
                        ),
                        TextSpan(
                          text:
                              '(${_proteinsPercentage.formatNumber()}%)',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                          ]).copyWith(color: AppColors.gray500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.h4),
                  Text.rich(
                    TextSpan(
                      text: '${fat.formatNumber()} ${context.localization?.g}',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.purple500),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SizedBox(width: AppDimens.w4),
                        ),
                        TextSpan(
                          text:
                              '(${_fatPercentage.formatNumber()}%)',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                          ]).copyWith(color: AppColors.gray500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: visibleOpenFoodFacts || visibleMoreDetails,
            child: Padding(
              padding: EdgeInsets.all(AppDimens.r16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: visibleOpenFoodFacts,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => listener?.onTapOpenFoodFacts(),
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
                      onTap: () => listener?.onTapMoreDetails(),
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
        ],
      ),
    );
  }
}

class _DonutGraph extends StatelessWidget {
  const _DonutGraph({
    required this.chartData,
    required this.centerWidget,
    super.key,
  });

  final List<ChartDataModel>? chartData;
  final Widget centerWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.r120,
      height: AppDimens.r120,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<ChartDataModel, String>(
            dataSource: chartData,
            pointColorMapper: (ChartDataModel data, _) => data.color,
            xValueMapper: (ChartDataModel data, _) => data.x,
            yValueMapper: (ChartDataModel data, _) => data.y,
            innerRadius: '80%',
            radius: '100%',
            cornerStyle: CornerStyle.bothCurve,
          ),
        ],
        annotations: [
          CircularChartAnnotation(
            widget: centerWidget,
          ),
        ],
      ),
    );
  }
}
