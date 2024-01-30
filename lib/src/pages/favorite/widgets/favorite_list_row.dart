import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';

typedef OnDeleteItem = Function(int index, FoodRecord? data);
typedef OnEditItem = Function(int index, FoodRecord? data);
typedef OnAddToLog = Function(int index, FoodRecord? data);

class FavoriteListRow extends StatefulWidget {
  const FavoriteListRow({
    required this.index,
    this.data,
    this.onDeleteItem,
    this.onEditItem,
    this.onAddToLog,
    this.isAddToLogLoading,
    super.key,
  });

  final int index;

  final FoodRecord? data;

  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  // [onAddToLog] will callbacks on log(plus) icon tap.
  final OnAddToLog? onAddToLog;

  final bool? isAddToLogLoading;

  @override
  State<FavoriteListRow> createState() => _FavoriteListRowState();
}

class _FavoriteListRowState extends State<FavoriteListRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon(PassioIDAttributes(
        widget.data?.passioID ?? '',
        widget.data?.name ?? '',
        PassioIDEntityType.item,
        null,
        null,
        null,
        null,
        null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ObjectKey(widget.data),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
            onDismissed: () =>
                widget.onDeleteItem?.call(widget.index, widget.data)),
        children: [
          SlidableAction(
            onPressed: (context) =>
                widget.onDeleteItem?.call(widget.index, widget.data),
            backgroundColor: AppColors.errorColor,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          widget.onEditItem?.call(widget.index, widget.data);
        },
        child: Card(
          color: AppColors.passioInset,
          surfaceTintColor: AppColors.passioInset,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.r16)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.h4),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimens.r8),
                  child: Hero(
                    tag: '${widget.data?.passioID}${widget.index}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: ValueListenableBuilder(
                        valueListenable: _image,
                        builder: (context, value, child) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
                              width: Dimens.r52,
                              height: Dimens.r52,
                              child: PassioIcon(
                                key: ObjectKey(_image.value),
                                image: _image.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.w8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: '${widget.data?.name}${widget.index}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: AutoSizeText(
                            widget.data?.name?.toUpperCaseWord ?? '',
                            style: AppStyles.style17.copyWith(
                                fontSize: Dimens.fontSizeFix17.toDouble(),
                                fontWeight: FontWeight.w500),
                            minFontSize: Dimens.fontSizeFix11.toDouble(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Hero(
                            tag:
                                '${context.localization?.calories}${widget.index}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                "${context.localization?.calories}: ",
                                style: AppStyles.style15
                                    .copyWith(fontWeight: FontWeight.w300),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Hero(
                            tag: '${AppConstants.calories}${widget.index}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                "${widget.data?.totalCalories.toInt()}",
                                style: AppStyles.style15
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                // Carbs Widgets
                                Wrap(
                                  children: [
                                    Hero(
                                      tag:
                                          '${context.localization?.carbs}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${context.localization?.carbs}: ",
                                          style: AppStyles.style15.copyWith(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                    Hero(
                                      tag:
                                          '${AppConstants.carbs}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${widget.data?.totalCarbs.toInt()} ",
                                          style: AppStyles.style15.copyWith(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Protein Widgets
                                Wrap(
                                  children: [
                                    Hero(
                                      tag:
                                          '${context.localization?.protein}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${context.localization?.protein}: ",
                                          style: AppStyles.style15.copyWith(
                                              fontWeight: FontWeight.w300),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Hero(
                                      tag:
                                          '${AppConstants.protein}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${widget.data?.totalProteins.toInt()} ",
                                          style: AppStyles.style15.copyWith(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Fat Widgets
                                Wrap(
                                  children: [
                                    Hero(
                                      tag:
                                          '${context.localization?.fat}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${context.localization?.fat}: ",
                                          style: AppStyles.style15.copyWith(
                                              fontWeight: FontWeight.w300),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Hero(
                                      tag: '${AppConstants.fat}${widget.index}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${widget.data?.totalFat.toInt()} ",
                                          style: AppStyles.style15.copyWith(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimens.w4),
                AnimatedOpacity(
                  opacity: (widget.isAddToLogLoading ?? false)
                      ? Dimens.opacity0
                      : Dimens.opacity100,
                  duration: const Duration(milliseconds: Dimens.duration500),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        widget.onAddToLog?.call(widget.index, widget.data),
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.r16),
                      child: Image.asset(
                        AppImages.icPlusCircle,
                        width: Dimens.r24,
                        height: Dimens.r24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getFoodIcon(PassioIDAttributes? passioIDAttributes) async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (passioIDAttributes == null) {
      _image.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons = await NutritionAI.instance.lookupIconsFor(
        passioIDAttributes.passioID,
        type: passioIDAttributes.entityType);

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon =
        await NutritionAI.instance.fetchIconFor(passioIDAttributes.passioID);
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}
