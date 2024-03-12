import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_dimens.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/app_text_styles.dart';
import '../../common/util/context_extension.dart';
import '../constant/app_shadow.dart';

typedef MenuCallback = Function(OverlayPortalController menuController);

// Define a custom callback type for menu item tap
typedef OnMenuItemTap = Function(String? item);

// Custom AppBar widget
class CustomAppBarWidget extends StatefulWidget {
  const CustomAppBarWidget({
    this.onTapBack,
    this.title,
    this.titleStyle,
    this.isMenuVisible = true,
    this.suffix,
    super.key,
  });

  // Callback for back button tap
  final VoidCallback? onTapBack;

  // Title of the app bar
  final String? title;

  final TextStyle? titleStyle;

  // Boolean to determine menu visibility
  final bool isMenuVisible;

  final Widget? suffix;

  @override
  State<CustomAppBarWidget> createState() => CustomAppBarWidgetState();
}

class CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  final GlobalKey _menuKey = GlobalKey();

  // controller for managing overlay portal
  final OverlayPortalController _menuController = OverlayPortalController();

  // Callback setter for menu item tap
  OnMenuItemTap? _onMenuItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              (widget.onTapBack != null)
                  ? widget.onTapBack?.call()
                  : Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
              child: SvgPicture.asset(
                AppImages.icChevronLeft,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
              child: Center(
                child: Text(
                  widget.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.titleStyle ??
                      AppTextStyle.text2xl.addAll([
                        AppTextStyle.text2xl.leading8,
                        AppTextStyle.extraBold
                      ]).copyWith(color: AppColors.gray900),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isMenuVisible,
            maintainSize: widget.suffix != null ? false : true,
            maintainAnimation: widget.suffix != null ? false : true,
            maintainState: widget.suffix != null ? false : true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _menuController.toggle();
              },
              child: OverlayPortal(
                controller: _menuController,
                overlayChildBuilder: (BuildContext context) {
                  final position =
                      (_menuKey.currentContext?.findRenderObject() as RenderBox)
                          .localToGlobal(Offset.zero);

                  return _MenuWidget(
                    position: position,
                    onMenuItemTap: (item) {
                      _onMenuItemTap?.call(item);
                      _menuController.hide();
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
                  child: SvgPicture.asset(
                    key: _menuKey,
                    AppImages.icMenu,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                  ),
                ),
              ),
            ),
          ),
          widget.suffix ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  // Method to hide the menu
  void hideMenu() {
    if (_menuController.isShowing) {
      _menuController.hide();
    }
  }

  void setMenuCallback(OnMenuItemTap? onMenuItemTap) {
    _onMenuItemTap = onMenuItemTap;
  }
}

class _MenuWidget extends StatelessWidget {
  const _MenuWidget({required this.position, this.onMenuItemTap});

  final Offset position;
  final OnMenuItemTap? onMenuItemTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: context.width - (position.dx + AppDimens.r24),
      top: position.dy + AppDimens.r24 + AppDimens.h4,
      child: Container(
        decoration: AppShadows.lg
          ..addAll([AppShadows.ring1BlackOpacity5], atIndex: 0),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.r8),
          child: Column(
            children: [
              _MenuItemRow(
                imagePath: AppImages.icChartPie,
                text: context.localization?.progress,
                onMenuItemTap: onMenuItemTap,
              ),
              SizedBox(height: AppDimens.h4),
              _MenuItemRow(
                imagePath: AppImages.icProfile,
                text: context.localization?.myProfile,
                onMenuItemTap: onMenuItemTap,
              ),
              SizedBox(height: AppDimens.h4),
              _MenuItemRow(
                imagePath: AppImages.icTutorials,
                text: context.localization?.tutorials,
                onMenuItemTap: onMenuItemTap,
              ),
              SizedBox(height: AppDimens.h4),
              _MenuItemRow(
                imagePath: AppImages.icSettings,
                text: context.localization?.settings,
                onMenuItemTap: onMenuItemTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    required this.imagePath,
    this.text,
    this.onMenuItemTap,
  });

  final String imagePath;
  final String? text;
  final OnMenuItemTap? onMenuItemTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      child: InkWell(
        onTap: () => onMenuItemTap?.call(text),
        splashColor: AppColors.blue50,
        highlightColor: AppColors.blue50,
        child: SizedBox(
          width: AppDimens.w184,
          height: AppDimens.h56,
          child: Row(
            children: [
              SizedBox(width: AppDimens.w12),
              SvgPicture.asset(
                imagePath,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),
              SizedBox(width: AppDimens.w8),
              Text(
                text ?? '',
                style: AppTextStyle.textBase.addAll(
                    [AppTextStyle.textBase.leading6, AppTextStyle.medium]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
