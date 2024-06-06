import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constant/app_colors.dart';

class AppLoadingButtonWidget extends StatelessWidget {
  const AppLoadingButtonWidget({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 20,
      child: LoadingIndicator(
        indicatorType: Indicator.ballPulse,
        colors: [color ?? AppColors.indigo600Main],
      ),
    );
  }
}
