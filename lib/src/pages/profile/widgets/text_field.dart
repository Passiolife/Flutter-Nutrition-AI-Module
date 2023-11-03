import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/util/keyboard_extension.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    this.onFieldSubmitted,
    this.fillColor,
    this.filled = false,
    this.isDense = false,
    this.onTapOutside,
    this.contentPadding,
    this.textStyle,
    this.textAlign =  TextAlign.start,
    this.border,
    this.inputType,
    this.inputFormatters,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.onTap,
    this.focusNode,
    this.suffixIcon,
    this.suffix,
    super.key,
  });

  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final bool filled;
  final bool isDense;
  final VoidCallback? onTapOutside;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final InputBorder? border;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  //
  final Widget? suffixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: (_) {
        if (onTapOutside != null) {
          onTapOutside?.call();
        } else {
          context.hideKeyboard();
        }
      },
      style: textStyle,
      decoration: InputDecoration(
        border: border,
        fillColor: fillColor,
        filled: filled,
        isDense: isDense,
        contentPadding: contentPadding ?? EdgeInsets.zero,
        hintText: hintText,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        suffix: suffix,
      ),
      textAlign: textAlign,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      onTap: onTap,
      focusNode: focusNode,
    );
  }
}
