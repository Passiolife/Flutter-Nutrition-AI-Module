import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';

class CalculatedBMIWidget extends StatelessWidget {
  const CalculatedBMIWidget({this.value, super.key});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.calculatedBMI ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 80.h,
            child: BMIGraph(value: value ?? 0),
          ),
        ],
      ),
    );
  }
}

class BMIGraph extends StatefulWidget {
  const BMIGraph({this.value = 0, super.key});

  final double value;

  @override
  State<BMIGraph> createState() => _BMIGraphState();
}

class _BMIGraphState extends State<BMIGraph> {
  double get actualPosition {
    final value = widget.value;
    return switch (value) {
      <= 18.5 => (value * 25) / 18.5,
      > 18.5 && <= 25 => (value * 50) / 25,
      > 25 && <= 30 => (value * 75) / 30,
      > 30 && <= 40 => (value * 100) / 40,
      _ => (40 * 100) / 40,
    };
  }

  double calculateBadgePosition() {
    return min(((actualPosition * (graphSize.width - badgeSize.width)) / 100),
        graphSize.width - badgeSize.width);
  }

  Color get badgeTextColor {
    return switch (actualPosition) {
      <= 25 => AppColors.indigo600Dark,
      > 25 && <= 50 => AppColors.green900Dark,
      > 50 && <= 75 => AppColors.yellow900Dark,
      _ => AppColors.red800,
    };
  }

  Color get badgeBackgroundColor {
    return switch (actualPosition) {
      <= 25 => AppColors.indigo100,
      > 25 && <= 50 => AppColors.green100,
      > 50 && <= 75 => AppColors.yellow100,
      _ => AppColors.red100,
    };
  }

  double get arrowPosition {
    return min(actualPosition * (graphSize.width - 14.r) / 100,
        (graphSize.width - 14.r));
  }

  Color get arrowColor {
    return switch (actualPosition) {
      <= 25 => AppColors.bmiGraphColor1,
      > 25 && <= 50 => AppColors.bmiGraphColor3,
      > 50 && <= 75 => AppColors.bmiGraphColor4,
      _ => AppColors.bmiGraphColor5,
    };
  }

  final _graphKey = GlobalKey();
  final _badgeKey = GlobalKey();

  Size graphSize = const Size(0, 0);
  Size badgeSize = const Size(0, 0);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final graphRenderBox =
          _graphKey.currentContext?.findRenderObject() as RenderBox;
      final badgeRenderBox =
          _badgeKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        graphSize = graphRenderBox.size;
        badgeSize = badgeRenderBox.size;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Badge
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: calculateBadgePosition(),
          top: 0,
          child: Container(
            key: _badgeKey,
            decoration: BoxDecoration(
              color: badgeBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 2.h,
            ),
            child: Text(
              '${widget.value}',
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.medium
              ]).copyWith(color: badgeTextColor),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: arrowPosition,
          top: (4.h + 20.h) + 4.h,
          child: SvgPicture.asset(
            AppImages.icBmi,
            width: 12.r,
            height: 12.r,
            colorFilter: ColorFilter.mode(arrowColor, BlendMode.srcIn),
          ),
        ),
        // Linear Gradient
        Positioned(
          // first bracket is for badge.
          // second bracket is for arrow.
          top: (4.h + 20.h) + (4.h + 12.r + 4.h),
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                key: _graphKey,
                width: double.infinity,
                height: 14.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                    stops: [0.0, 0.25, 0.28, 0.50, 0.53, 0.75, 0.78, 1.0],
                    colors: [
                      AppColors.bmiGraphColor1,
                      AppColors.bmiGraphColor1,
                      AppColors.bmiGraphColor3,
                      AppColors.bmiGraphColor3,
                      AppColors.bmiGraphColor4,
                      AppColors.bmiGraphColor4,
                      AppColors.bmiGraphColor5,
                      AppColors.bmiGraphColor5,
                    ],
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        context.localization?.underweight ?? '',
                        style: AppTextStyle.textXs.addAll([
                          AppTextStyle.textXs.leading4,
                          AppTextStyle.medium
                        ]).copyWith(color: AppColors.gray900),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.localization?.normal ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading4,
                          AppTextStyle.medium
                        ]).copyWith(color: AppColors.gray900),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.localization?.overweight ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading4,
                          AppTextStyle.medium
                        ]).copyWith(color: AppColors.gray900),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.localization?.obese ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading4,
                          AppTextStyle.medium
                        ]).copyWith(color: AppColors.gray900),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
