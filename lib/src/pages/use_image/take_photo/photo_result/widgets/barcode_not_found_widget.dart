import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/icons/icon_pencil_alt_widget.dart';
import '../../../../../common/widgets/passio_image_widget.dart';

class BarcodeNotFoundWidget extends StatelessWidget {
  const BarcodeNotFoundWidget({
    required this.iconId,
    this.image,
    this.onTap,
    super.key,
  });

  final Uint8List? image;
  final String iconId;
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
              iconId: iconId,
              radius: 20.r,
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localization.barcodeNotFound ?? '',
                    style: AppTextStyle.textSm.addAll(
                        [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
                  ),
                  Text(
                    context.localization.barcodeNotFoundDescription ?? '',
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: context.textThemeColors.brandTextLight),
                  ),
                ],
              ),
            ),
            IconPencilAltWidget(onTap: onTap),
          ],
        ),
      ),
    );
  }
}
