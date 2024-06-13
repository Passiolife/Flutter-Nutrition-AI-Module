import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/adaptive_loader.dart';

class GeneratingResultsWidget extends StatelessWidget {
  const GeneratingResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AdaptiveLoader(color: AppColors.indigo600Main,),
        8.verticalSpace,
        Text(
          context.localization?.generatingResults ?? '',
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]).copyWith(color: AppColors.gray900),
        ),
      ],
    );
  }
}
