import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import 'notch_fab_item_widget.dart';

typedef OnTapQuickAction = Function(String? action);

class NotchFABWidget extends StatefulWidget {
  const NotchFABWidget({this.onTapQuickAction, super.key});

  final OnTapQuickAction? onTapQuickAction;

  @override
  State<NotchFABWidget> createState() => _NotchFABWidgetState();
}

class _NotchFABWidgetState extends State<NotchFABWidget> {
  // List of floating action buttons with expanded widgets
  List<FloatingButtonExpandedWidget> _fabExpandedWidget(BuildContext context) =>
      [
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icScan,
          text: context.localization?.foodScanner,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icSearch,
          text: context.localization?.textSearch,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icMic,
          colorFilter: const ColorFilter.mode(
            AppColors.indigo600Main,
            BlendMode.srcIn,
          ),
          text: context.localization?.voiceLogging,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icPhotograph,
          text: context.localization?.useImage,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icAIChat,
          text: context.localization?.aiAdvisor,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icFavoriteFilled,
          text: context.localization?.favourites,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icMyFoods,
          text: context.localization?.myFoods,
        ),
      ];

  List<FloatingButtonExpandedWidget> _useImageExpandedWidget(
          BuildContext context) =>
      [
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icViewGrid,
          text: context.localization?.selectPhotos,
        ),
        FloatingButtonExpandedWidget(
          imagePath: AppImages.icCamera,
          text: context.localization?.takePhotos,
        ),
      ];

  bool _showImageMenu = false;
  final ValueNotifier<bool> _isDialOpen = ValueNotifier(false);
  final ValueNotifier<bool> _isUseImageDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 32.h,
      overlayColor: AppColors.black75Opacity,
      openCloseDial: _showImageMenu ? _isUseImageDialOpen : _isDialOpen,
      closeManually: true,
      onClose: () {
        if (_isUseImageDialOpen.value) {
          _isUseImageDialOpen.value = false;
        }
      },
      dialRoot: (context, isOpen, toggleChildren) {
        return SizedBox(
          width: 52.r,
          height: 52.r,
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
                width: 20.r,
                height: 20.r,
              ),
            ),
          ),
        );
      },
      childrenButtonSize: Size(200.w, 78.h),
      children: _showImageMenu
          ? _useImageExpandedWidget(context)
              .map(
                (e) => SpeedDialChild(
                  backgroundColor: AppColors.transparent,
                  child: e,
                  onTap: () {
                    widget.onTapQuickAction?.call(e.text);
                    _isUseImageDialOpen.value = false;
                  },
                ),
              )
              .toList()
          : _fabExpandedWidget(context)
              .map(
                (e) => SpeedDialChild(
                  backgroundColor: AppColors.transparent,
                  child: e,
                  onTap: () {
                    _isDialOpen.value = false;

                    if (e.text == context.localization?.useImage) {
                      setState(() {
                        _showImageMenu = true;
                      });

                      Future.delayed(const Duration(milliseconds: 300), () {
                        _isUseImageDialOpen.value = true;

                        setState(() {
                          _showImageMenu = false;
                        });
                      });
                      return;
                    }
                    widget.onTapQuickAction?.call(e.text);
                  },
                ),
              )
              .toList(),
    );
  }
}
