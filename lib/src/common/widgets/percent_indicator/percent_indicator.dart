import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../constant/app_constants.dart';
import '../../constant/app_padding.dart';
import '../../extension/context_extension.dart';

class PercentIndicator extends StatelessWidget {
  final bool isLinearIndicator;

  final double percentValue;
  final double size;
  final double? lineWidth;
  final double? lineHeight;
  final double? width;

  final EdgeInsetsGeometry? gapBetweenTitleAndSubtitle;
  final EdgeInsetsGeometry? gapFooter;

  final String title;
  final String? subtitle;
  final String? footer;

  final Color progressColor;
  final Color? progressBorderColor;
  final double? progressBorderSize;
  final Color? backgroundColor;

  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? footerTextStyle;

  final Widget? leading;
  final Widget? trailing;

  final CircularStrokeCap? circularStrokeCap;
  final Radius? barRadius;

  const PercentIndicator.circular({
    super.key,
    required this.size,
    required this.percentValue,
    required this.title,
    required this.progressColor,
    this.progressBorderColor,
    this.progressBorderSize,
    this.backgroundColor,
    this.subtitle,
    this.footer,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.footerTextStyle,
    this.lineWidth,
    this.circularStrokeCap,
    this.gapBetweenTitleAndSubtitle,
    this.gapFooter,
  })  : isLinearIndicator = false,
        barRadius = null,
        lineHeight = 0.0,
        width = 0.0,
        leading = null,
        trailing = null;

  const PercentIndicator.linear({
    super.key,
    this.width,
    required this.percentValue,
    required this.progressColor,
    this.title = '',
    this.backgroundColor = AppColors.brandPrimaryLight,
    this.progressBorderColor,
    this.progressBorderSize,
    this.subtitle,
    this.footer,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.footerTextStyle,
    this.lineWidth,
    this.gapBetweenTitleAndSubtitle,
    this.gapFooter,
    this.barRadius,
    this.lineHeight,
    this.leading,
    this.trailing,
  })  : isLinearIndicator = true,
        circularStrokeCap = null,
        size = 0.0;

  double _calculateLineWidth() {
    return (size / 5).w;
  }

  double _calculateLineHeight() {
    if (width != null) {
      return (width! / 30).h;
    }

    return 5.0;
  }

  @override
  Widget build(BuildContext context) {
    /// NOTE : This [LinearPercentIndicator] could be changed since this widget is not registered in the Figma design system
    if (isLinearIndicator) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: barRadius != null ? BorderRadius.all(barRadius!) : null,
          color: progressColor
        ),
        padding: progressBorderSize!=null ? EdgeInsets.all(
            progressBorderSize!) : null,
        child: LinearPercentIndicator(
          width: width,
          lineHeight: lineHeight ?? _calculateLineHeight(),
          percent: percentValue,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
          barRadius: barRadius,
          center: title.isNotEmpty
              ? Text(
                  title,
                  style: titleTextStyle ??
                      AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.bold
                      ]).copyWith(color: context.textThemeColors.brandTextDark),
                )
              : null,
          trailing: trailing,
          leading: leading,
          padding: EdgeInsets.zero,
        ),
      );
    }

    return CircularPercentIndicator(
      radius: size,
      lineWidth: lineWidth ?? _calculateLineWidth(),
      animation: true,
      percent: percentValue,
      progressBorderColor: progressBorderColor,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: titleTextStyle ??
                AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.bold
                ]).copyWith(color: context.textThemeColors.brandTextDark),
          ),
          ColoredBox(
            color: AppColors.brandBorders,
            child: SizedBox(
              width: 40.w,
              height: 1.h,
            ),
          ),
          // text-sm/leading-5/font-normal

          if (subtitle != null)
            Text(
              subtitle!,
              style: subtitleTextStyle ??
                  AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]).copyWith(
                    color: context.textThemeColors.brandTextDark,
                  ),
            ),
        ],
      ),
      footer: footer != null
          ? Padding(
              padding: gapFooter ?? AppPadding.pt8,
              child: Text(
                footer!,
                style: footerTextStyle ??
                    AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.medium
                    ]).copyWith(color: context.textThemeColors.brandTextDark),
              ),
            )
          : null,
      circularStrokeCap: circularStrokeCap ?? CircularStrokeCap.round,
      progressColor: progressColor,
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
    );
  }
}
