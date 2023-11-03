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
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';

typedef OnDeleteItem = Function(int index, FoodRecord? data);
typedef OnEditItem = Function(int index, FoodRecord? data);

class FoodRecordListRow extends StatefulWidget {
  const FoodRecordListRow({required this.index, this.data, this.onDeleteItem, this.onEditItem, super.key});

  final int index;

  final FoodRecord? data;

  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  @override
  State<FoodRecordListRow> createState() => _FoodRecordListRowState();
}

class _FoodRecordListRowState extends State<FoodRecordListRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ObjectKey(widget.data),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: () => widget.onDeleteItem?.call(widget.index, widget.data)),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onEditItem?.call(widget.index, widget.data),
            backgroundColor: AppColors.customBase,
            foregroundColor: Colors.white,
            label: context.localization?.edit ?? '',
          ),
          SlidableAction(
            onPressed: (context) => widget.onDeleteItem?.call(widget.index, widget.data),
            backgroundColor: AppColors.errorColor,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => widget.onEditItem?.call(widget.index, widget.data),
        child: Card(
          color: AppColors.passioInset,
          surfaceTintColor: AppColors.passioInset,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r50)),
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
                          style: AppStyles.style17.copyWith(fontSize: Dimens.fontSizeFix17.toDouble()),
                          minFontSize: Dimens.fontSizeFix11.toDouble(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Hero(
                      tag: '${AppConstants.subtitle}${widget.index}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "${(widget.data?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${widget.data?.selectedUnit?.toUpperCaseWord ?? ""} "
                          "(${widget.data?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${widget.data?.computedWeight.symbol ?? ""})",
                          style: AppStyles.style12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Hero(
                          tag: '${context.localization?.calories}${widget.index}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "${context.localization?.calories}: ",
                              style: AppStyles.style12,
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
                              style: AppStyles.style12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimens.w4),
              Text(
                widget.data?.mealLabel?.value ?? '',
                style: AppStyles.style12,
              ),
              SizedBox(width: Dimens.w8),
              Image.asset(
                AppImages.icArrowRight,
                width: Dimens.r30,
                height: Dimens.r30,
              ),
              SizedBox(width: Dimens.w8),
            ],
          ),
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.data?.passioID == null) {
      _image.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons =
        await NutritionAI.instance.lookupIconsFor(widget.data?.passioID ?? '', type: widget.data?.entityType ?? PassioIDEntityType.item);

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon = await NutritionAI.instance.fetchIconFor(widget.data?.passioID ?? '');
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}
