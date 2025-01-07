import 'package:flutter/services.dart';

class SingleDecimalFormatter extends TextInputFormatter {
  const SingleDecimalFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow the initial decimal input
    if (newValue.text.contains('.') || newValue.text.contains(',')) {
      int firstDecimalIndex = newValue.text.indexOf(RegExp(r'[.,]'));
      String beforeDecimal = newValue.text.substring(0, firstDecimalIndex + 1);
      String afterDecimal = newValue.text.substring(firstDecimalIndex + 1).replaceAll(RegExp(r'[.,]'), '');

      return TextEditingValue(
        text: beforeDecimal + afterDecimal,
        selection: TextSelection.collapsed(offset: beforeDecimal.length + afterDecimal.length),
      );
    }

    // Return new value if no further processing is needed
    return newValue;
  }
}