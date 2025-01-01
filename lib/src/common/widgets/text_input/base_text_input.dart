import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_padding.dart';
import '../../extension/context_extension.dart';
import '../../util/regexp.dart';

typedef TextInputValidator = String? Function(String?);

class BaseTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputValidator? validator;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autoValidateMode;

  final String hintText;
  final String? labelText;
  final String? initialValue;
  final String? accessibilityLabel;

  final bool? enabled;
  final bool? isDense;
  final bool? enableInteractiveSelection;
  final bool obscureText;
  final bool showCursor;
  final bool readOnly;
  final bool? isFilled;
  final bool enableCounterText;

  final int? maxLength;
  final int? maxLines;

  final Widget? prefix;
  final Widget? suffix;
  final Widget? labelIcon;

  final Color fillColor;
  final Color? focusColor;

  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;

  const BaseTextInput({
    super.key,
    this.labelText,
    required this.hintText,
    this.controller,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.enabled,
    this.maxLines,
    this.maxLength,
    this.enableCounterText = false,
    this.keyboardType,
    this.focusNode,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.fillColor = AppColors.white,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.isDense,
    this.accessibilityLabel = '',
    this.enabledBorder,
    this.focusedBorder,
    this.disabledBorder,
    this.focusedErrorBorder,
    this.errorBorder,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.showCursor = true,
    this.enableInteractiveSelection,
    this.contentPadding,
    this.focusColor,
    this.errorStyle,
    this.readOnly = false,
    this.isFilled,
    this.labelIcon,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText?.isNotEmpty == true)
          Padding(
            padding: AppPadding.pb4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelText!,
                  style: labelStyle,
                ),
                8.horizontalSpace,
                if (labelIcon != null) labelIcon!,
              ],
            ),
          ),
        TapRegion(
          onTapOutside: (_) {
            // Close the keyboard when user click outside the text field
            // FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Semantics(
            onSetText: (value) => controller?.text = value,
            excludeSemantics: true,
            label: 'text-input-$accessibilityLabel',
            child: TextFormField(

              controller: controller,
              validator: validator,
              inputFormatters: [
                /// Default regex for prevent injection attack
                FilteringTextInputFormatter.deny(
                  RegExp(RegExps.sanitationFormat),
                ),

                ...?inputFormatters,
              ],
              showCursor: showCursor,
              onTap: onTap,
              enableInteractiveSelection: enableInteractiveSelection,
              textCapitalization: textCapitalization,
              initialValue: initialValue,
              focusNode: focusNode,
              enabled: enabled,
              maxLines: maxLines,
              maxLength: maxLength,
              style: textStyle,
              obscureText: obscureText,
              onChanged: onChanged,
              keyboardType: keyboardType,
              textAlign: textAlign,
              readOnly: readOnly,
              autovalidateMode: autoValidateMode,
              cursorColor: context.theme.primaryColor,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return Transform.translate(
                  offset: const Offset(0, -30),
                  child: Text(
                    '$currentLength/$maxLength',
                  ),
                );
              },
              decoration: InputDecoration(
                errorStyle: errorStyle,
                focusColor: focusColor,
                contentPadding: contentPadding,
                hintText: hintText,
                hintStyle: hintStyle,
                isDense: isDense,
                counterText: enableCounterText ? null : '',
                disabledBorder: disabledBorder,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
                focusedErrorBorder: focusedErrorBorder,
                filled: isFilled,
                fillColor: fillColor,
                prefixIcon: prefix,
                suffixIcon: suffix,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
