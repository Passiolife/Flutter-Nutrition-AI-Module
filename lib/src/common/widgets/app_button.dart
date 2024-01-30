import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/dimens.dart';
import '../constant/styles.dart';
import '../util/context_extension.dart';

class AppButton extends StatelessWidget {
  final String buttonName;
  final double? fontSize;
  final Color? color;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    this.color,
    this.fontSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r8)),
          backgroundColor: color ?? AppColors.buttonColor,
        ),
        onPressed: onTap,
        child: Text(
          buttonName,
          style: textStyle ?? AppStyles.style17.copyWith(
            fontSize: fontSize ?? Dimens.fontSize20,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
