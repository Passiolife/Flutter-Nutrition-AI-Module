import 'package:flutter/material.dart';

import '../../constant/app_button_styles.dart';
import '../../constant/app_padding.dart';
import '../app_button.dart';
import '../app_loading_button_widget.dart';
import 'base_button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.text,
    this.padding,
    this.onTap,
    this.enabled = true,
    this.loading = false,
    super.key,
  });

  final String? text;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool enabled;
  final bool loading;

  EdgeInsets get _defaultPadding => AppPadding.ph40 + AppPadding.pv12;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: text ?? '',
      appButtonModel:
          AppButtonStyles.primary.copyWith(padding: padding ?? _defaultPadding),
      onTap: onTap,
      enable: enabled,
      loading: loading,
      loadingWidget: AppLoadingButtonWidget.secondary(),
    );
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: enabled ? 1 : 0.4,
      child: AppButton(
        buttonText: text,
        appButtonModel: AppButtonStyles.primary
            .copyWith(padding: padding ?? _defaultPadding),
        onTap: enabled ? onTap : null,
        isEnable: enabled,
        isLoading: loading,
      ),
    );
  }
}
