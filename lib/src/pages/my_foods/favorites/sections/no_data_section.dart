import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/context_extension.dart';

class NoDataSection extends StatelessWidget {
  const NoDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.localization?.noFavoriteTitle ?? '',
          style: AppTextStyle.textLg.addAll([AppTextStyle.bold]),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          context.localization?.noFavoriteDescription ?? '',
          style: AppTextStyle.textBase,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
