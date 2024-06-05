import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../constant/app_constants.dart';
import '../models/micro_nutrient/micro_nutrient.dart';
import '../util/context_extension.dart';
import 'custom_linear_progress_indicator.dart';

class NutritionInformationWidget extends StatefulWidget {
  const NutritionInformationWidget({required this.nutrientList, super.key});

  final List<MicroNutrient>? nutrientList;

  @override
  State<NutritionInformationWidget> createState() =>
      _NutritionInformationWidgetState();
}

class _NutritionInformationWidgetState
    extends State<NutritionInformationWidget> {
  final initialVisibleItems = 10;

  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox.shrink(),
            ),
            16.horizontalSpace,
            Expanded(
              flex: 1,
              child: Text(
                context.localization?.consumed ?? '',
                style: AppTextStyle.textBase.addAll(
                    [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
                textAlign: TextAlign.right,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              flex: 1,
              child: Text(
                context.localization?.remaining ?? '',
                style: AppTextStyle.textBase.addAll(
                    [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: (!_showAll &&
                          (widget.nutrientList?.length ?? 0) >
                              initialVisibleItems)
                      ? initialVisibleItems
                      : widget.nutrientList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = widget.nutrientList?.elementAt(index);
                    return NutritionInformationRow(
                      name: data?.name,
                      total: data?.value.round() ?? 0,
                      remaining: max(
                          0,
                          (data?.recommendedValue.toInt() ?? 0) -
                              (data?.value.round() ?? 0)),
                      symbol: data?.unitSymbol,
                    );
                  },
                  separatorBuilder: (context, index) => 16.verticalSpace,
                ),
                24.verticalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAll = !_showAll;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    _showAll
                        ? context.localization?.showLess ?? ''
                        : context.localization?.showMore ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.indigo600Main),
                  ),
                ),
                SizedBox(height: context.bottomPadding + 40.h + 48.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NutritionInformationRow extends StatelessWidget {
  const NutritionInformationRow({
    this.name,
    this.total,
    this.remaining,
    this.symbol,
    super.key,
  });

  final String? name;
  final int? total;
  final int? remaining;
  final String? symbol;

  double get recommendedValue => (total ?? 0) + (remaining ?? 0).toDouble();

  double get percentage => ((total ?? 0) * 100) / recommendedValue;

  double get progressValue => min(1.0, (percentage / 100));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name ?? '',
                style: AppTextStyle.textSm.addAll(
                    [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              flex: 1,
              child: Text(
                '$total $symbol',
                style:
                    AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
                textAlign: TextAlign.right,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              flex: 1,
              child: Text(
                '${NumberFormat.decimalPatternDigits(
                  locale: 'en_us',
                  decimalDigits: 0,
                ).format(remaining)} $symbol',
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                  color: progressValue == 1.0
                      ? AppColors.red500
                      : AppColors.gray900,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        8.verticalSpace,
        CustomLinearProgressIndicator(
          value: total?.toDouble(),
          maxValue: recommendedValue,
          backgroundColor: AppColors.indigo50,
          color:
              progressValue == 1.0 ? AppColors.red500 : AppColors.indigo600Main,
          minHeight: 14.h,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ],
    );
  }
}
