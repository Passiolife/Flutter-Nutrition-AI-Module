import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/graph_extension.dart';
import '../../../../common/widgets/dashed_line_painter.dart';

class WaterTrendGraph extends StatelessWidget {
  const WaterTrendGraph({
    this.chartData,
    this.maximumValue,
    this.targetValue,
    super.key,
  });

  final List<ChartData>? chartData;
  final double? maximumValue;
  final double? targetValue;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderColor: AppColors.transparent,
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
        maximum: maximumValue?.normalizeToMultipleOf(40),
        maximumLabels: 5,
        desiredIntervals: 4,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
      ),
      series: <CartesianSeries>[
        // Renders line chart
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          width: (chartData?.length ?? 0) > 8 ? 0.7 : 0.4,
          color: AppColors.indigo600Main,
        ),
      ],
      annotations: chartData?.firstOrNull?.x != null
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
          : [],
    );
  }
}

class ChartData {
  const ChartData(this.x, this.y);

  final String x;
  final double y;
}
