import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/chart_model/chart_data_model.dart';
import '../../../common/util/context_extension.dart';

class CaloriesChart extends StatelessWidget {
  const CaloriesChart(
      {super.key, required this.totalCalories, required this.caloriesTarget});

  List<ChartDataModel> get chartData {
    return [
      ChartDataModel(y: totalCalories, color: AppColors.chartColorGOrange),
      ChartDataModel(
          y: (totalCalories > caloriesTarget)
              ? 0
              : caloriesTarget - totalCalories,
          color: AppColors.chartColorGGray),
    ];
  }

  final int caloriesTarget;
  final int totalCalories;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
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
          widget: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '${context.localization?.calories ?? ''}\n',
              style: AppStyles.style18.copyWith(color: Colors.amber),
              children: [
                TextSpan(
                  text: '$totalCalories\n',
                  style: AppStyles.style24.copyWith(height: 1.3),
                ),
                TextSpan(
                  text: '${context.localization?.target ?? ''} $caloriesTarget',
                  style: AppStyles.style10.copyWith(height: 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
