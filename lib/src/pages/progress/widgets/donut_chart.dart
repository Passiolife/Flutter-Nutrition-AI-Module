import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.totalValue,
    required this.value,
    required this.centerValue,
    required this.progressColor,
    required this.title,
    required this.targetValue,
  });

  List<ChartDataModel> get chartData {
    return [
      ChartDataModel(y: value, color: progressColor),
      ChartDataModel(
          y: (value > totalValue) ? 0 : totalValue - value,
          color: AppColors.chartColorGGray),
    ];
  }

  final double value;
  final String centerValue;
  final int totalValue;
  final Color progressColor;
  final String title;
  final String targetValue;

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
              text: '$title\n',
              style: AppStyles.style18.copyWith(color: progressColor),
              children: [
                TextSpan(
                  text: '$centerValue\n',
                  style: AppStyles.style24.copyWith(height: 1.3),
                ),
                TextSpan(
                  text: '${context.localization?.target ?? ''} $targetValue',
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

class ChartDataModel {
  ChartDataModel({this.x = '', required this.y, required this.color});

  final String x;
  final double y;
  final Color color;
}
