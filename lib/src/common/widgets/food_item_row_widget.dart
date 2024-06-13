import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_constants.dart';
import '../util/string_extensions.dart';
import 'passio_image_widget.dart';
import 'shimmer_widget.dart';

class FoodItemRowWidget extends StatelessWidget {
  const FoodItemRowWidget({
    super.key,
    this.index,
    this.iconId,
    this.title,
    this.subtitle,
    this.onTap,
    this.onTapAdd,
    this.isLoading = false,
    this.isAddVisible = true,
    this.suffix,
    this.padding,
  });

  final int? index;
  final String? iconId;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;
  final bool isLoading;
  final bool isAddVisible;
  final Widget? suffix;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SkeletonWidget();
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.blue50,
          highlightColor: AppColors.blue50,
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                PassioImageWidget(
                  key: ValueKey(iconId),
                  iconId: iconId ?? '',
                  radius: 20.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title?.toTitleCase ?? '',
                        style: AppTextStyle.textSm.addAll([
                          AppTextStyle.textSm.leading5,
                          AppTextStyle.semiBold
                        ]).copyWith(color: AppColors.gray900),
                      ),
                      subtitle?.isNotEmpty ?? false
                          ? Text(
                              subtitle ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.textSm
                                  .copyWith(color: AppColors.gray500),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Visibility(
                  visible: isAddVisible,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppImages.icPlusSolid,
                      width: 24.r,
                      height: 24.r,
                      colorFilter: const ColorFilter.mode(
                          AppColors.gray400, BlendMode.srcIn),
                    ),
                    onPressed: onTapAdd,
                  ),
                ),
                suffix ?? const SizedBox.shrink()
              ],
            ),
          ),
        ),
      );
    }
  }
}

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            ShimmerWidget.circular(
              height: 40.r,
              width: 40.r,
              baseColor: AppColors.gray300,
              highlightColor: AppColors.gray200,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    width: 184.w,
                    height: 14.h,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                  SizedBox(height: 4.h),
                  ShimmerWidget.rectangular(
                    width: 79.w,
                    height: 14.h,
                    baseColor: AppColors.gray300,
                    highlightColor: AppColors.gray200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
