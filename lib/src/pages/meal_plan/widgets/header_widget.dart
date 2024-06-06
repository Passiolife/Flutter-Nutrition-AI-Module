import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_pop_up_widget.dart';

abstract interface class HeaderListener {
  void onMealPlanChanged(PassioMealPlan mealPlan);

  void onDayChanged(int day);
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    this.mealPlans = const [],
    this.selectedDay,
    this.selectedMealPlan,
    this.listener,
    super.key,
  });

  final List<PassioMealPlan> mealPlans;
  final int? selectedDay;
  final PassioMealPlan? selectedMealPlan;
  final HeaderListener? listener;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        children: [
          8.verticalSpace,
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SvgPicture.asset(
                  AppImages.icBalancedDiet,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  selectedMealPlan?.mealPlanTitle.toUpperCaseWord ?? '',
                  style: AppTextStyle.textLg.addAll(
                      [AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
                ),
              ),
              AppPopupWidget<PassioMealPlan>(
                items: mealPlans,
                itemBuilder: (item) {
                  return Text(
                    item.mealPlanTitle,
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: AppColors.gray900),
                  );
                },
                constraints: BoxConstraints(minWidth: 224.w),
                icon: SvgPicture.asset(
                  AppImages.icDotsVertical,
                  width: 24.r,
                  height: 24.r,
                ),
                initialValue: selectedMealPlan,
                onSelected: (value) {
                  listener?.onMealPlanChanged(value);
                },
              ),
            ],
          ),
          16.verticalSpace,
          _DayListWidget(
            selectedDay: selectedDay,
            onPressed: listener?.onDayChanged,
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}

class _DayListWidget extends StatelessWidget {
  const _DayListWidget({
    this.selectedDay,
    this.onPressed,
  });

  final int? selectedDay;
  final Function(int day)? onPressed;

  List<int> _getDays(BuildContext context) =>
      List.generate(14, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34.h,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 16.w, right: 4.w),
        itemCount: _getDays(context).length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = _getDays(context).elementAt(index);
          return RawChip(
            color: WidgetStateProperty.all(data == selectedDay
                ? AppColors.indigo600Main
                : AppColors.gray100),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30.r),
            ),
            label: Text(
              '${context.localization?.day ?? ''} ${index + 1}',
              style: AppTextStyle.textXs
                  .addAll([AppTextStyle.semiBold]).copyWith(
                      color: data == selectedDay
                          ? AppColors.white
                          : AppColors.gray900),
            ),
            onPressed: data != selectedDay ? () => onPressed?.call(data) : null,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return 8.horizontalSpace;
        },
      ),
    );
  }
}
