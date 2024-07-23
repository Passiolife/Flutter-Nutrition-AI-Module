import 'package:flutter/services.dart';

import 'regexp.dart';

abstract class TextInputFormatterUtil {
  static final TextInputFormatter decimalNumber =
      FilteringTextInputFormatter.allow(RegExps.decimalNumber);
}
