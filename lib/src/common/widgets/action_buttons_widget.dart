import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';
import 'app_button.dart';
import 'app_loading_button_widget.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    // Negative
    this.negativeButtonText,
    this.onNegativeButtonTap,
    this.isNegativeButtonLoading = false,
    this.negativeButtonStyle,
    this.isNegativeButtonEnabled = true,
    // Positive
    this.positiveButtonText,
    this.onPositiveButtonTap,
    this.isPositiveButtonLoading = false,
    this.positiveButtonStyle,
    this.isPositiveButtonEnabled = true,
    // Neutral
    this.neutralButtonText,
    this.onNeutralButtonTap,
    this.isNeutralButtonLoading = false,
    this.neutralButtonStyle,
    this.isNeutralButtonEnabled = true,
    super.key,
  });

  // Negative button.
  final String? negativeButtonText;
  final VoidCallback? onNegativeButtonTap;
  final bool isNegativeButtonLoading;
  final AppButtonModel? negativeButtonStyle;
  final bool isNegativeButtonEnabled;

  // Positive button properties.
  final String? positiveButtonText;
  final VoidCallback? onPositiveButtonTap;
  final bool isPositiveButtonLoading;
  final AppButtonModel? positiveButtonStyle;
  final bool isPositiveButtonEnabled;

  // Neutral button.
  final String? neutralButtonText;
  final VoidCallback? onNeutralButtonTap;
  final bool isNeutralButtonLoading;
  final AppButtonModel? neutralButtonStyle;
  final bool isNeutralButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (negativeButtonText != null || onNegativeButtonTap != null)
              Flexible(
                child: ActionButtonWidget(
                  text:
                      negativeButtonText ?? context.localization?.cancel ?? '',
                  onTap: onNegativeButtonTap,
                  visibleLoading: isNegativeButtonLoading,
                  buttonStyle: negativeButtonStyle ??
                      AppButtonStyles.primaryBordered
                    ..decoration?.copyWith(
                        color: AppButtonStyles.primaryBordered.decoration?.color
                            ?.withOpacity(isNegativeButtonEnabled ? 1.0 : 0.4)),
                  loadingColor: AppColors.indigo600Main,
                  isEnabled: isNegativeButtonEnabled,
                ),
              ),
            if (negativeButtonText != null || onNegativeButtonTap != null)
              4.horizontalSpace,
            if (positiveButtonText != null || onPositiveButtonTap != null)
              Flexible(
                child: ActionButtonWidget(
                  text: positiveButtonText ?? context.localization?.save ?? '',
                  onTap: onPositiveButtonTap,
                  visibleLoading: isPositiveButtonLoading,
                  buttonStyle: positiveButtonStyle ?? AppButtonStyles.primary
                    ..decoration?.copyWith(
                        color: AppButtonStyles.primary.decoration?.color
                            ?.withOpacity(isPositiveButtonEnabled ? 1.0 : 0.4)),
                  loadingColor: AppColors.white,
                  isEnabled: isPositiveButtonEnabled,
                ),
              ),
          ],
        ),
        if (neutralButtonText != null || onNeutralButtonTap != null)
          16.verticalSpace,
        if (neutralButtonText != null || onNeutralButtonTap != null)
          Expanded(
            child: ActionButtonWidget(
              text: neutralButtonText ?? '',
              onTap: onNeutralButtonTap,
              visibleLoading: isNeutralButtonLoading,
              buttonStyle: neutralButtonStyle ?? AppButtonStyles.primary
                ..decoration?.copyWith(
                    color: AppButtonStyles.primary.decoration?.color
                        ?.withOpacity(isNeutralButtonEnabled ? 1.0 : 0.4)),
              loadingColor: AppColors.white,
              isEnabled: isNeutralButtonEnabled,
            ),
          ),
      ],
    );
  }
}

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    required this.text,
    this.visibleLoading = false,
    this.onTap,
    this.buttonStyle,
    this.isEnabled = true,
    required this.loadingColor,
    super.key,
  });

  final String text;
  final bool visibleLoading;
  final VoidCallback? onTap;
  final AppButtonModel? buttonStyle;
  final Color loadingColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isEnabled ? 1 : 0.4,
      child: AppButton(
        prefix:
            visibleLoading ? AppLoadingButtonWidget(color: loadingColor) : null,
        buttonText: visibleLoading ? '' : text,
        appButtonModel: buttonStyle!,
        onTap: visibleLoading || !isEnabled ? null : onTap,
      ),
    );
  }
}
