import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_constants.dart';
import '../util/keyboard_extension.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.width,
    this.height,
    this.controller,
    this.style,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.textAlign,
    this.keyboardType,
    this.inputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.onTapOutside,
    this.inputFormatters,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIcon,
    this.validator,
    this.suffixIconConstraints,
    this.maxLength,
    this.onChanged,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.borderColor = AppColors.gray300,
    this.cursorColor = AppColors.indigo600Main,
    super.key,
  });

  final double? width;
  final double? height;
  final TextEditingController? controller;
  final Color? cursorColor;
  final TextStyle? style;
  final String? hintText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color borderColor;
  final EdgeInsets scrollPadding;
  final bool readOnly;
  final bool autofocus;
  final GestureTapCallback? onTap;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TapRegionCallback? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final FormFieldValidator? validator;
  final int? maxLength;
  final ValueChanged<String>? onChanged;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: AppShadows.sm,
      child: TextFormField(
        onChanged: onChanged,
        autofocus: autofocus,
        inputFormatters: inputFormatters,
        onTapOutside: onTapOutside ?? (_) {
          context.hideKeyboard();
        },
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: inputAction,
        onFieldSubmitted: onFieldSubmitted,
        textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: cursorColor,
        scrollPadding: scrollPadding,
        validator: validator,
        maxLength: maxLength,
        style: style ??
            AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray900),
        decoration: InputDecoration(
          hintStyle: hintStyle,
          hintText: hintText,
          isDense: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: AppDimens.h8,
                horizontal: AppDimens.w12,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          suffix: suffix,
          suffixIcon: suffixIcon,
          suffixStyle: suffixStyle,
          suffixText: suffixText,
          suffixIconConstraints: suffixIconConstraints,
        ),
      ),
    );
  }
}
