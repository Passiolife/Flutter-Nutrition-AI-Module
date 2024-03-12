import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/keyboard_extension.dart';

class FoodSearchAppBarWidget extends StatelessWidget {
  const FoodSearchAppBarWidget({required this.searchController, super.key});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundBlueGray,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimens.h8,
          top: AppDimens.h57,
          bottom: AppDimens.h12,
        ),
        child: Row(
          children: [
            _SearchWidget(controller: searchController),
            _CancelWidget(
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({required this.controller});

  final TextEditingController controller;

  IconThemeData _clearIconTheme(BuildContext context) => IconThemeData(
        color: CupertinoDynamicColor.resolve(AppColors.gray700, context),
        size: MediaQuery.textScalerOf(context).scale(AppDimens.font18),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoTextField(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r10),
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        textInputAction: TextInputAction.search,
        prefix: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.w16,
            AppDimens.h2,
            AppDimens.w4,
            AppDimens.h2,
          ),
          child: SvgPicture.asset(
            AppImages.icSearch,
            width: AppDimens.r24,
            height: AppDimens.r24,
            fit: BoxFit.contain,
          ),
        ),
        suffix: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
          child: CupertinoButton(
            onPressed: () => controller.clear(),
            minSize: 0,
            padding: EdgeInsets.zero,
            child: IconTheme(
              data: _clearIconTheme(context),
              child: const Icon(CupertinoIcons.xmark_circle_fill),
            ),
          ),
        ),
        suffixMode: OverlayVisibilityMode.editing,
        onTapOutside: (_) {
          context.hideKeyboard();
        },
      ),
    );
  }
}

class _CancelWidget extends StatelessWidget {
  const _CancelWidget({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w8,
          vertical: AppDimens.h8,
        ),
        child: Text(
          context.localization?.cancel ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.medium]).copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}
