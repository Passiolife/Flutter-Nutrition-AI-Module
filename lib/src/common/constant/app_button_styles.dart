import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_constants.dart';

class AppButtonStyles {
  static AppButtonModel primary = AppButtonModel(
    textStyle: AppTextStyle.textBase
        .addAll([AppTextStyle.textBase.leading6, AppTextStyle.medium]).copyWith(
            color: AppColors.white),
    decoration: BoxDecoration(
      color: AppColors.indigo600Main,
      borderRadius: BorderRadius.circular(4.r),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 13.h,
      horizontal: 16.w,
    ),
  );

  static AppButtonModel primaryBordered = AppButtonModel(
    textStyle: AppTextStyle.textBase
        .addAll([AppTextStyle.textBase.leading6, AppTextStyle.medium]).copyWith(
            color: AppColors.indigo600Main),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.indigo600Main),
      borderRadius: BorderRadius.circular(4.r),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 13.h,
      horizontal: 16.w,
    ),
  );

  static AppButtonModel primaryCustom = AppButtonModel(
    textStyle: AppTextStyle.textSm
        .addAll([AppTextStyle.textSm.leading5, AppTextStyle.bold]).copyWith(
            color: AppColors.white),
    decoration: BoxDecoration(
      color: AppColors.indigo600Main,
      borderRadius: BorderRadius.circular(8.r),
    ),
    padding: EdgeInsets.symmetric(vertical: 8.h),
  );

  static AppButtonModel primaryCustomBordered = AppButtonModel(
    textStyle: AppTextStyle.textSm
        .addAll([AppTextStyle.textSm.leading5, AppTextStyle.bold]).copyWith(
            color: AppColors.indigo600Main),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.indigo600Main),
      borderRadius: BorderRadius.circular(8.r),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 8.h,
      horizontal: 16.w,
    ),
  );

  static AppButtonModel simpleSecondary = AppButtonModel(
    textStyle: AppTextStyle.textBase
        .addAll([AppTextStyle.textBase.leading6, AppTextStyle.medium]).copyWith(
            color: AppColors.indigo700),
    decoration: BoxDecoration(
      color: AppColors.indigo100,
      borderRadius: BorderRadius.circular(4.r),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 13.h,
      horizontal: 16.w,
    ),
  );
}

class AppButtonModel {
  AppButtonModel({this.textStyle, this.padding, this.decoration});

  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
}

extension AppButtonModelExtension on AppButtonModel {
  AppButtonModel addAll(List<BoxShadow> shadows, {int? atIndex}) {
    decoration?.addAll(shadows, atIndex: atIndex);
    return this;
  }

  AppButtonModel copyWith({
    TextStyle? textStyle,
    EdgeInsets? padding,
    BoxDecoration? decoration,
  }) {
    return AppButtonModel(
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
    );
  }
}
