import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constant/app_constants.dart';
import '../models/chart_model/chart_data_model.dart';
import '../util/context_extension.dart';
import '../util/double_extensions.dart';

class MacrosGraphWidget extends StatelessWidget {
  const MacrosGraphWidget({
    required this.consumedCalories,
    required this.totalCalories,
    required this.consumedCarbs,
    required this.totalCarbs,
    required this.consumedProteins,
    required this.totalProteins,
    required this.consumedFat,
    required this.totalFat,
    super.key,
  });

  // Calories
  final int consumedCalories;
  final double totalCalories;

  // Carbs
  final int consumedCarbs;
  final double totalCarbs;

  // Proteins
  final int consumedProteins;
  final double totalProteins;

  // Fat
  final int consumedFat;
  final double totalFat;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DonutGraph(
            label: context.localization?.calories,
            consumedNutrient: '$consumedCalories',
            totalNutrient: totalCalories.format(),
            graphColor: AppColors.yellow500,
            overFilledGraphColor: AppColors.yellow900Dark,
          ),
        ),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: _DonutGraph(
            label: context.localization?.carbs,
            consumedNutrient: '$consumedCarbs g',
            totalNutrient: '${totalCarbs.format()} g',
            graphColor: AppColors.lBlue500Normal,
            overFilledGraphColor: AppColors.lBlue900Dark,
          ),
        ),
        SizedBox(width: AppDimens.w16),
        Expanded(
          child: _DonutGraph(
            label: context.localization?.protein,
            consumedNutrient: '$consumedProteins g',
            totalNutrient: '${totalProteins.format()} g',
            graphColor: AppColors.green500Normal,
            overFilledGraphColor: AppColors.green900Dark,
          ),
        ),
        SizedBox(width: AppDimens.w16),
        Expanded(
          child: _DonutGraph(
            label: context.localization?.fat,
            consumedNutrient: '$consumedFat g',
            totalNutrient: '${totalFat.format()} g',
            graphColor: AppColors.purple500,
            overFilledGraphColor: AppColors.purple900,
          ),
        ),
      ],
    );
  }
}

class _DonutGraph extends StatelessWidget {
  const _DonutGraph({
    required this.totalNutrient,
    required this.consumedNutrient,
    required this.graphColor,
    required this.overFilledGraphColor,
    this.label,
  });

  final String? label;
  final String? totalNutrient;
  final String? consumedNutrient;
  final Color graphColor;
  final Color overFilledGraphColor;

  double get _consumedNutrient => _extractNumberFromString(consumedNutrient);

  double get _totalNutrient => _extractNumberFromString(totalNutrient);

  double get _remainsNutrient => (_consumedNutrient > _totalNutrient)
      ? 0
      : _totalNutrient - _consumedNutrient;

  double get _overNutrient => (_consumedNutrient > _totalNutrient)
      ? _totalNutrient - _consumedNutrient
      : 0;

  List<ChartDataModel> get chartData {
    return [
      ChartDataModel(y: _overNutrient, color: overFilledGraphColor),
      ChartDataModel(y: _consumedNutrient, color: graphColor),
      ChartDataModel(
        y: _totalNutrient == 0 ? 100 : _remainsNutrient,
        color: AppColors.gray200,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppDimens.h80,
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
              ),
            ],
            annotations: [
              CircularChartAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      consumedNutrient ?? '',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.gray900),
                    ),
                    SizedBox(height: AppDimens.h1),
                    SizedBox(
                      width: AppDimens.w39,
                      child: const Divider(
                        color: AppColors.gray400,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: AppDimens.h1),
                    Text(
                      totalNutrient ?? '',
                      style: AppTextStyle.textSm
                          .copyWith(color: AppColors.gray900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimens.h8),
        Text(
          label ?? '',
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading4,
            AppTextStyle.medium
          ]).copyWith(color: AppColors.gray900),
        ),
      ],
    );
  }

  double _extractNumberFromString(String? input) {
    if (input == null) {
      return 0;
    }
    // Define a regular expression to match digits and an optional decimal part
    RegExp regex = RegExp(r'\d+(\.\d+)?');

    // Find the first match in the input string
    RegExpMatch? match = regex.firstMatch(input);

    // Extract and convert the matched substring to a double
    double number = match != null ? double.parse(match.group(0)!) : 0.0;

    return number;
  }
}
