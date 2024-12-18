import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/draggable_bottom_sheet_widget.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import 'interfaces.dart';
import 'typedefs.dart';

typedef OnResultSheetDrag = Function(bool isCollapsed);

class ResultWidget extends StatefulWidget {
  const ResultWidget({
    super.key,
    required this.iconId,
    this.scrollController,
    this.dragController,
    this.foodName,
    this.foodSize,
    this.foodCalories,
    this.alternatives = const [],
    this.onFoodLog,
    this.listener,
    this.shouldDraggable = true,
    this.visibleDragIntro = true,
    this.widgetState,
  });

  final String iconId;
  final String? foodName;
  final String? foodSize;
  final String? foodCalories;
  final OnFoodLog? onFoodLog;
  final List<DetectedCandidate> alternatives;

  final bool shouldDraggable;
  final bool visibleDragIntro;
  final FoodScanListener? listener;

  final ScrollController? scrollController;
  final DraggableScrollableController? dragController;
  final DraggableBottomSheetWidgetState? widgetState;

  @override
  State<ResultWidget> createState() => ResultWidgetState();
}

class ResultWidgetState extends State<ResultWidget> {
  final ValueNotifier<double> _heightNotifier = ValueNotifier(0);

  double get _alternativeSize =>
      32.h + 16.h + 16.h + 8.h + (widget.alternatives.length * 56.h);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.dragController?.addListener(() {
        _heightNotifier.value = (widget.widgetState?.getDraggedPixels() ?? 0) -
            (widget.widgetState?.getInitialSizePixels() ?? 0);
        widget.listener?.onDragResult(_heightNotifier.value == 0);
      });
      widget.widgetState?.setMaxSizeInPixels(
          (widget.widgetState?.getInitialSizePixels() ?? 0) + _alternativeSize);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            controller: widget.scrollController,
            // widget.bottomBackgroundWidgetKey.currentState?.scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                8.verticalSpace,
                widget.shouldDraggable
                    ? Container(
                        width: 48.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.shouldDraggable && widget.visibleDragIntro
                    ? Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Text(
                          context.localization?.scanResultsIntro ?? '',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textSm
                              .copyWith(color: AppColors.gray900),
                        ),
                      )
                    : const SizedBox.shrink(),
                16.verticalSpace,
                FoodItemRowWidget(
                  key: ValueKey(widget.iconId),
                  data: FoodItemRowData(
                    iconId: widget.iconId,
                    title: widget.foodName?.toUpperCaseWord ?? '',
                    padding: EdgeInsets.all(8.r),
                    enableSlidable: false,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: _heightNotifier,
            builder: (context, value, child) {
              if (value > 0) {
                return SizedBox(
                  height: value,
                  child: child ?? const SizedBox.shrink(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
            child: SingleChildScrollView(
              controller: widget.scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Text(
                    context.localization?.alternatives ?? '',
                    style: AppTextStyle.textBase.addAll([
                      AppTextStyle.textBase.leading6,
                      AppTextStyle.semiBold,
                    ]).copyWith(color: AppColors.gray900),
                  ),
                  8.verticalSpace,
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.alternatives.length,
                    padding: EdgeInsets.only(top: 24.h),
                    itemBuilder: (BuildContext context, int index) {
                      final data = widget.alternatives.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          widget.listener?.onEdit(index);
                        },
                        child: FoodItemRowWidget(
                          data: FoodItemRowData(
                            decoration:
                                const BoxDecoration(color: AppColors.indigo50),
                            iconId: data.passioID,
                            title: data.foodName.toUpperCaseWord,
                            padding: EdgeInsets.all(8.r),
                            enableSlidable: false,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 8.h);
                    },
                  ),
                ],
              ),
            ),
          ),
          24.verticalSpace,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.listener?.onTapSearch();
            },
            child: RichText(
              text: TextSpan(
                text: '${context.localization?.notWhatYouAreLookingFor} ',
                style:
                    AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
                children: [
                  TextSpan(
                    text: context.localization?.searchManually,
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.bold
                    ]).copyWith(color: AppColors.blue600),
                  )
                ],
              ),
            ),
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonText: context.localization?.edit,
                  appButtonModel: AppButtonStyles.primaryBordered,
                  onTap: () => widget.listener?.onEdit(null),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  buttonText: context.localization?.log,
                  appButtonModel: AppButtonStyles.primary,
                  onTap: () => widget.listener?.onLog(),
                ),
              ),
            ],
          ),
          context.bottomPadding.verticalSpace,
        ],
      ),
    );
  }
}
