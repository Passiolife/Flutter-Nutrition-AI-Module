import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_constants.dart';
import '../../extension/core_extension.dart';
import '../../extension/widget_extension.dart';
import '../../models/key_value_model.dart';

class BaseDropdown<T> extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? labelIcon;
  final Alignment? labelAlignment;

  final KeyValueModel<T>? value;
  final Widget? prefixIcon;
  final String hint;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<T>? validator;
  final List<KeyValueModel<T>> options;
  final ValueChanged<KeyValueModel<T>?>? onSelected;
  final BorderRadius? radius;
  final double? height;
  final EdgeInsets? paddingLabel;
  final bool showIcon;
  final TextStyle? textStyle;

  const BaseDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onSelected,
    this.labelText,
    this.labelStyle,
    this.labelIcon,
    this.labelAlignment,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.always,
    this.validator,
    this.prefixIcon,
    this.hint = 'Select an option',
    this.radius,
    this.height,
    this.paddingLabel,
    this.textStyle,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText?.isNotEmpty == true)
          Padding(
            padding: AppPadding.pb8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelText!,
                  style: labelStyle,
                ),
                if (labelIcon != null) ...[8.horizontalSpace, labelIcon!],
              ],
            ),
          ).wrapIf(
            labelAlignment != null,
            (child) => Align(alignment: labelAlignment!, child: child),
          ),
        SizedBox(
          height: 45.h,
          width: context.width,
          child: DropdownMenu<KeyValueModel<T>>(
            expandedInsets: EdgeInsets.zero,
            width: context.width,
            initialSelection: value,
            hintText: hint,
            textStyle: textStyle,
            leadingIcon: showIcon
                ? value != null
                    ? Padding(
                        padding: AppPadding.ph12 + AppPadding.pv12,
                        child: value!.icon,
                      )
                    : prefixIcon
                : null,
            trailingIcon: VectorGraphic(
                loader: AssetBytesLoader(AppImages.icChevronDownNew)),
            selectedTrailingIcon: VectorGraphic(
                loader: AssetBytesLoader(AppImages.icChevronUpNew)),
            menuStyle: MenuStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(context.colorScheme.surface),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: AppBorderCircular.ba10,
                ),
              ),
              elevation: WidgetStateProperty.all<double>(1.r),
            ),
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintStyle: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                      color: context.textThemeColors.brandTextLight),
              contentPadding: AppPadding.pa10,
              fillColor: context.colorScheme.surface,
              border: MaterialStateOutlineInputBorder.resolveWith(
                (states) {
                  return states.contains(WidgetState.focused)
                      ? OutlineInputBorder(
                          borderRadius: radius ?? AppBorderCircular.ba10,
                          borderSide:
                              BorderSide(color: context.theme.primaryColor))
                      : OutlineInputBorder(
                          borderRadius: radius ?? AppBorderCircular.ba10,
                          borderSide: BorderSide(
                            color: AppColors.brandBorders,
                          ),
                        );
                },
              ),
            ),
            dropdownMenuEntries: options.map((KeyValueModel<T> item) {
              return DropdownMenuEntry<KeyValueModel<T>>(
                value: item,
                leadingIcon: item.icon,
                label: item.text,
                labelWidget: Padding(
                  padding: paddingLabel ?? AppPadding.pt4,
                  child: Text(
                    item.text,
                    style: AppTextStyle.textBase
                        .addAll([AppTextStyle.textBase.leading6]).copyWith(
                            color: context.textThemeColors.brandTextDark),
                  ),
                ),
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all<TextStyle>(
                    AppTextStyle.textBase
                        .addAll([AppTextStyle.textBase.leading6]).copyWith(
                            color: context.textThemeColors.brandTextDark),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    context.colorScheme.surface,
                  ),
                  foregroundColor: value == item
                      ? WidgetStateProperty.all<Color>(
                          context.theme.primaryColor)
                      : null,
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: AppBorderCircular.ba10,
                    ),
                  ),
                ),
              );
            }).toList(),
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}
