import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';

abstract interface class MeasurementAppBarListener {
  void onTapAdd();
}

class MeasurementAppBar extends StatelessWidget {
  const MeasurementAppBar({
    this.title,
    this.listener,
    this.visibleAdd = true,
    super.key,
  });

  final String? title;
  final MeasurementAppBarListener? listener;
  final bool visibleAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBarWidget(
            title: title,
            isMenuVisible: false,
            suffix: Visibility(
              visible: visibleAdd,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: IconButton(
                icon: SvgPicture.asset(
                  AppImages.icPlusSolid,
                  colorFilter: const ColorFilter.mode(
                      AppColors.gray400, BlendMode.srcIn),
                  width: 24.r,
                  height: 24.r,
                ),
                onPressed: listener?.onTapAdd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
