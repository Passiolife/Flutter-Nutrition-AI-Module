import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_constants.dart';
import '../models/food_record/food_record.dart';
import '../extension/context_extension.dart';
import '../util/debouncer.dart';
import '../extension/string_extensions.dart';
import 'passio_image_widget.dart';
import 'selection_indicator_widget.dart';
import 'shimmer_widget.dart';

class FoodItemRowData {
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
  final Color? rippleColor;
  final Decoration? decoration;
  final bool enableSlidable;
  final ActionPane? endActionPane;
  final Function(bool forced)? onTapDelete;
  final VoidCallback? onTapEdit;
  final EdgeInsets? outerPadding;
  final bool isRecipe;

  // Selection-related properties
  final bool _withSelection;
  final bool isSelected;
  final VoidCallback? onSelect;

  // Food Record
  final FoodRecord? foodRecord;

  const FoodItemRowData({
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
    this.rippleColor,
    this.decoration,
    this.enableSlidable = true,
    this.endActionPane,
    this.onTapDelete,
    this.onTapEdit,
    this.outerPadding,
    bool withSelection = false,
    this.isRecipe = false,
    this.isSelected = false,
    this.onSelect,
    this.foodRecord,
  }) : _withSelection = withSelection;

  // Helper method to handle the selection logic
  bool get hasSelection => _withSelection && onSelect != null;
}

class FoodItemRowWidget extends StatefulWidget {
  const FoodItemRowWidget({
    super.key,
    required this.data,
  });

  // The model object that encapsulates all the properties
  final FoodItemRowData data;

  @override
  State<FoodItemRowWidget> createState() => _FoodItemRowWidgetState();
}

class _FoodItemRowWidgetState extends State<FoodItemRowWidget> {
  final _deBouncer = DeBouncer(milliseconds: 500);

  @override
  void dispose() {
    _deBouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isLoading) {
      return const SkeletonWidget();
    } else {
      return Padding(
        padding: widget.data.outerPadding ?? EdgeInsets.zero,
        child: Slidable(
          enabled: widget.data.enableSlidable,
          key: UniqueKey(),
          // The end action pane is the one at the right or the bottom side.
          endActionPane: widget.data.endActionPane ??
              ActionPane(
                extentRatio: 0.6,
                motion: const DrawerMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () => widget.data.onTapDelete?.call(true),
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) => widget.data.onTapEdit?.call(),
                    backgroundColor: AppColors.indigo600Main,
                    foregroundColor: Colors.white,
                    label: context.localization?.edit ?? '',
                  ),
                  SlidableAction(
                    onPressed: (context) =>
                        widget.data.onTapDelete?.call(false),
                    backgroundColor: AppColors.red500,
                    foregroundColor: Colors.white,
                    label: context.localization?.delete ?? '',
                  ),
                ],
              ),
          child: Material(
            color: widget.data.rippleColor ?? Colors.transparent,
            child: Container(
              decoration: widget.data.decoration ?? AppShadows.base,
              child: InkWell(
                splashColor: AppColors.blue50,
                highlightColor: AppColors.blue50,
                onTap: widget.data.onTap,
                child: Padding(
                  padding: widget.data.padding ??
                      EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          PassioImageWidget(
                            key: ValueKey(widget.data.iconId),
                            iconId: widget.data.iconId ?? '',
                            radius: 20.r,
                            foodRecord: widget.data.foodRecord,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Visibility(
                              visible: widget.data.isRecipe,
                              child: Image.asset(
                                AppImages.icRecipe,
                                width: 16.r,
                                height: 16.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.title?.toTitleCase ?? '',
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                                AppTextStyle.semiBold
                              ]).copyWith(color: AppColors.gray900),
                            ),
                            widget.data.subtitle?.isNotEmpty ?? false
                                ? Text(
                                    widget.data.subtitle ?? '',
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
                        visible: widget.data.isAddVisible,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AppImages.icPlusSolid,
                            width: 24.r,
                            height: 24.r,
                            colorFilter: const ColorFilter.mode(
                                AppColors.gray400, BlendMode.srcIn),
                          ),
                          onPressed: _onTapAdd,
                        ),
                      ),
                      widget.data.suffix ??
                          (widget.data.hasSelection
                              ? IconButton(
                                  onPressed: widget.data.onSelect,
                                  icon: SelectionIndicator(
                                      isSelected: widget.data.isSelected),
                                )
                              : const SizedBox.shrink())
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _onTapAdd() {
    _deBouncer.run(() {
      widget.data.onTapAdd?.call();
    });
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
