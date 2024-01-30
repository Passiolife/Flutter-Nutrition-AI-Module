import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/dimens.dart';
import '../../../constant/styles.dart';
import '../../../util/context_extension.dart';
import '../../../util/double_extensions.dart';
import '../../../util/string_extensions.dart';

typedef OnTapAddIngredients = VoidCallback;
typedef OnTapIngredients = Function(PassioFoodItemData? data);

typedef OnDeleteItem = Function(int index);
typedef OnEditItem = Function(int index);

class IngredientsWidget extends StatelessWidget {
  const IngredientsWidget({
    this.onTapAddIngredients,
    this.data,
    this.onEditItem,
    this.onDeleteItem,
    super.key,
  });

  final OnTapAddIngredients? onTapAddIngredients;
  final List<PassioFoodItemData>? data;

  // When user deletes the item by swiping or sliding.
  final OnDeleteItem? onDeleteItem;

  //
  final OnEditItem? onEditItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimens.h56,
          child: Stack(
            children: [
              Positioned(
                top: Dimens.h16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    context.localization?.ingredients ?? '',
                    style: AppStyles.style17,
                  ),
                ),
              ),
              Positioned(
                top: Dimens.h8,
                right: Dimens.w16,
                child: GestureDetector(
                  onTap: onTapAddIngredients,
                  child: SizedBox(
                    width: Dimens.r40,
                    height: Dimens.r40,
                    child: Center(
                      child: Image.asset(
                        AppImages.icPlusCircle,
                        width: Dimens.r24,
                        height: Dimens.r24,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SlidableAutoCloseBehavior(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: ((data?.length ?? 0) > 1) ? data?.length : 0,
            itemBuilder: (context, index) {
              final ingredient = data?.elementAt(index);
              if (ingredient != null) {
                return _IngredientListRow(
                  key: ValueKey(ingredient.passioID),
                  index: index,
                  computedWeight: ingredient.computedWeight(),
                  totalCalories: ingredient.totalCalories()?.value ?? 0,
                  selectedQuantity: ingredient.selectedQuantity,
                  passioID: ingredient.passioID,
                  name: ingredient.name,
                  entityType: ingredient.entityType,
                  selectedUnit: ingredient.selectedUnit,
                  onDeleteItem: onDeleteItem,
                  onEditItem: onEditItem,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}


class _IngredientListRow extends StatefulWidget {
  const _IngredientListRow({
    required this.index,
    required this.computedWeight,
    required this.totalCalories,
    required this.selectedQuantity,
    this.passioID,
    this.name = '',
    this.entityType,
    this.selectedUnit,
    this.onDeleteItem,
    this.onEditItem,
    super.key,
  });

  final int index;

  //
  final PassioID? passioID;
  final String name;

  final PassioIDEntityType? entityType;

  ///
  // final FoodRecordResponse? data;
  final double totalCalories;
  final double selectedQuantity;
  final String? selectedUnit;
  final UnitMass computedWeight;

  // When user deletes the item by swiping or sliding.
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  @override
  State<_IngredientListRow> createState() => _IngredientListRowState();
}

class _IngredientListRowState extends State<_IngredientListRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: () => widget.onDeleteItem?.call(widget.index)),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onDeleteItem?.call(widget.index),
            backgroundColor: AppColors.errorColor,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => widget.onEditItem?.call(widget.index),
        child: Card(
          color: AppColors.passioInset,
          surfaceTintColor: AppColors.passioInset,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r50)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(Dimens.r8),
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
              SizedBox(width: Dimens.w8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.name.toUpperCaseWord,
                        style: AppStyles.style17,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${(widget.selectedQuantity).removeDecimalZeroFormat} ${widget.selectedUnit?.toUpperCaseWord ?? ""} "
                            "(${widget.computedWeight.value.removeDecimalZeroFormat} ${widget.computedWeight.symbol})",
                        style: AppStyles.style12,
                      ),
                    ),
                    Row(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${context.localization?.calories}: ",
                            style: AppStyles.style12,
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${widget.totalCalories.toInt()}",
                            style: AppStyles.style12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Dimens.w8.horizontalSpace,
              Image.asset(
                AppImages.icArrowRight,
                width: Dimens.r30,
                height: Dimens.r30,
              ),
              Dimens.w8.horizontalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.passioID == null) {
      _image.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons =
    await NutritionAI.instance.lookupIconsFor(widget.passioID ?? '', type: widget.entityType ?? PassioIDEntityType.item);

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon = await NutritionAI.instance.fetchIconFor(widget.passioID ?? '');
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}