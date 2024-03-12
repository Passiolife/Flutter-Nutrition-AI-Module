import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/constant/app_text_styles.dart';
import '../../../common/util/context_extension.dart';

class MeasurementRow extends StatelessWidget {
  const MeasurementRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _WaterWidget(),
        SizedBox(width: AppDimens.w16),
        const _WeightWidget(),
      ],
    );
  }
}

class _WaterWidget extends StatelessWidget {
  const _WaterWidget();

  @override
  Widget build(BuildContext context) {
    return _MeasurementWidget(
      key: key,
      imagePath: AppImages.icWater,
      localizedText: context.localization?.water ?? '',
      value: '45',
      unit: context.localization?.oz ?? '',
      remainingText:
          '20 ${context.localization?.oz ?? ''} ${context.localization?.remainToDailyGoal ?? ''}',
      textColor: AppColors.blue500,
    );
  }
}

class _WeightWidget extends StatelessWidget {
  const _WeightWidget();

  @override
  Widget build(BuildContext context) {
    return _MeasurementWidget(
      key: key,
      imagePath: AppImages.icWeight,
      localizedText: context.localization?.weight ?? '',
      value: '160',
      unit: context.localization?.lbs ?? '',
      remainingText:
          '12 ${context.localization?.lbs ?? ''} ${context.localization?.remainToLoss ?? ''}',
      textColor: AppColors.yellow500,
    );
  }
}

class _MeasurementWidget extends StatelessWidget {
  const _MeasurementWidget({
    required this.imagePath,
    required this.localizedText,
    required this.value,
    required this.unit,
    required this.remainingText,
    required this.textColor,
    super.key,
  });

  final String imagePath;
  final String localizedText;
  final String value;
  final String unit;
  final String remainingText;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: AppDimens.h140,
        decoration: AppShadows.base,
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
                    AppImages.icPencil,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
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
              child: Text(
                remainingText,
                textAlign: TextAlign.center,
                style: AppTextStyle.textXs.addAll([
                  AppTextStyle.textXs.leading4,
                  AppTextStyle.semiBold
                ]).copyWith(color: AppColors.gray900),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
