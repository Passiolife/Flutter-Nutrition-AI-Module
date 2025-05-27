import 'package:flutter/services.dart';

import 'regexp.dart';

abstract class TextInputFormatterUtil {
  /// A [TextInputFormatter] that allows only numbers with an optional comma
  /// for thousands separation and an optional decimal point.
  ///
  /// This formatter allows:
  /// - Whole numbers (e.g., `123`, `4567`)
  /// - Decimal numbers with an optional fractional part (e.g., `123.4`, `4567.5`)
  /// - Numbers with an optional thousands separator (comma) (e.g., `123,456`, `123,`)
  /// - Optional fractional part after the decimal (e.g., `123.`, `123.45`, `123,45`)
  ///
  /// It ensures that the input value follows the expected format and prevents
  /// invalid characters or structures like double commas, leading commas, or
  /// multiple dots in the number.
  ///
  /// Example:
  /// ```dart
  /// final inputFormatter = TextInputFormatterUtil.decimalNumber;
  /// ```
  static final TextInputFormatter decimalNumber =
      FilteringTextInputFormatter.allow(RegExps.decimalNumber);
}

abstract class NumberInputFormatter {
  /// A [TextInputFormatter] that allows only numbers with an optional comma
  /// for thousands separation and an optional decimal point.
  ///
  /// This formatter allows:
  /// - Whole numbers (e.g., `123`, `4567`)
  /// - Decimal numbers with an optional fractional part (e.g., `123.4`, `4567.5`)
  /// - Numbers with an optional thousands separator (comma) (e.g., `123,456`, `123,`)
  /// - Optional fractional part after the decimal (e.g., `123.`, `123.45`, `123,45`)
  ///
  /// It ensures that the input value follows the expected format and prevents
  /// invalid characters or structures like double commas, leading commas, or
  /// multiple dots in the number.
  ///
  /// Example:
  /// ```dart
  /// final inputFormatter = TextInputFormatterUtil.decimalNumber;
  /// ```
  static final TextInputFormatter singleCommaOrDecimalFormatter =
      FilteringTextInputFormatter.allow(
          NumberRegExps.singleCommaOrDecimalNumberRegex);
}
