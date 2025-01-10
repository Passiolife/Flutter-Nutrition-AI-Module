import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/models/micro_nutrient/micro_nutrient.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/double_extensions.dart';

class NutrientTableWidget extends StatelessWidget {
  const NutrientTableWidget({this.nutrientList, super.key});

  final List<MicroNutrient>? nutrientList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: AppPadding.pv16 + EdgeInsets.only(bottom: context.bottomPaddingValue),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 190.w / 124.h,
      ),
      itemCount: nutrientList?.length ?? 0,
      itemBuilder: (context, index) {
        final data = nutrientList?.elementAt(index);
        return NutrientTableRow(nutrient: data);
      },
    );
  }
}

class NutrientTableRow extends StatelessWidget {
  const NutrientTableRow({
    this.nutrient,
    super.key,
  });

  final MicroNutrient? nutrient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: AppPadding.pa16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16.h,
        children: [
          FittedBox(
            child: Text(
              nutrient?.name ?? '',
              style: AppTextStyle.textLg.addAll(
                  [AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
            ),
          ),
          Center(
            child: FittedBox(
              child: RichText(
                text: TextSpan(
                  text: nutrient?.value.format(places: 2),
                  style: AppTextStyle.text3xl.addAll([
                    AppTextStyle.text3xl.leading9,
                    AppTextStyle.extraBold
                  ]).copyWith(color: AppColors.indigo600Main),
                  children: [
                    WidgetSpan(
                      child: SizedBox(width: 4.w),
                    ),
                    TextSpan(
                      text: nutrient?.unitSymbol ?? '',
                      style: AppTextStyle.textBase
                          .copyWith(color: AppColors.gray500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
