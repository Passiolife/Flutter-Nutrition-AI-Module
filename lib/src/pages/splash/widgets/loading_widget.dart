import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Dimens.r36,
          height: Dimens.r36,
          child: Center(
            child: Transform.scale(
              scale: Platform.isIOS ? 1.5 : 1,
              child: const CircularProgressIndicator.adaptive(
                backgroundColor: AppColors.passioInset,
              ),
            ),
          ),
        ),
        Dimens.w8.horizontalSpace,
        Text(
          context.localization?.configuringSDK ?? '',
          style: AppStyles.style18.copyWith(
            color: AppColors.passioInset,
          ),
        ),
      ],
    );
  }
}
