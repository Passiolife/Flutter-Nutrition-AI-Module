import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/constant/app_text_styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import 'interfaces.dart';

class MeasurementRow extends StatelessWidget {
  const MeasurementRow({
    this.consumedWater = 0,
    this.remainingWater = 0,
    this.waterUnit,
    this.measuredWeight = 0,
    this.remainingWeight = 0,
    this.weightUnit,
    this.listener,
    super.key,
  });

  final double consumedWater;
  final double remainingWater;
  final String? waterUnit;

  final double measuredWeight;
  final double remainingWeight;
  final String? weightUnit;

  final HomeListener? listener;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WaterWidget(
          consumedValue: consumedWater,
          remainingValue: remainingWater,
          unit: waterUnit,
          onTap: listener?.onTapWater,
        ),
        SizedBox(width: AppDimens.w16),
        _WeightWidget(
          trackedWeight: measuredWeight,
          remainingWeight: remainingWeight,
          unit: weightUnit,
          onTap: listener?.onTapWeight,
        ),
      ],
    );
  }
}

class _WaterWidget extends StatelessWidget {
  const _WaterWidget({
    required this.consumedValue,
    required this.remainingValue,
    this.unit,
    this.onTap,
  });

  final double consumedValue;
  final double remainingValue;
  final String? unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MeasurementWidget(
      key: key,
      imagePath: AppImages.icWater,
      localizedText: context.localization?.water ?? '',
      value: consumedValue.format(),
      unit: unit ?? '',
      remainingValue: remainingValue.format(),
      remainingText: context.localization?.remainToDailyGoal ?? '',
      textColor: AppColors.blue500,
      onTap: onTap,
    );
  }
}

class _WeightWidget extends StatelessWidget {
  const _WeightWidget({
    required this.trackedWeight,
    required this.remainingWeight,
    this.unit,
    this.onTap,
  });

  final double trackedWeight;
  final double remainingWeight;
  final String? unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MeasurementWidget(
      key: key,
      imagePath: AppImages.icWeight,
      localizedText: context.localization?.weight ?? '',
      value: trackedWeight.format(),
      unit: unit ?? '',
      remainingValue: remainingWeight.format(),
      remainingText: context.localization?.remainToDailyGoal ?? '',
      textColor: AppColors.yellow500,
      onTap: onTap,
    );
  }
}

class _MeasurementWidget extends StatelessWidget {
  const _MeasurementWidget({
    required this.imagePath,
    required this.localizedText,
    required this.value,
    required this.unit,
    required this.remainingValue,
    required this.remainingText,
    required this.textColor,
    this.onTap,
    super.key,
  });

  final String imagePath;
  final String localizedText;
  final String value;
  final String unit;
  final String remainingValue;
  final String remainingText;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: AppDimens.h140,
        decoration: AppShadows.base,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppColors.blue50,
            highlightColor: AppColors.blue50,
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppDimens.r16,
                left: AppDimens.r16,
                right: AppDimens.r16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppDimens.h24,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          imagePath,
                          width: AppDimens.r24,
                          height: AppDimens.r24,
                        ),
                        SizedBox(width: AppDimens.w5),
                        Expanded(
                          child: Text(
                            localizedText,
                            style: AppTextStyle.textLg.addAll([
                              AppTextStyle.textLg.leading6,
                              AppTextStyle.semiBold
                            ]).copyWith(color: AppColors.gray900),
                          ),
                        ),
                        SvgPicture.asset(
                          AppImages.icPlusSolid,
                          width: AppDimens.r24,
                          height: AppDimens.r24,
                          colorFilter: const ColorFilter.mode(
                              AppColors.gray400, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.h16),
                  SizedBox(
                    width: double.infinity,
                    height: AppDimens.h36,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: value,
                          style: AppTextStyle.text3xl.addAll([
                            AppTextStyle.text3xl.leading9,
                            AppTextStyle.semiBold
                          ]).copyWith(
                            color: AppColors.indigo600Main,
                          ),
                          children: [
                            TextSpan(
                              text: '\t$unit',
                              style: AppTextStyle.textBase
                                  .copyWith(color: AppColors.gray500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // SizedBox(height: AppDimens.h16),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: remainingValue,
                        style: AppTextStyle.textXs.addAll([
                          AppTextStyle.textXs.leading4,
                          AppTextStyle.semiBold
                        ]).copyWith(color: AppColors.gray900),
                        children: [
                          TextSpan(
                            text: ' $unit',
                            style: AppTextStyle.textXs.addAll([
                              AppTextStyle.textXs.leading4,
                              AppTextStyle.semiBold
                            ]).copyWith(color: AppColors.gray900),
                          ),
                          TextSpan(
                            text: ' $remainingText',
                            style: AppTextStyle.textXs
                                .copyWith(color: AppColors.gray900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
