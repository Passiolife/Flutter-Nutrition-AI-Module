import 'package:flutter/material.dart';

import '../constant/app_constants.dart';

class AppSlider extends StatelessWidget {
  const AppSlider({
    this.value = 0,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChanged,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        sliderTheme: SliderThemeData(
          trackHeight: AppDimens.h8,
          activeTrackColor: AppColors.indigo600Main,
          inactiveTrackColor: AppColors.indigo50,
          thumbColor: AppColors.indigo600Main,
          valueIndicatorColor: AppColors.indigo600Main,
          valueIndicatorTextStyle:
              AppTextStyle.textXs.copyWith(color: AppColors.white),
          trackShape: const _CustomTrackShape(),
          tickMarkShape: SliderTickMarkShape.noTickMark,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: AppDimens.r12),
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  const _CustomTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
