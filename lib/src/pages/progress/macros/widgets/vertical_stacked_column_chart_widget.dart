import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/graph_extension.dart';

class VerticalStackedColumnChartWidget extends StatelessWidget {
  const VerticalStackedColumnChartWidget({
    this.title,
    this.chartData,
    this.maximumValue,
    this.barWidth = 0.7,
    this.maximumLabels = 5,
    this.desiredIntervals = 4,
    super.key,
  });

  // Chart Title
  final String? title;

  final double barWidth;

  final List<StackedChartData>? chartData;
  final double? maximumValue;
  final int maximumLabels;
  final int desiredIntervals;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderColor: AppColors.transparent,
      margin: EdgeInsets.all(16.r),
      title: title != null
          ? ChartTitle(
              text: '$title\n',
              textStyle: AppTextStyle.textLg.addAll(
                  [AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
              alignment: ChartAlignment.near,
            )
          : const ChartTitle(),
      primaryXAxis: CategoryAxis(
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(color: AppColors.transparent),
        axisLine: const AxisLine(color: AppColors.gray200),
        labelPlacement: LabelPlacement.betweenTicks,
        labelAlignment: LabelAlignment.center,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
        desiredIntervals: (chartData?.length ?? 0) > 8 ? 4 : 6,
      ),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(width: 0),
        axisLine: const AxisLine(color: AppColors.transparent),
        minimum: 0,
        maximum: maximumValue?.normalizeToMultipleOf(50),
        maximumLabels: maximumLabels,
        desiredIntervals: desiredIntervals,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
      ),
      series: <CartesianSeries>[
        StackedColumnSeries<StackedChartData, String>(
          dataSource: chartData,
          color: AppColors.green500Normal,
          width: barWidth,
          xValueMapper: (StackedChartData data, _) => data.x,
          yValueMapper: (StackedChartData data, _) => data.yProtein,
          animationDuration: 400,
        ),
        StackedColumnSeries<StackedChartData, String>(
          dataSource: chartData,
          color: AppColors.purple500,
          width: barWidth,
          xValueMapper: (StackedChartData data, _) => data.x,
          yValueMapper: (StackedChartData data, _) => data.yFat,
          animationDuration: 400,
        ),
        StackedColumnSeries<StackedChartData, String>(
          dataSource: chartData,
          color: AppColors.lBlue500Normal,
          width: barWidth,
          xValueMapper: (StackedChartData data, _) => data.x,
          yValueMapper: (StackedChartData data, _) => data.yCarbs,
          animationDuration: 400,
        ),
      ],
    );
  }
}

class StackedChartData {
  const StackedChartData({
    required this.x,
    required this.yCarbs,
    required this.yProtein,
    required this.yFat,
  });

  final String x;
  final double yCarbs;
  final double yProtein;
  final double yFat;
}
