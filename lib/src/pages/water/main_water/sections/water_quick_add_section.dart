import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../bloc/water_bloc.dart';
import '../widgets/water_quick_add_item_widget.dart';

class WaterQuickAddSection extends StatelessWidget {
  const WaterQuickAddSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      buildWhen: (_, state) {
        return state is UpdateQuickAddState;
      },
      builder: (context, state) {
        double glassValue = context.read<WaterBloc>().glassValue;
        double smallBottleValue = context.read<WaterBloc>().smallBottleValue;
        double largeBottleValue = context.read<WaterBloc>().largeBottleValue;
        String unitSymbol = context.read<WaterBloc>().unitSymbol;

        return Container(
          padding: AppPadding.pa16,
          margin: AppPadding.ph16,
          decoration: AppShadows.base,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization.quickAdd ?? '',
                style: AppTextStyle.textLg
                    .addAll(
                    [AppTextStyle.textLg.leading6, AppTextStyle.semiBold]),
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: WaterQuickAddItemWidget(
                      icon: AppImages.icWaterGlassNew,
                      width: 38.w,
                      height: 41.h,
                      type: context.localization.glass ?? '',
                      value: glassValue,
                      unit: unitSymbol,
                      onTap: () => _handleTap(context: context, value: glassValue),
                    ),
                  ),
                  Expanded(
                    child: WaterQuickAddItemWidget(
                      icon: AppImages.icWaterSmallBottleNew,
                      width: 24.w,
                      height: 59.h,
                      type: context.localization.smBottle ?? '',
                      value: smallBottleValue,
                      unit: unitSymbol,
                      onTap: () => _handleTap(context: context, value: smallBottleValue),
                    ),
                  ),
                  Expanded(
                    child: WaterQuickAddItemWidget(
                      icon: AppImages.icWaterLargeBottleNew,
                      width: 29.w,
                      height: 59.h,
                      type: context.localization.lgBottle ?? '',
                      value: largeBottleValue,
                      unit: unitSymbol,
                      onTap: () => _handleTap(context: context, value: largeBottleValue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap({required BuildContext context, required double value}) {
    context.read<WaterBloc>().add(QuickAddEvent(consumedWater: value));
  }
}
