import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_constants.dart';
import '../../extension/context_extension.dart';
import '../passio_image_widget.dart';

class FoodItemRow extends StatelessWidget {
  const FoodItemRow({
    required this.iconId,
    required this.title,
    required this.subtitle,
    this.index,
    super.key,
  });

  final String iconId;
  final String title;
  final String subtitle;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          iconId: iconId,
          heroTag: '$iconId $index',
          radius: 20.r,
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: '$title $index',
                child: Text(
                  title,
                  style: AppTextStyle.textSm.addAll(
                      [AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
                ),
              ),
              Hero(
                tag: '$subtitle $index',
                child: Text(
                  subtitle,
                  style: AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]).copyWith(
                          color: context.textThemeColors.brandTextLight),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
