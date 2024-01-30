import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';

class BottomSheetListRow extends StatefulWidget {
  const BottomSheetListRow({
    this.foodRecord,
    required this.animation,
    this.onCancel,
    super.key,
  });

  /// When user tap on clear button,
  /// It removes the item from list.
  final VoidCallback? onCancel;

  /// [foodRecord] is use to get the data of detected item.
  final FoodRecord? foodRecord;

  /// [animation] is use to animate the item while adding or removing the item.
  final Animation<double> animation;

  @override
  State<BottomSheetListRow> createState() => _BottomSheetListRowState();
}

class _BottomSheetListRowState extends State<BottomSheetListRow> {
  /// [_image] will get from the sdk to display the image.
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(widget.animation),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: Dimens.h4, horizontal: Dimens.w8),
        child: Row(
          children: [
            /// Clear button to remove the item from list.
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onCancel,
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.w8),
                child: Image.asset(
                  AppImages.icCancelCircle,
                  width: Dimens.r22,
                  height: Dimens.r22,
                ),
              ),
            ),
            SizedBox(width: Dimens.w8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.r16),
                  color: AppColors.passioWhite25.withOpacity(Dimens.opacity50),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Dimens.r4),
                      child: ValueListenableBuilder(
                        valueListenable: _image,
                        builder: (context, value, child) {
                          return AnimatedSwitcher(
                            key: ValueKey<PlatformImage?>(_image.value),
                            duration: const Duration(milliseconds: 500),
                            child: (value?.pixels != null)
                                ? SizedBox(
                                    width: Dimens.r32,
                                    height: Dimens.r32,
                                    child: PassioIcon(image: _image.value),
                                  )
                                : SizedBox(
                                    width: Dimens.r50,
                                    height: Dimens.r50,
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: Dimens.w4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.foodRecord?.name ?? '').toUpperCaseWord,
                            style: AppStyles.style14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${(widget.foodRecord?.selectedQuantity.removeDecimalZeroFormat ?? 1)} ${widget.foodRecord?.selectedUnit ?? ""} "
                            "(${widget.foodRecord?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${widget.foodRecord?.computedWeight.unit.name.toUpperCaseWord ?? ""})",
                            style: AppStyles.style12,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.foodRecord == null) {
      _image.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons = await NutritionAI.instance.lookupIconsFor(
      widget.foodRecord?.passioID ?? '',
      type: widget.foodRecord?.entityType ?? PassioIDEntityType.item,
    );

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon = await NutritionAI.instance
        .fetchIconFor(widget.foodRecord?.passioID ?? '');
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}
