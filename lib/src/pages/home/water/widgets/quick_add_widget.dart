import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/double_extensions.dart';
import 'interfaces.dart';

class QuickAddWidget extends StatelessWidget {
  const QuickAddWidget({required this.listener, this.unit, super.key});

  final WaterListener? listener;
  final MeasurementSystem? unit;

  double get glassValue =>
      236.588 *
      (unit == MeasurementSystem.imperial ? Conversion.mlToOz.value : 1);

  double get smallBottleValue =>
      473.176 *
      (unit == MeasurementSystem.imperial ? Conversion.mlToOz.value : 1);

  double get largeBottleValue =>
      709.765 *
      (unit == MeasurementSystem.imperial ? Conversion.mlToOz.value : 1);

  String _getUnitSymbol(BuildContext context) {
    return (unit == MeasurementSystem.imperial
            ? context.localization?.oz
            : context.localization?.ml) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.r16),
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.quickAdd ?? '',
            style: AppTextStyle.textLg
                .addAll([AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _QuickAddItem(
                  icon: AppImages.icWaterGlass,
                  type: context.localization?.glass ?? '',
                  value: glassValue,
                  unit: _getUnitSymbol(context),
                  onTap: () => listener?.onTapQuickAdd(glassValue),
                ),
              ),
              Expanded(
                child: _QuickAddItem(
                  icon: AppImages.icWaterSmallBottle,
                  type: context.localization?.smBottle ?? '',
                  value: smallBottleValue,
                  unit: _getUnitSymbol(context),
                  onTap: () => listener?.onTapQuickAdd(smallBottleValue),
                ),
              ),
              Expanded(
                child: _QuickAddItem(
                  icon: AppImages.icWaterLargeBottle,
                  type: context.localization?.lgBottle ?? '',
                  value: largeBottleValue,
                  unit: _getUnitSymbol(context),
                  onTap: () => listener?.onTapQuickAdd(largeBottleValue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAddItem extends StatelessWidget {
  const _QuickAddItem({
    required this.icon,
    required this.type,
    required this.value,
    required this.unit,
    this.onTap,
  });

  final String icon;
  final String type;
  final double value;
  final String unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.blue50,
        highlightColor: AppColors.blue50,
        onTap: onTap,
        child: SizedBox(
          height: 87.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(icon),
                ),
              ),
              8.verticalSpace,
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: RichText(
                    text: TextSpan(
                      text: type,
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.semiBold
                      ]),
                      children: [
                        TextSpan(
                          text: ' (${value.format()} $unit)',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
