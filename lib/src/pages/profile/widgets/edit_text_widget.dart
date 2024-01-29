import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/keyboard_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/custom_button.dart';
import 'text_field.dart';

typedef OnChange = Function(double value);

class EditTextWidget extends StatefulWidget {
  const EditTextWidget({
    this.title,
    this.controller,
    this.removeValueOnFocus = true,
    this.onChangeCalories,
    super.key,
  });

  final String? title;
  final TextEditingController? controller;
  final bool removeValueOnFocus;
  final OnChange? onChangeCalories;

  @override
  State<EditTextWidget> createState() => _EditTextWidgetState();
}

class _EditTextWidgetState extends State<EditTextWidget> {
  String? _previousValue;
  OverlayEntry? _overlayEntry;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.h16, vertical: Dimens.h12),
            child: Text(
              widget.title ?? '',
              style: AppStyles.style17,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.h5),
          child: Container(
            width: Dimens.w100,
            height: Dimens.h34,
            decoration: const BoxDecoration(
              color: AppColors.passioMedContrast,
            ),
            child: Center(
              child: MyTextField(
                controller: widget.controller,
                border: InputBorder.none,
                filled: true,
                fillColor: AppColors.passioMedContrast,
                textStyle: AppStyles.style17,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                isDense: true,
                textAlign: TextAlign.end,
                onTap: () {
                  if (widget.removeValueOnFocus) {
                    widget.controller?.clear();
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                focusNode: _focusNode,
              ),
            ),
          ),
        ),
        Dimens.w20.horizontalSpace,
      ],
    );
  }

  void _initialize() {
    // Here, we are updating the previous value from text controller.
    _previousValue = widget.controller?.text;
    // Here waiting to render the frames. so the gets context properly.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Adding listener to the focus node.
      _focusNode.addListener(() {
        // Checking node has focus.
        if (_focusNode.hasFocus) {
          // show OK button on the overlay.
          _showOkButtonOverlay(context);
        } else {
          // If focus is removed then check user has inputted the number
          final text = widget.controller?.text;
          if ((text.isNotNullOrEmpty) && double.tryParse(text ?? '') != null) {
            _previousValue = widget.controller?.text;
            widget.onChangeCalories?.call(double.parse(_previousValue ?? '0'));
          } else {
            widget.controller?.text = _previousValue ?? '';
          }
          // If focus is removed then removing the ok button from screen.
          _removeOkButtonOverlay();
        }
      });
    });
  }

  void _showOkButtonOverlay(BuildContext context) {
    if (_overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              onTap: () {
                context.hideKeyboard();
              },
              text: context.localization?.ok ?? '',
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  void _removeOkButtonOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
