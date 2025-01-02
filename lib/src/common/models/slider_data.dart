import 'dart:math' as math;

import 'food_record/food_record.dart';

class SliderData {
  final double minSlider;
  final double maxSlider;
  final int divisions;

  static double get _sliderMultiplier => 5.0;

  static ({String? unit, double value}) _cachedMaxForSlider =
      (unit: null, value: 0);

  const SliderData({
    this.minSlider = FoodRecord.zeroQuantity,
    this.maxSlider = 5,
    this.divisions = 10,
  });

  SliderData updateSliderData(
    String unit,
    double selectedQuantity,
  ) {
    final currentValue = selectedQuantity;

    double maxSlider = _sliderMultiplier;

    if (_cachedMaxForSlider.unit != unit) {
      maxSlider = _sliderMultiplier * math.max(currentValue, 1);
      _cachedMaxForSlider = (
        unit: unit,
        value: maxSlider,
      );
    } else if (_cachedMaxForSlider.value > _sliderMultiplier &&
        _cachedMaxForSlider.value > currentValue) {
      maxSlider = _cachedMaxForSlider.value;
    } else if (_sliderMultiplier > currentValue) {
      maxSlider = _sliderMultiplier;
    } else {
      maxSlider = currentValue;
      _cachedMaxForSlider = (unit: unit, value: currentValue);
    }

    if (maxSlider >= 500) {
      maxSlider = (maxSlider / 10).ceilToDouble() * 10;
    } else {
      maxSlider = maxSlider.ceilToDouble();
    }
    return SliderData(
      minSlider: FoodRecord.zeroQuantity,
      maxSlider: maxSlider,
      divisions: switch (maxSlider) {
        < 10 => (maxSlider / 0.5).round(),
        < 500 => (maxSlider / 1).round(),
        _ => (maxSlider / 10).round(),
      },
    );
  }
}
