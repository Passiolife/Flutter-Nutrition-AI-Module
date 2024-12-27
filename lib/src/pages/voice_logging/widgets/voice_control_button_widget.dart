import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_button_styles.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/app_button.dart';

class VoiceControlButtonWidget extends StatelessWidget {
  const VoiceControlButtonWidget({this.isPlaying = false, this.onTap, super.key});

  final bool isPlaying;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      buttonText: isPlaying
          ? context.localization?.stopListening
          : context.localization?.startListening,
      prefix: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: SvgPicture.asset(
          isPlaying ? AppImages.icStop : AppImages.icMic,
          width: 20.r,
          height: 20.r,
        ),
      ),
      appButtonModel: AppButtonStyles.primary,
      onTap: onTap,
    );
  }
}
