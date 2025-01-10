import 'dart:async';

import 'package:flutter/material.dart';

import '../../constant/app_button_styles.dart';
import '../app_loading_button_widget.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    required this.text,
    required this.appButtonModel,
    this.prefix,
    this.onTap,
    this.enable = true,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.loading = false,
    this.loadingWidget,
    super.key,
  });

  final String text;
  final AppButtonModel appButtonModel;
  final Widget? prefix;
  final bool enable;

  final bool loading;
  final Widget? loadingWidget;

  final VoidCallback? onTap;

  final Duration debounceDuration;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
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
      onTap: widget.enable ? _handleTap : null,
      child: AnimatedOpacity(
        opacity: widget.enable ? 1.0 : 0.5,
        duration: Duration(milliseconds: 250),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: widget.appButtonModel.decoration,
          padding: widget.appButtonModel.padding,
          child: Center(
            child: !widget.loading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.prefix ?? const SizedBox.shrink(),
                      Text(
                        widget.text,
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
