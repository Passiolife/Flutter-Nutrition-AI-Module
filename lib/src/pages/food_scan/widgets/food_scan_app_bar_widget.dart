import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';

class FoodScanAppBarWidget extends StatelessWidget {
  const FoodScanAppBarWidget({this.onTapHelp, super.key});

  final VoidCallback? onTapHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarWidget(
            title: context.localization?.foodScanner,
            isMenuVisible: false,
            suffix: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapHelp,
              child: SvgPicture.asset(
                AppImages.icQuestionMarkCircle,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),
            ),
          ),
          SizedBox(height: AppDimens.h12),
        ],
      ),
    );
  }
}
