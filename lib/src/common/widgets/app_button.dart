import 'package:flutter/material.dart';

import '../constant/app_button_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.buttonText,
    required this.appButtonModel,
    this.prefix,
    this.onTap,
    super.key,
  });

  final AppButtonModel appButtonModel;
  final String? buttonText;
  final Widget? prefix;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: appButtonModel.decoration,
        padding: appButtonModel.padding,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefix ?? const SizedBox.shrink(),
              Text(
                buttonText ?? '',
                style: appButtonModel.textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
