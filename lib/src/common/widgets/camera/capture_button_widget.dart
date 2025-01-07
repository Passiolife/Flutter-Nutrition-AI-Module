import 'dart:async';

import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_padding.dart';
import '../../extension/context_extension.dart';

class CaptureButtonWidget extends StatefulWidget {
  /// Default size of the capture button when not specified.
  static const double defaultSize = 78.0;

  /// Outer width of the button's border.
  final double outerWidth;

  /// Color of the button.
  final Color color;
  final Color borderColor;

  /// Size of the button, uses [defaultSize] if not specified.
  final double? size;

  final VoidCallback? onTap;

  final bool isEnabled;

  final Duration debounceDuration;

  /// Constructor for creating a [CaptureButtonWidget].
  const CaptureButtonWidget({
    super.key,
    this.size,
    this.borderColor = AppColors.white,
    this.color = AppColors.white,
    this.outerWidth = 4.0,
    this.onTap,
    this.isEnabled = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<CaptureButtonWidget> createState() => _CaptureButtonWidgetState();
}

class _CaptureButtonWidgetState extends State<CaptureButtonWidget> {
  bool _isEnable = false;

  double _scale = 1.0;
  late Color _borderColor;
  late Color _buttonColor;

  @override
  void initState() {
    _borderColor = widget.borderColor;
    _buttonColor = widget.color;
    _isEnable = widget.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the size of the button.
    final buttonSize = widget.size ?? CaptureButtonWidget.defaultSize;

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapCancel,
      onTap: widget.isEnabled ? _onTap : null,
      child: AnimatedOpacity(
        opacity: _isEnable ? 1 : 0.4,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderColor,
              width: widget.outerWidth,
            ),
            shape: BoxShape.circle,
          ),
          // padding: const EdgeInsets.all(4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: _scale == 1 ? AppPadding.pa4 : null,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _buttonColor, // Animate the color change
            ),
          ),
        ),
      ),
    );
  }

  void _startAnimation() {
    setState(() {
      _scale = 1.1; // Shrink the button when tapped
      _buttonColor = context.theme.primaryColor; // Change color on tap
    });
  }

  void _resetAnimation() {
    setState(() {
      _scale = 1.0; // Reset size if tap is canceled
      _buttonColor =
          context.colorScheme.surface; // Reset color if tap is canceled
    });
  }

  void _onTapDown() {
    _startAnimation();
  }

  void _onTapUp() {
    _resetAnimation();
  }

  void _onTapCancel() {
    _resetAnimation();
  }

  void _onTap() {
    widget.onTap?.call();
    _startAnimation();
    // After a short delay, return to normal
    Future.delayed(const Duration(milliseconds: 100), () {
      _resetAnimation();
    });
  }
}
