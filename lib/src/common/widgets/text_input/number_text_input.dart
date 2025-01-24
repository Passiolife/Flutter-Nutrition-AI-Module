import 'dart:io' show Platform;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_constants.dart';
import '../../extension/context_extension.dart';
import '../../extension/number_extension.dart';
import '../keyboard/done_keyboard_button_widget.dart';
import '../overlay/overlay_manager.dart';
import 'base_text_input.dart';

class NumberTextInput extends StatefulWidget {
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
  final CrossAxisAlignment crossAxisAlignment;
  final AutovalidateMode? autoValidateMode;

  final String hintText;
  final String? labelText;
  final Alignment? labelAlignment;
  final String? initialValue;
  final String? accessibilityLabel;
  final String? footnote;

  final bool? isDense;
  final bool? enableInteractiveSelection;
  final bool? isFilled;
  final bool isPassword;
  final bool enableCounterText;
  final bool showCursor;
  final bool readOnly;
  final bool enabled;

  final int? maxLength;
  final int? maxLines;

  final Widget? prefix;

  final Widget? suffix;
  final BoxConstraints? suffixIconConstraints;

  final String? suffixText;

  final Widget? footNoteIcon;
  final Widget? labelIcon;

  final Color fillColor;
  final Color? focusColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;

  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? suffixStyle;
  final TextStyle? errorStyle;

  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;

  final BorderRadius? borderRadius;
  final ValueChanged<String>? onFieldSubmitted;

  const NumberTextInput({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.labelAlignment,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.enabled = true,
    this.maxLength,
    this.keyboardType,
    this.focusNode,
    this.isPassword = false,
    this.prefix,
    this.suffix,
    this.suffixIconConstraints,
    this.suffixText,
    this.enableCounterText = false,
    this.fillColor = Colors.white,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.suffixStyle,
    this.textAlign = TextAlign.start,
    this.isDense,
    this.accessibilityLabel = '',
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.showCursor = true,
    this.enableInteractiveSelection,
    this.footnote,
    this.footNoteIcon,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.readOnly = false,
    this.contentPadding,
    this.isFilled,
    this.focusColor,
    this.errorStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.disabledBorder,
    this.focusedErrorBorder,
    this.errorBorder,
    this.labelIcon,
    this.borderRadius,
    this.autoValidateMode,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.onFieldSubmitted,
    this.maxLines = 1,
  });

  @override
  State<NumberTextInput> createState() => _NumberTextInputState();
}

class _NumberTextInputState extends State<NumberTextInput> {
  bool _isVisibility = false;

  FocusNode? _focusNode;
  OverlayManager? _overlayManager;
  late TextEditingController _controller;
  ValueChanged<String>? _onFieldSubmitted;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (Platform.isIOS) {
      _overlayManager = OverlayManager();
      _focusNode!.addListener(_handleFocusChange);
    }
    _onFieldSubmitted = widget.onFieldSubmitted;
    super.initState();
  }

  void _handleFocusChange() {
    if (_focusNode!.hasFocus) {
      _overlayManager?.showOverlay(context, DoneKeyboardButtonWidget(
        onDone: () {
          final text = _controller.text;
          if (text.isNotEmpty) {
            _setAndUpdateText(text);
            // final formatted = text.localeFormatted<double?>();
            // if (formatted == null) return;
            // _controller.text = formatted.format();
            // _onFieldSubmitted?.call(formatted.format());
          } else {
            _setAndUpdateText(widget.initialValue ?? '');
            // final formatted = double.tryParse(widget.initialValue ?? '');
            // if (formatted == null) return;
            // _controller.text = formatted.format();
            // _onFieldSubmitted?.call(formatted.format());
          }
        },
      ));
    } else {
      _overlayManager?.removeOverlay();
    }
  }

  void _setAndUpdateText(String value) {
    if (value.isNotEmpty) {
      double? formatted = value.localeFormatted();
      if (formatted == null) return;
      _controller.text = formatted.format();
      _onFieldSubmitted?.call(formatted.format());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        BaseTextInput(
          textStyle: widget.textStyle ??
              AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                color: context.textThemeColors.brandTextDark,
              ),
          onFieldSubmitted: _setAndUpdateText,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          focusNode: _focusNode,
          labelText: widget.labelText,
          labelAlignment: widget.labelAlignment,
          hintText: widget.hintText,
          controller: _controller,
          inputFormatters: widget.inputFormatters,
          // initialValue: widget.initialValue,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType ??
              TextInputType.numberWithOptions(decimal: true),
          obscureText: widget.isPassword && !_isVisibility,
          prefix: widget.prefix,
          suffixText: widget.suffixText,
          suffix: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isVisibility
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  iconSize: 20.r,
                  onPressed: () {
                    setState(
                      () {
                        _isVisibility = !_isVisibility;
                      },
                    );
                  },
                )
              : widget.suffix,
          suffixIconConstraints: widget.suffixIconConstraints,
          labelIcon: widget.labelIcon,

          contentPadding:
              widget.contentPadding ?? AppPadding.ph12 + AppPadding.pv10,
          focusColor: context.theme.primaryColor,
          isFilled: widget.enabled == false ? true : widget.isFilled,
          fillColor:
              widget.enabled ? widget.fillColor : context.colorScheme.surface,
          errorStyle: widget.errorStyle ??
              AppTextStyle.textXs.copyWith(
                color: context.textThemeColors.errorColor,
              ),
          labelStyle: widget.labelStyle ??
              AppTextStyle.textSm.addAll(
                  [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
                color: context.textThemeColors.brandTextLight,
              ),
          hintStyle: widget.hintStyle ??
              AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                color: context.textThemeColors.brandTextLight,
              ),
          suffixStyle: widget.suffixStyle ??
              AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                color: context.textThemeColors.brandTextLight,
              ),
          textAlign: widget.textAlign,
          isDense: widget.isDense,
          accessibilityLabel: widget.accessibilityLabel,
          autoValidateMode: widget.autoValidateMode,
          enableCounterText: widget.enableCounterText,
          enabledBorder: widget.enabledBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? AppColors.brandBorders,
                  width: 1,
                ),
                borderRadius: widget.borderRadius ?? AppBorderCircular.ba10,
              ),
          focusedBorder: widget.focusedBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.focusedBorderColor ?? context.theme.primaryColor,
                  width: 1,
                ),
                borderRadius: widget.borderRadius ?? AppBorderCircular.ba10,
              ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: ColorConstants.bgWeak50,
              width: 1,
            ),
            borderRadius: widget.borderRadius ?? AppBorderCircular.ba10,
          ),
          focusedErrorBorder: widget.focusedErrorBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.textThemeColors.errorColor ?? Colors.red,
                  width: 1,
                ),
                borderRadius: widget.borderRadius ?? AppBorderCircular.ba10,
              ),
          errorBorder: widget.errorBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.textThemeColors.errorColor ?? Colors.red,
                  width: 1,
                ),
                borderRadius: widget.borderRadius ?? AppBorderCircular.ba10,
              ),
          textCapitalization: widget.textCapitalization,
          onTap: widget.onTap,
          showCursor: widget.showCursor,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          validator: (_) {
            return widget.validator?.call(widget.controller?.text);
          },
        ),
        if (widget.footnote?.isNotEmpty == true)
          Padding(
            padding: AppPadding.pt4,
            child: Row(
              children: [
                if (widget.footNoteIcon != null) widget.footNoteIcon!,
                Text(
                  widget.footnote ?? '',
                ),
              ],
            ),
          )
      ],
    );
  }
}
