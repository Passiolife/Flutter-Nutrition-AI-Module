import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_colors.dart';
import '../constant/dimens.dart';
import '../constant/styles.dart';
import '../util/keyboard_extension.dart';

///[AppTextField] Common text field.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final VoidCallback? onTapOutside;
  final String? obscuringCharacter;
  final void Function(String)? onChange;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? textInputFormatter;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final bool filled;
  final bool isDense;

  const AppTextField({
    Key? key,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.validator,
    this.hintText,
    this.onTapOutside,
    this.obscuringCharacter,
    this.onChange,
    this.textInputFormatter,
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.fillColor,
    this.filled = true,
    this.isDense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: textInputFormatter,
      onTapOutside: (_) {
        if (onTapOutside != null) {
          onTapOutside?.call();
        } else {
          context.hideKeyboard();
        }
      },
      obscuringCharacter: obscuringCharacter ?? '•',
      controller: controller,
      cursorRadius: Radius.circular(Dimens.r1),
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      obscureText: obscureText ?? false,
      validator: validator,
      style: AppStyles.style14.copyWith(
        fontWeight: FontWeight.w400,
        height: 1,
      ),
      onChanged: onChange,
      decoration: InputDecoration(
          isDense: isDense,
          contentPadding: EdgeInsets.all(Dimens.r8),
          hintText: hintText ?? "",
          fillColor: fillColor ?? AppColors.passioMedContrast,
          filled: filled,
          hintStyle: AppStyles.style14.copyWith(color: AppColors.hintColor),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimens.r8), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimens.r8), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimens.r8), borderSide: BorderSide.none),
          suffix: suffixIcon ??
              ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (controller.text.isNotEmpty) {
                      return Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.textFieldIconBgColor, shape: BoxShape.circle),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                controller.clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                                size: 14,
                              )));
                    } else {
                      return const SizedBox();
                    }
                  })),
    );
  }
}
