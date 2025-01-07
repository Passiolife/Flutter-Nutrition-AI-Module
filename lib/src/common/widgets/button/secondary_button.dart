import 'package:flutter/material.dart';

import '../../constant/app_button_styles.dart';
import '../../constant/app_padding.dart';
import '../app_button.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    this.text,
    this.padding,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  final String? text;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool enabled;

  EdgeInsets get _defaultPadding => AppPadding.ph40 + AppPadding.pv12;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: enabled ? 1 : 0.4,
      child: AppButton(
        buttonText: text,
        appButtonModel: AppButtonStyles.primaryBordered
            .copyWith(padding: padding ?? _defaultPadding),
        onTap: enabled ? onTap : null,
        isEnable: enabled,
      ),
    );
  }
}
