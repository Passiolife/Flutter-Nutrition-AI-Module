import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';

typedef OnTapResult = VoidCallback;

class FoodResultWidget extends StatefulWidget {
  const FoodResultWidget({
    this.title,
    this.subTitle,
    this.passioID,
    this.entityType = PassioIDEntityType.item,
    this.onTapResult,
    super.key,
  });

  // [title] is [String] which displays on result view.
  final String? title;

  // [subTitle] is [String] which displays on besides to [title] in result view.
  final String? subTitle;

  // [passioID] is food id to fetch the food icon.
  final String? passioID;

  // [entityType] contains the food entity type like: item or recipe, etc.
  final PassioIDEntityType entityType;

  /// [onTapResult] calls when we tap on result view.
  final OnTapResult? onTapResult;

  @override
  State<FoodResultWidget> createState() => _FoodResultWidgetState();
}

class _FoodResultWidgetState extends State<FoodResultWidget> {
  /// [_foodImage] is picture of scanned food.
  final ValueNotifier<PlatformImage?> _foodImage = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapResult,
      child: Card(
        color: AppColors.passioInset,
        surfaceTintColor: AppColors.passioInset,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r16)),
        child: Container(
          height: Dimens.h100,
          padding: EdgeInsets.only(top: Dimens.h16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Dimens.w16),
                  ValueListenableBuilder(
                    valueListenable: _foodImage,
                    builder: (context, value, child) {
                      return value != null
                          ? CircleAvatar(
                              radius: Dimens.r26,
                              backgroundImage: MemoryImage(value.pixels),
                            )
                          : const SizedBox();
                    },
                  ),
                  SizedBox(width: Dimens.w16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization?.detected.format([widget.title ?? ''])?.toUpperCaseWord ?? '',
                          style: AppStyles.style14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          context.localization?.nutrition.format([widget.subTitle ?? ''])?.toUpperCaseWord ?? '',
                          style: AppStyles.style14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getFoodIcon() async {
    if (widget.passioID == null) {
      _foodImage.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons = await NutritionAI.instance.lookupIconsFor(
      widget.passioID ?? '',
      type: widget.entityType,
    );

    if (passioFoodIcons.cachedIcon != null) {
      _foodImage.value = passioFoodIcons.cachedIcon;
      return;
    }

    _foodImage.value = passioFoodIcons.defaultIcon;

    var remoteIcon = await NutritionAI.instance.fetchIconFor(widget.passioID ?? '');
    if (remoteIcon != null) {
      _foodImage.value = remoteIcon;
    }
  }
}
