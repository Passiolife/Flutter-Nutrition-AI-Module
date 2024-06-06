import 'package:flutter/material.dart';

import '../constant/app_button_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.buttonText,
    required this.appButtonModel,
    this.onTap,
    super.key,
  });

  final AppButtonModel appButtonModel;
  final String? buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: appButtonModel.decoration,
        padding: appButtonModel.padding,
        child: Center(
          child: Text(
            buttonText ?? '',
            style: appButtonModel.textStyle,
          ),
        ),
      ),
    );
  }
}
