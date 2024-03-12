import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';

class EditFoodAppBarWidget extends StatelessWidget {
  const EditFoodAppBarWidget({
    this.visibleDelete = false,
    this.visibleSwitch = false,
    this.onTap,
    super.key,
  });

  final bool visibleDelete;
  final bool visibleSwitch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimens.h48),
          CustomAppBarWidget(
            title: context.localization?.edit,
            isMenuVisible: false,
            suffix: (visibleDelete || visibleSwitch)
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: SvgPicture.asset(
                      (visibleDelete)
                          ? AppImages.icTrash
                          : AppImages.icSwitchHorizontal,
                      width: AppDimens.r24,
                      height: AppDimens.r24,
                    ),
                  )
                : SizedBox(
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                  ),
          ),
          SizedBox(height: AppDimens.h12),
        ],
      ),
    );
  }
}
