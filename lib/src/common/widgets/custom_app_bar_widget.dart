import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/util/context_extension.dart';
import '../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../pages/my_profile/my_profile_page.dart';
import '../../pages/settings/settings_page.dart';
import '../constant/app_constants.dart';
import 'app_pop_up_widget.dart';

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
    this.children = const [],
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

  final List<Widget> children;

  @override
  State<CustomAppBarWidget> createState() => CustomAppBarWidgetState();
}

class CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  List<MenuModel> get _menus => [
        MenuModel(
          icon: AppImages.icChartPie,
          title: context.localization?.progress,
        ),
        MenuModel(
          icon: AppImages.icProfile,
          title: context.localization?.myProfile,
        ),
        MenuModel(
          icon: AppImages.icTutorials,
          title: context.localization?.tutorials,
        ),
        MenuModel(
          icon: AppImages.icSettings,
          title: context.localization?.settings,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      padding: EdgeInsets.only(
        left: 8.w,
        right: 8.w,
        top: 48.h,
        bottom: 8.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  (widget.onTapBack != null)
                      ? widget.onTapBack?.call()
                      : Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null;
                },
                icon: SvgPicture.asset(
                  AppImages.icChevronLeft,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
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
                child: AppPopupWidget<MenuModel>(
                  items: _menus,
                  itemBuilder: (item) {
                    return _MenuItemRow(
                      imagePath: item.icon,
                      text: item.title,
                    );
                  },
                  constraints: BoxConstraints(minWidth: 200.w),
                  icon: SvgPicture.asset(
                    AppImages.icMenu,
                    width: 24.r,
                    height: 24.r,
                  ),
                  onSelected: (value) {
                    final bloc = BlocProvider.of<DashboardBloc>(context);
                    if (value.title == context.localization?.myProfile) {
                      MyProfilePage.navigate(context: context).then((value) {
                        bloc.add(const RefreshEvent());
                      });
                    } else if (value.title == context.localization?.settings) {
                      SettingsPage.navigate(context: context).then((value) {
                        bloc.add(const RefreshEvent());
                      });
                    }
                  },
                ),
              ),
              widget.suffix ?? const SizedBox.shrink(),
            ],
          ),
          ...widget.children,
          // widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    this.imagePath,
    this.text,
  });

  final String? imagePath;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184.w,
      height: 56.h,
      child: Row(
        children: [
          SizedBox(width: 12.w),
          SvgPicture.asset(
            imagePath ?? '',
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 8.w),
          Text(
            text ?? '',
            style: AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6, AppTextStyle.medium]),
          ),
        ],
      ),
    );
  }
}

class MenuModel {
  final String? icon;
  final String? title;

  const MenuModel({this.icon, this.title});
}
