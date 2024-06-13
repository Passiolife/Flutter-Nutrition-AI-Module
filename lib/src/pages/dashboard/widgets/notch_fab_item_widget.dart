import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/constant/app_text_styles.dart';

// This class represents a widget for a floating button with expanded content.
class FloatingButtonExpandedWidget extends StatelessWidget {
  // Constructor for the FloatingButtonExpandedWidget.
  const FloatingButtonExpandedWidget({
    required this.imagePath,
    this.text,
    this.colorFilter,
    super.key,
  });

  // Path to the image asset for the button icon.
  final String imagePath;
  // Text to display next to the button icon.
  final String? text;

  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container decoration for the button.
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray300),
        borderRadius: BorderRadius.circular(AppDimens.r100),
        boxShadow: AppShadows.sm.boxShadow,
      ),
      // Padding around the content of the button.
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w16,
        vertical: AppDimens.h13,
      ),
      child: Row(
        children: [
          // Widget to display the icon.
          SvgPicture.asset(
            imagePath,
            colorFilter: colorFilter,
            width: AppDimens.r24,
            height: AppDimens.r24,
          ),
          SizedBox(width: AppDimens.w8),
          // Widget to display the text.
          Text(
            text ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.medium
            ]).copyWith(color: AppColors.gray700),
          ),
        ],
      ),
    );
  }
}
