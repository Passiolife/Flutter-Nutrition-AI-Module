import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    /// Remove all commas before formatting
    final newText = newValue.text.replaceAll(',', '');

    /// Parse the number and format with commas
    final number = int.tryParse(newText);
    if (number == null) {
      return oldValue;
    }

    final formatter = NumberFormat('#,###');
    final newString = formatter.format(number);

    // Create new selection
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
