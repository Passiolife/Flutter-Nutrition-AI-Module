import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/graph_extension.dart';
import '../../../../common/widgets/dashed_line_painter.dart';

class VerticalBarChartWidget extends StatelessWidget {
  const VerticalBarChartWidget({
    this.title,
    this.barColor,
    this.barWidth = 0.7,
    this.chartData,
    this.maximumValue,
    this.targetValue,
    this.maximumLabels = 5,
    this.desiredIntervals = 4,
    super.key,
  });

  // Chart Title
  final String? title;

  // Chart
  final Color? barColor;
  final double barWidth;

  final List<ChartData>? chartData;
  final double? maximumValue;
  final double? targetValue;
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
              alignment: ChartAlignment.near)
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
        maximum: maximumValue?.normalizeToMultipleOf(100),
        maximumLabels: maximumLabels,
        desiredIntervals: desiredIntervals,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
      ),
      series: <CartesianSeries>[
        // Renders line chart
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          width: barWidth,
          color: barColor,
          animationDuration: 400,
        ),
      ],
      annotations: targetValue != null
          ? [
              CartesianChartAnnotation(
                widget: CustomPaint(
                  painter: const DashedLinePainter(
                      borderColor: AppColors.green500Normal),
                  child: SizedBox(
                    width: double.infinity,
                    height: 2.h,
                  ),
                ),
                coordinateUnit: CoordinateUnit.point,
                x: chartData?.firstOrNull?.x ?? '',
                y: targetValue,
                horizontalAlignment: ChartAlignment.near,
                region: AnnotationRegion.plotArea,
              ),
            ]
          : null,
    );
  }
}

class ChartData {
  const ChartData(this.x, this.y);

  final String x;
  final double y;
}
