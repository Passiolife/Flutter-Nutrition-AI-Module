import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constant/app_colors.dart';

class AppLoadingButtonWidget extends StatelessWidget {
  const AppLoadingButtonWidget({
    this.color,
    this.backgroundColor,
    this.width = 40,
    this.height = 20,
    super.key,
  });

  factory AppLoadingButtonWidget.primary() {
    return AppLoadingButtonWidget(color: AppColors.indigo700);
  }

  factory AppLoadingButtonWidget.secondary() {
    return AppLoadingButtonWidget(color: AppColors.white);
  }

  final Color? color;
  final Color? backgroundColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: LoadingIndicator(
        indicatorType: Indicator.ballPulse,
        colors: [color ?? AppColors.indigo600Main],
        backgroundColor: backgroundColor,
      ),
    );
  }
}
