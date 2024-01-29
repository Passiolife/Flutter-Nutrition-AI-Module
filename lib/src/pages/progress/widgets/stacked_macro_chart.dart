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

class StackedMacroChart extends StatelessWidget {
  const StackedMacroChart({
    required this.timeLog,
    required this.isAbsoluteValue,
    super.key,
  });

  // [timeLog]
  final List<TimeLog> timeLog;

  //
  final bool isAbsoluteValue;

  DateTime get currentDateTime => DateTime.now();

  DateTime get lastMonthDateTime =>
      currentDateTime.copyWith(month: currentDateTime.month - 1);

  double get _totalCarbsValue => timeLog.isNotEmpty
      ? timeLog
          .map((e) => e.foodRecords.isNotEmpty ? e.totalCarbs : 0.0)
          .reduce((value, element) => math.max(value, element))
      : 0;

  double get _totalProteinValue => timeLog.isNotEmpty
      ? timeLog
          .map((e) => e.foodRecords.isNotEmpty ? e.totalProteins : 0.0)
          .reduce((value, element) => math.max(value, element))
      : 0;

  double get _totalFatValue => timeLog.isNotEmpty
      ? timeLog
          .map((e) => e.foodRecords.isNotEmpty ? e.totalFat : 0.0)
          .reduce((value, element) => math.max(value, element))
      : 0;

  double get _maxValue =>
      math.max(_totalCarbsValue + _totalProteinValue + _totalFatValue, 5);

  List<ChartData> get chartData {
    return List.generate(timeLog.length, (index) {
      final data = timeLog.elementAt(index);
      return ChartData(
        x: timeLog.length > 7
            ? data.dateTime.day.toString()
            : data.dateTime.format(format10),
        yCarbs:
            data.foodRecords.isNotEmpty ? data.totalCarbs.roundNumber(1) : 0,
        yProtein:
            data.foodRecords.isNotEmpty ? data.totalProteins.roundNumber(1) : 0,
        yFat: data.foodRecords.isNotEmpty ? data.totalFat.roundNumber(1) : 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SfCartesianChart(
        enableAxisAnimation: true,
        plotAreaBorderColor: AppColors.passioBlack50,
        plotAreaBorderWidth: 0,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.near,
          legendItemBuilder:
              (String name, dynamic series, dynamic point, int index) {
            if (series is StackedColumnSeries) {
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  (index == 0)
                      ? Dimens.w34.horizontalSpace
                      : Dimens.w8.horizontalSpace,
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
            return ChartAxisLabel('${value.text}${isAbsoluteValue ? 'g' : '%'}',
                AppStyles.style14);
          },
          multiLevelLabelFormatter: (value) {
            return ChartAxisLabel('g', AppStyles.style14);
          },
          borderWidth: 0,
          labelStyle: AppStyles.style14,
          majorGridLines: const MajorGridLines(color: AppColors.passioBlack50),
          minorGridLines: const MinorGridLines(color: AppColors.passioBlack50),
          majorTickLines: const MajorTickLines(width: 0),
          minimum: 0,
          maximum: _maxValue,
          decimalPlaces: 0,
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(
            width: 0,
          ),
          desiredIntervals: 6,
          labelStyle: AppStyles.style15,
          majorTickLines: const MajorTickLines(width: 0),
          plotBands: const <PlotBand>[
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
          StackedColumnSeries<ChartData, String>(
            width: chartData.length > 2 ? 0 : 0.1,
            name: context.localization?.carbs ?? '',
            color: AppColors.chartColorGBlue,
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.yCarbs,
          ),
          StackedColumnSeries<ChartData, String>(
            width: chartData.length > 2 ? 0 : 0.1,
            name: context.localization?.protein ?? '',
            dataSource: chartData,
            color: AppColors.chartColorGGreen,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.yProtein,
          ),
          StackedColumnSeries<ChartData, String>(
            width: chartData.length > 2 ? 0 : 0.1,
            name: context.localization?.fat ?? '',
            dataSource: chartData,
            color: AppColors.chartColorGRed,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.yFat,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData({
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
