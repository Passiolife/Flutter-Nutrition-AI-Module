import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import 'bottom_sheet_list_row.dart';

typedef OnAnimationListRender = Function(GlobalKey<AnimatedListState> listKey);
typedef OnTapItem = Function(int index);
typedef OnTapClear = VoidCallback;
typedef OnTapClearItem = Function(int index, FoodRecord? data);
typedef OnTapAddAll = VoidCallback;
typedef OnTapNewRecipe = VoidCallback;

class ResultBottomSheet extends StatefulWidget {
  const ResultBottomSheet({
    required this.detectedList,
    this.onAnimationListRender,
    this.onTapItem,
    this.onTapClearItem,
    this.onTapClear,
    this.onTapAddAll,
    this.onTapNewRecipe,
    super.key,
  });

  /// [detectedList] contains list of [PassioIDAttributes] data.
  final List<FoodRecord?> detectedList;

  /// This callback will executes when widget will render and key will be assign to the AnimatedList.
  final OnAnimationListRender? onAnimationListRender;

  /// [onTapClear] will executes when tap on clear button.
  final OnTapClear? onTapClear;

  /// [onTapClearItem] will executes when tap on clear button on particular item.
  final OnTapClearItem? onTapClearItem;

  /// [onTapClear] will executes when tap on clear button.
  final OnTapAddAll? onTapAddAll;

  /// [onTapItem] will executes when tap on particular item.
  final OnTapItem? onTapItem;

  final OnTapNewRecipe? onTapNewRecipe;

  @override
  State<ResultBottomSheet> createState() => _ResultBottomSheetState();
}

class _ResultBottomSheetState extends State<ResultBottomSheet> {
  /// Will used to access the Animated list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onAnimationListRender?.call(_listKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      maxChildSize: 0.8,
      initialChildSize: 0.3,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          margin: EdgeInsets.only(top: 0.05 * context.height),
          height: 0.75 * context.height,
          width: double.infinity,

          // Generic Designing of the sheet
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.r16),
              topLeft: Radius.circular(Dimens.r16),
            ),
            color: Colors.grey.shade200.withOpacity(Dimens.opacity50),
          ),
          // Contents of the sheet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimens.h4),

              /// Title & Buttons
              SingleChildScrollView(
                controller: scrollController,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// Clear button
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.detectedList.isNotEmpty ? widget.onTapClear : null,
                      child: Text(
                        context.localization?.clear ?? '',
                        style: AppStyles.style14.copyWith(color: widget.detectedList.isNotEmpty ? AppColors.passioBlack85 : AppColors.passioBlack25),
                      ),
                    ),

                    /// Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Here, displaying the horizontal black line in center.
                        Container(
                          height: Dimens.h4,
                          width: Dimens.w40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.r16),
                            color: AppColors.blackColor,
                          ),
                        ),
                        Dimens.h4.verticalSpace,
                        GestureDetector(
                          onTap: widget.detectedList.length > 1 ? widget.onTapNewRecipe : null,
                          child: Text(
                            context.localization?.newRecipe ?? '',
                            style:
                                AppStyles.style14.copyWith(color: widget.detectedList.length > 1 ? AppColors.passioBlack85 : AppColors.passioBlack25),
                          ),
                        ),
                      ],
                    ),

                    /// Add all button
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.detectedList.isNotEmpty ? widget.onTapAddAll : null,
                      child: Text(
                        context.localization?.addAll ?? '',
                        style: AppStyles.style14.copyWith(color: widget.detectedList.isNotEmpty ? AppColors.passioBlack85 : AppColors.passioBlack25),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimens.h4),

              ///
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  initialItemCount: widget.detectedList.length,
                  itemBuilder: (context, index, animation) {
                    final data = widget.detectedList.elementAt(index);
                    return GestureDetector(
                      onTap: () => widget.onTapItem?.call(index),
                      child: BottomSheetListRow(
                        key: ValueKey(data?.passioID),
                        foodRecord: data,
                        animation: animation,
                        onCancel: () => widget.onTapClearItem?.call(index, data),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
