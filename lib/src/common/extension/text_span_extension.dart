import 'package:flutter/material.dart';

extension TextSpanExtension on String {
  List<TextSpan> generateSpans({
    required TextStyle defaultStyle,
    required Map<String, TextStyle> highlightStyles,
  }) {
    final spans = <TextSpan>[];
    String remainingText = this;

    highlightStyles.forEach((keyword, style) {
      final index = remainingText.indexOf(keyword);

      if (index != -1) {
        if (index > 0) {
          spans.add(TextSpan(text: remainingText.substring(0, index), style: defaultStyle));
        }

        spans.add(TextSpan(text: keyword, style: style));

        remainingText = remainingText.substring(index + keyword.length);
      }
    });

    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText, style: defaultStyle));
    }

    return spans;
  }
}
