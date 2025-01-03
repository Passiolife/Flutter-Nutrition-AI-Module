import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_border.dart';
import '../../constant/app_constants.dart';
import '../../constant/app_padding.dart';
import '../../extension/context_extension.dart';
import '../../models/key_value_model.dart';

class PrimaryDropdown<T> extends StatefulWidget {
  final KeyValueModel<T>? value;
  final String label;
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

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onSelected,
    required this.label,
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
  State<PrimaryDropdown<T>> createState() => _PrimaryDropdownState<T>();
}

class _PrimaryDropdownState<T> extends State<PrimaryDropdown<T>> {
  final ValueNotifier<String?> _errorText = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading5,
            AppTextStyle.medium
          ]).copyWith(color: context.textThemeColors.brandTextLight),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: _errorText,
          builder: (BuildContext context, String? errorText, child) {
            return SizedBox(
              height: 45.h,
              width: context.width,
              child: DropdownMenu<KeyValueModel<T>>(
                expandedInsets: EdgeInsets.zero,
                width: context.width,
                initialSelection: widget.value,
                hintText: widget.hint,
                textStyle: widget.textStyle ?? AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: context.textThemeColors.brandTextDark),
                errorText: errorText,
                leadingIcon: widget.showIcon
                    ? widget.value != null
                        ? Padding(
                            padding: AppPadding.ph12 + AppPadding.pv12,
                            child: widget.value!.icon,
                          )
                        : widget.prefixIcon
                    : null,
                trailingIcon: VectorGraphic(
                    loader: AssetBytesLoader(AppImages.icChevronDownNew)),
                selectedTrailingIcon: VectorGraphic(
                    loader: AssetBytesLoader(AppImages.icChevronUpNew)),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      context.colorScheme.surface),
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
                              borderRadius:
                                  widget.radius ?? AppBorderCircular.ba10,
                              borderSide:
                                  BorderSide(color: context.theme.primaryColor))
                          : OutlineInputBorder(
                              borderRadius:
                                  widget.radius ?? AppBorderCircular.ba10,
                              borderSide: BorderSide(
                                color: AppColors.brandBorders,
                              ),
                            );
                    },
                  ),
                ),
                dropdownMenuEntries:
                    widget.options.map((KeyValueModel<T> item) {
                  return DropdownMenuEntry<KeyValueModel<T>>(
                    value: item,
                    leadingIcon: item.icon,
                    label: item.text,
                    labelWidget: Padding(
                      padding: widget.paddingLabel ?? AppPadding.pt4,
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
                      foregroundColor: widget.value == item
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
                onSelected: widget.onSelected,
              ),
            );
          },
        )
      ],
    );
  }
}
