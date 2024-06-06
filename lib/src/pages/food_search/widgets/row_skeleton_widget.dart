import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/shimmer_widget.dart';

class RowSkeletonWidget extends StatelessWidget {
  const RowSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.customShadow,
      child: Padding(
        padding: EdgeInsets.all(AppDimens.r8),
        child: Row(
          children: [
            ShimmerWidget.circular(
              height: AppDimens.r40,
              width: AppDimens.r40,
              baseColor: AppColors.gray300,
              highlightColor: AppColors.gray200,
            ),
            SizedBox(width: AppDimens.w8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    width: AppDimens.w184,
                    height: AppDimens.h14,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                  SizedBox(height: AppDimens.h4),
                  ShimmerWidget.rectangular(
                    width: AppDimens.w79,
                    height: AppDimens.h14,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
