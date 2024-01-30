import 'dart:math' as math;

import 'package:intl/intl.dart';

extension Util on double? {
  String get removeDecimalZeroFormat => NumberFormat('##.##', 'en_US').format(this);

  double roundNumber(int places) {
    if (this != null && !this!.isNaN) {
      num val = math.pow(10.0, places);
      return (((this!) * val).round().toDouble() / val); // 0.0005
    }
    return 0;
  }
}
