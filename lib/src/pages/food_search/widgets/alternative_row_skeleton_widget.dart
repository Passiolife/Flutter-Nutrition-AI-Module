import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/shimmer_widget.dart';

class AlternativeRowSkeletonWidget extends StatelessWidget {
  const AlternativeRowSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.rectangular(
      height: AppDimens.h52,
      width: AppDimens.w120,
      baseColor: AppColors.gray300,
      highlightColor: AppColors.gray200,
    );
  }
}
