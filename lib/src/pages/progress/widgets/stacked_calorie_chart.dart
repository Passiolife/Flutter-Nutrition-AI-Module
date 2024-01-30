import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/time_log/time_log.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/double_extensions.dart';

class StackedCalorieChart extends StatelessWidget {
  const StackedCalorieChart({
    required this.timeLog,
    required this.isAbsoluteValue,
    super.key,
  });

  final List<TimeLog> timeLog;

  final bool isAbsoluteValue;

  DateTime get currentDateTime => DateTime.now();

  DateTime get lastMonthDateTime => currentDateTime.copyWith(month: currentDateTime.month - 1);

  double get maxValue => math.max(
      timeLog.isNotEmpty
          ? timeLog.map((e) => e.foodRecords.isNotEmpty ? e.totalCalories : 0.0).reduce((value, element) => math.max(value, element))
          : 0,
      5);

  List<ChartDataModel> get chartData {
    return List.generate(timeLog.length, (index) {
      final data = timeLog.elementAt(index);
      return ChartDataModel(
        timeLog.length > 7 ? data.dateTime.day.toString() : data.dateTime.format(format10),
        data.foodRecords.isNotEmpty ? data.totalCalories.roundNumber(1) : 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SfCartesianChart(
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.near,
          legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
            if (series is StackedColumnSeries) {
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Dimens.w34.horizontalSpace,
                  Container(
                    color: series.color,
                    width: Dimens.r10,
                    height: Dimens.r10,
                  ),
                  Dimens.w4.horizontalSpace,
                  Text(
                    series.name ?? '',
                    style: AppStyles.style15,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (value) {
            return ChartAxisLabel('${value.text}${isAbsoluteValue ? 'g' : '%'}', AppStyles.style14);
          },
          borderWidth: 0,
          labelStyle: AppStyles.style14,
          majorGridLines: const MajorGridLines(color: AppColors.passioBlack50),
          minorGridLines: const MinorGridLines(color: AppColors.passioBlack50),
          majorTickLines: const MajorTickLines(width: 0),
          minimum: 0,
          maximum: maxValue,
          decimalPlaces: 0,
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(color: AppColors.passioBlack50, width: 0),
          desiredIntervals: 6,
          labelStyle: AppStyles.style15,
          majorTickLines: const MajorTickLines(width: 1),
          plotBands: <PlotBand>[
            PlotBand(
              verticalTextPadding: '5%',
              horizontalTextPadding: '5%',
              textAngle: 0,
              start: 100,
              end: 100,
              borderColor: AppColors.passioBlack50,
              borderWidth: 1,
            ),
          ],
        ),
        series: [
          StackedColumnSeries<ChartDataModel, String>(
            width: chartData.length > 2 ? null : 0.1,
            name: context.localization?.calories ?? '',
            dataSource: chartData,
            xValueMapper: (ChartDataModel data, _) => data.x,
            yValueMapper: (ChartDataModel data, _) => data.y,
            color: AppColors.chartColorGOrange,
          ),
        ],
      ),
    );
  }
}

class ChartDataModel {
  ChartDataModel(
    this.x,
    this.y,
  );

  final String x;
  final double y;
}
