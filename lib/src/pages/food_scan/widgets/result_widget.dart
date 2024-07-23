import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'bottom_background_widget.dart';
import 'interfaces.dart';
import 'typedefs.dart';

typedef OnResultSheetDrag = Function(bool isCollapsed);

class ResultWidget extends StatefulWidget {
  const ResultWidget({
    super.key,
    required this.iconId,
    required this.bottomBackgroundWidgetKey,
    this.foodName,
    this.foodSize,
    this.foodCalories,
    this.alternatives = const [],
    this.onFoodLog,
    this.listener,
    this.shouldDraggable = true,
    this.visibleDragIntro = true,
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

  final GlobalKey<BottomBackgroundWidgetState> bottomBackgroundWidgetKey;

  @override
  State<ResultWidget> createState() => ResultWidgetState();
}

class ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SingleChildScrollView(
            controller:
                widget.bottomBackgroundWidgetKey.currentState?.scrollController,
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
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Row(
                    children: [
                      PassioImageWidget(
                        iconId: widget.iconId,
                        radius: 20.r,
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Text(
                          widget.foodName?.toUpperCaseWord ?? '',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading6,
                            AppTextStyle.bold
                          ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: widget
                .bottomBackgroundWidgetKey.currentState!.currentHeightInPixels,
            builder: (context, value, child) {
              return value > 0
                  ? SizedBox(
                      height: widget.bottomBackgroundWidgetKey.currentState!
                          .currentHeightInPixels.value,
                      child: child ?? const SizedBox.shrink(),
                    )
                  : const SizedBox.shrink();
            },
            child: ListView.separated(
              controller: widget
                  .bottomBackgroundWidgetKey.currentState!.scrollController!,
              padding: EdgeInsets.only(
                top: 24.h,
                left: 4.w,
                right: 4.w,
              ),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.alternatives.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    widget.listener?.onEdit(index);
                  },
                  child: _AlternativeRow(
                    candidate: widget.alternatives.elementAt(index),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8.h);
              },
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

class _AlternativeRow extends StatelessWidget {
  const _AlternativeRow({required this.candidate});

  final DetectedCandidate candidate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(4.r),
      ),
      padding: EdgeInsets.all(8.r),
      height: 56.h,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: PassioImageWidget(iconId: candidate.passioID),
        title: Text(
          candidate.foodName.toUpperCaseWord,
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading5,
            AppTextStyle.semiBold
          ]).copyWith(color: AppColors.gray900),
        ),
      ),
    );
  }
}
