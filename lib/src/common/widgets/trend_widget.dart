import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';
import '../util/double_extensions.dart';

class TrendWidget extends StatelessWidget {
  const TrendWidget({
    this.title,
    this.isPreviousEnabled = true,
    this.isNextEnabled = true,
    this.centerWidget,
    this.consumedTitle,
    this.consumed = 0,
    this.remainingTitle,
    this.remaining = 0,
    this.unit,
    super.key,
  });

  final String? title;
  final bool isPreviousEnabled;
  final bool isNextEnabled;
  final Widget? centerWidget;
  final String? consumedTitle;
  final double consumed;
  final String? remainingTitle;
  final double remaining;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppShadows.base,
      padding: EdgeInsets.all(AppDimens.r16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: AppTextStyle.textLg
                .addAll([AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
          ),
          SizedBox(height: AppDimens.h24),
          SizedBox(
            height: AppDimens.h136,
            child: centerWidget,
          ),
          SizedBox(height: AppDimens.h24),
          Row(
            children: [
              Expanded(
                child: _WeightTrack(
                  title: consumedTitle ?? context.localization?.consumed,
                  value: consumed,
                  unit: unit,
                ),
              ),
              Expanded(
                child: _WeightTrack(
                  title: remainingTitle ?? context.localization?.remaining,
                  value: remaining,
                  unit: unit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightTrack extends StatelessWidget {
  const _WeightTrack({
    required this.title,
    required this.value,
    required this.unit,
  });

  final String? title;
  final double value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.textXs.addAll([
            AppTextStyle.textXs.leading4,
            AppTextStyle.semiBold
          ]).copyWith(color: AppColors.gray900),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: value.format(),
                style: AppTextStyle.text3xl.addAll([
                  AppTextStyle.text3xl.leading9,
                  AppTextStyle.extraBold
                ]).copyWith(color: AppColors.indigo600Main),
              ),
              WidgetSpan(
                child: SizedBox(width: AppDimens.w4),
              ),
              WidgetSpan(
                child: Text(
                  unit ?? '',
                  style:
                      AppTextStyle.textBase.copyWith(color: AppColors.gray500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
