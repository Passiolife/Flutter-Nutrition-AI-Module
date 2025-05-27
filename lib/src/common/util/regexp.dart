// ignore: avoid_classes_with_only_static_members
abstract class RegExps {
  static final RegExp email = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // [password] should be a-z or A-Z and 0-9.
  static final RegExp password =
      RegExp(r'^(?=.*[a-z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$');

  static final RegExp number = RegExp(r'\d+');
  static final RegExp string = RegExp(r'[a-zA-Z]+');

  // Allows only numeric values, including decimals.
  static final RegExp decimalNumber = RegExp(r'^\d+,?\.?\d*');

  // static final RegExp decimalNumber = RegExp(r'^\d+[,.]*\d*$');

  // RegEx for prevent injection attack
  static String sanitationFormat = r'[<>]';

  // The regex pattern is designed to permit digits optionally interspersed with a single period or comma as a decimal separator.
  static RegExp singleDecimalNumericInput = RegExp(r'^\d*([.,])?\d*$');
}

abstract class NumberRegExps {
  /// Regular expression to match decimal numbers that can optionally include
  /// a comma as a thousands separator and an optional decimal point.
  ///
  /// This regular expression matches the following patterns:
  /// - Integer numbers (e.g., `123`, `4567`)
  /// - Decimal numbers with optional one digit after the decimal point (e.g., `123.4`, `4567.5`)
  /// - Numbers with an optional thousands separator (comma) (e.g., `123,456`, `123,`)
  /// - Optional fractional part after the decimal (e.g., `123.`, `123.45`, `123,45`)
  ///
  /// It allows the following formats:
  /// - `123`, `123.4`, `123.45`, `123,45`, `123,`
  ///
  /// It does not allow:
  /// - Leading dots like `.123`
  /// - Leading commas like `,123`
  /// - Double commas like `123,,`
  /// - Multiple dots like `123..45`
  ///
  /// Example usages:
  /// ```dart
  /// final regex = RegExp(r'^\d+,?\.?\d*');
  /// print(regex.hasMatch('123.45'));  // true
  /// print(regex.hasMatch('123,45'));  // true
  /// print(regex.hasMatch('123,'));    // true
  /// print(regex.hasMatch('123.'));    // true
  /// print(regex.hasMatch('123,456')); // true
  /// ```
  static final RegExp singleCommaOrDecimalNumberRegex = RegExp(r'^\d+,?\.?\d*');
}