import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constant/app_constants.dart';
import '../models/chart_model/chart_data_model.dart';
import '../util/context_extension.dart';
import '../util/double_extensions.dart';

class NutritionalGraphWidget extends StatelessWidget {
  const NutritionalGraphWidget({
    required this.calories,
    required this.carbs,
    required this.carbsPercentage,
    required this.proteins,
    required this.proteinsPercentage,
    required this.fat,
    required this.fatPercentage,
    this.chartData,
    super.key,
  });

  final double calories;
  final double carbs;
  final double carbsPercentage;
  final double proteins;
  final double proteinsPercentage;
  final double fat;
  final double fatPercentage;

  final List<ChartDataModel>? chartData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DonutGraph(
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
                text: '${carbs.format()} ${context.localization?.g}',
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
                    text: '(${carbsPercentage.format()}%)',
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
                text: '${proteins.format()} ${context.localization?.g}',
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
                    text: '(${proteinsPercentage.format()}%)',
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
                text: '${fat.format()} ${context.localization?.g}',
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
                    text: '(${fatPercentage.format()}%)',
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
    );
  }
}

class _DonutGraph extends StatelessWidget {
  const _DonutGraph({
    required this.chartData,
    required this.centerWidget,
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
          CircularChartAnnotation(widget: centerWidget),
        ],
      ),
    );
  }
}
