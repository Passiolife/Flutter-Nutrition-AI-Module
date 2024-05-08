extension NormalizeExtension on num {
  double normalizeToMultipleOf(int multiple) {
    assert(multiple > 0, "Multiple should be greater than 0");

    double roundedValue = (this / multiple).roundToDouble() * multiple;
    return roundedValue > this ? roundedValue : roundedValue + multiple;
  }
}