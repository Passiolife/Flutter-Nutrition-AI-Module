import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/chart_model/chart_data_model.dart';
import '../../../common/util/context_extension.dart';

class MacrosChart extends StatelessWidget {
  const MacrosChart({
    required this.data,
    super.key,
  });

  final ({int totalCarbs, int totalProtiens, int totalFats, String carbsValue, String proteinsValue, String fatsValue}) data;

  List<ChartDataModel> get chartData {
    return [
      ChartDataModel(
        y: data.totalCarbs,
        color: AppColors.chartColorGBlue,
      ),
      ChartDataModel(
        y: data.totalProtiens,
        color: AppColors.chartColorGGreen,
      ),
      ChartDataModel(
        y: data.totalFats,
        color: AppColors.chartColorGRed,
      ),
      ChartDataModel(
        y: (data.totalCarbs > 0 || data.totalProtiens > 0 || data.totalFats > 0) ? 0 : 1,
        color: AppColors.chartColorGGray,
      ),
    ];
  }


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
              children: [
                /// Carbs
                TextSpan(
                  text: '${context.localization?.carbs ?? ''}: ',
                  style: AppStyles.style14.copyWith(
                    height: 1.5,
                    color: AppColors.chartColorGBlue,
                  ),
                ),
                TextSpan(
                  text: '${data.carbsValue}\n',
                  style: AppStyles.style14.copyWith(height: 1.5),
                ),

                TextSpan(
                  text: '${context.localization?.protein ?? ''}: ',
                  style: AppStyles.style14.copyWith(
                    height: 1.5,
                    color: AppColors.chartColorGGreen,
                  ),
                ),
                TextSpan(
                  text: '${data.proteinsValue}\n',
                  style: AppStyles.style14.copyWith(height: 1.5),
                ),
                TextSpan(
                  text: '${context.localization?.fat ?? ''}: ',
                  style: AppStyles.style14.copyWith(
                    height: 1.5,
                    color: AppColors.chartColorGRed,
                  ),
                ),
                TextSpan(
                  text: data.fatsValue,
                  style: AppStyles.style14.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
