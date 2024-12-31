import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../common/constant/app_constants.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: VectorGraphic(
        loader: AssetBytesLoader(AppImages.icQuestionMarkCircle),
        colorFilter: ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
        width: AppDimens.r24,
        height: AppDimens.r24,
      ),
    );
  }
}
