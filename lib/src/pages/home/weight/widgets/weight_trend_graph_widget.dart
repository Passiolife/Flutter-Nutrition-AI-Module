import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/graph_extension.dart';
import '../../../../common/widgets/dashed_line_painter.dart';

class WeightTrendGraph extends StatelessWidget {
  const WeightTrendGraph({
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
    // if(chartData==null && (chartData?.isEmpty ?? false)) return SizedBox.shrink();
    return SfCartesianChart(
      plotAreaBorderColor: AppColors.transparent,
      primaryXAxis: CategoryAxis(
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(color: AppColors.transparent),
        axisLine: const AxisLine(color: AppColors.gray200),
        desiredIntervals: (chartData?.length ?? 0) > 8 ? 4 : 6,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelPlacement: LabelPlacement.betweenTicks,
        labelAlignment: LabelAlignment.center,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
      ),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(width: 0),
        axisLine: const AxisLine(color: AppColors.transparent),
        minimum: 0,
        maximum: maximumValue?.normalizeToMultipleOf(40),
        desiredIntervals: 4,
        labelStyle: AppTextStyle.textXs.copyWith(color: AppColors.gray900),
      ),
      series: <CartesianSeries>[
        // Renders line chart
        LineSeries<ChartData, String>(
          markerSettings: MarkerSettings(
            isVisible: true,
            color: AppColors.indigo600Main,
            width: 8.r,
            height: 8.r,
          ),
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y > 0 ? data.y : null,
          pointColorMapper: (ChartData data, _) => AppColors.indigo600Main,
        )
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
