import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_text_styles.dart';

class MenuItemRow extends StatelessWidget {
  const MenuItemRow({
    super.key,
    this.imagePath,
    this.text,
  });

  final String? imagePath;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184.w,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 12.w),
          SvgPicture.asset(
            imagePath ?? '',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 8.w),
          Text(
            text ?? '',
            style: AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6, AppTextStyle.medium]),
          ),
        ],
      ),
    );
  }
}
