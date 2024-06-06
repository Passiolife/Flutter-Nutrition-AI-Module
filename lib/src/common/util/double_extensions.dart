import 'dart:math' as math;

import 'package:intl/intl.dart';

extension DoubleExtension on double? {
  /// for ex: 3.14159 would return 3.14 if places is 2.
  /// for ex: 3.14159 would return 3.1 if places is 1.
  double roundTo({int places = 1}) {
    if (this != null && !this!.isNaN) {
      num val = math.pow(10.0, places);
      return (((this!) * val).round().toDouble() / val);
    }
    return 0;
  }

  /// Formats the double value without trailing zeros.
  String format({int places = 1}) {
    if (this == null) return '';
    double roundedNumber = (places > 0)
        ? double.parse(this!.toStringAsFixed(places))
        : this!.toInt().toDouble();
    return NumberFormat('##.##', 'en_US').format(roundedNumber);
  }

  /// Formats the double value without trailing zeros and parses it back to double.
  double parseFormatted({int places = 1}) {
    return double.parse(format(places: places));
  }
}
