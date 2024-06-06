import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import 'notch_fab_item_widget.dart';

typedef OnTapQuickAction = Function(String? action);

class NotchFABWidget extends StatelessWidget {
  const NotchFABWidget({this.onTapQuickAction, super.key});

  final OnTapQuickAction? onTapQuickAction;

  // List of floating action buttons with expanded widgets
  List<FloatingButtonExpandedWidget> _fabExpandedWidget(BuildContext context) =>
      [
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icFavoriteFilled,
          text: context.localization?.favourites,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icSearch,
          text: context.localization?.textSearch,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icScan,
          text: context.localization?.foodScanner,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 32.h,
      overlayColor: AppColors.black75Opacity,
      dialRoot: (context, isOpen, toggleChildren) {
        return SizedBox(
          width: AppDimens.r52,
          height: AppDimens.r52,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: AppColors.indigo600Main,
              foregroundColor: AppColors.white,
              shape: const CircleBorder(),
              onPressed: toggleChildren,
              child: SvgPicture.asset(
                isOpen ? AppImages.icCloseSolid : AppImages.icPlusSolid,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
                width: AppDimens.r20,
                height: AppDimens.r20,
              ),
            ),
          ),
        );
      },
      childrenButtonSize: Size(AppDimens.w200, AppDimens.h78),
      children: _fabExpandedWidget(context)
          .map(
            (e) => SpeedDialChild(
              backgroundColor: AppColors.transparent,
              child: e,
              onTap: () => onTapQuickAction?.call(e.text),
            ),
          )
          .toList(),
    );
  }
}
