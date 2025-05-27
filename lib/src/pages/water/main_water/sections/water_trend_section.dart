import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../bloc/water_bloc.dart';
import '../models/water_chart_data.dart';
import '../widgets/water_trend_widget.dart';

class WaterTrendSection extends StatelessWidget {
  const WaterTrendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      buildWhen: (_, state) {
        return state is InitialState || state is UpdateWaterTrendState;
      },
      builder: (context, state) {
        List<WaterChartData> chartData = [];
        double maximumValue = 0;
        double targetValue = 0;

        if (state is UpdateWaterTrendState) {
          chartData = state.chartData;
          maximumValue = state.maximumValue;
          targetValue = state.targetValue;
        }

        return Container(
          width: double.infinity,
          decoration: AppShadows.base,
          margin: AppPadding.ph16,
          padding: AppPadding.pa16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization.waterTrend,
                style: AppTextStyle.textLg
                    .addAll(
                    [AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
              ),
              24.verticalSpace,
              SizedBox(
                height: AppDimens.h136,
                child: WaterTrendWidget(
                  chartData: chartData,
                  maximumValue: maximumValue,
                  targetValue: targetValue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
