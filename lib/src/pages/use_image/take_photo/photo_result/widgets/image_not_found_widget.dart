import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/core_extension.dart';
import '../../../../../common/widgets/icons/icon_search_widget.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({this.image, this.onTap, super.key,});

  final Uint8List? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppShadows.base.copyWith(color: AppColors.rose50),
        padding: AppPadding.ph8 + AppPadding.pv16,
        margin: AppPadding.ph16,
        child: Row(
          children: [
            PassioImageWidget(
              image: image,
              iconId: '',
              radius: 20.r,
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localization.imageNotRecognized,
                    style: AppTextStyle.textSm.addAll(
                        [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
                  ),
                  Text(
                    context.localization.imageNotRecognizedDescription,
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: context.textThemeColors.brandTextLight),
                  ),
                ],
              ),
            ),
            IconSearchWidget(onTap: onTap),
          ],
        ),
      ),
    );
  }
}
