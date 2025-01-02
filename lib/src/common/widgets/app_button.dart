import 'dart:async';

import 'package:flutter/material.dart';
import 'app_loading_button_widget.dart';

import '../constant/app_button_styles.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.buttonText,
    required this.appButtonModel,
    this.prefix,
    this.onTap,
    this.isLoading = false,
    this.loadingWidget,
    this.isEnable = true,
    this.debounceDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final AppButtonModel appButtonModel;
  final String? buttonText;
  final Widget? prefix;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool isEnable;
  final Duration debounceDuration;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isProcessing = false;

  Timer? _debounceTimer;

  void _handleTap() {
    if (_isProcessing) return;

    _isProcessing = true;
    widget.onTap?.call();

    _debounceTimer = Timer(widget.debounceDuration, () {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnable ? _handleTap : null,
      child: AnimatedOpacity(
        opacity: widget.isEnable ? 1.0 : 0.5,
        duration: Duration(milliseconds: 250),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: widget.appButtonModel.decoration?.copyWith(
            color: widget.appButtonModel.decoration?.color,
          ),
          padding: widget.appButtonModel.padding,
          child: Center(
            child: !widget.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.prefix ?? const SizedBox.shrink(),
                      Text(
                        widget.buttonText ?? '',
                        style: widget.appButtonModel.textStyle,
                      ),
                    ],
                  )
                : widget.loadingWidget ?? AppLoadingButtonWidget.primary(),
          ),
        ),
      ),
    );
  }
}
