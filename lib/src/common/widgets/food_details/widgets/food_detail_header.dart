import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/dimens.dart';
import '../../../constant/styles.dart';
import '../../../util/context_extension.dart';
import '../../../util/string_extensions.dart';

typedef OnTapItem = Function(PassioIDAndName? data);
typedef OnTapEditAmount = VoidCallback;
typedef OnTapTitle = VoidCallback;

class FoodDetailHeader extends StatefulWidget {
  const FoodDetailHeader({
    required this.passioID,
    this.entityType = PassioIDEntityType.item,
    required this.title,
    required this.subTitle,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalProteins,
    required this.totalFat,
    this.onTapItem,
    this.tagPassioId,
    this.tagName,
    this.tagSubtitle,
    this.tagCalories,
    this.tagCaloriesData,
    this.onTapEditAmount,
    this.isEditAmountVisible = false,
    this.onTapTitle,
    super.key,
  });

  final OnTapItem? onTapItem;

  ///
  final PassioID? passioID;
  final PassioIDEntityType entityType;
  final String title;
  final String subTitle;
  final String totalCalories;
  final String totalCarbs;
  final String totalProteins;
  final String totalFat;

  final PassioID? tagPassioId;
  final String? tagName;
  final String? tagSubtitle;
  final String? tagCalories;
  final String? tagCaloriesData;

  final bool isEditAmountVisible;

  final OnTapEditAmount? onTapEditAmount;

  final OnTapTitle? onTapTitle;

  @override
  State<FoodDetailHeader> createState() => _FoodDetailHeaderState();
}

class _FoodDetailHeaderState extends State<FoodDetailHeader> {
  /// [_image] is use to display the detected item image.
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.passioInset,
      surfaceTintColor: AppColors.passioInset,
      margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: Dimens.h16, horizontal: Dimens.w16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: ValueListenableBuilder(
                    valueListenable: _image,
                    builder: (context, value, child) {
                      return AnimatedSwitcher(
                        key: ValueKey<PlatformImage?>(_image.value),
                        duration: const Duration(milliseconds: 250),
                        child: (value?.pixels != null)
                            ? PassioIcon(image: _image.value)
                            : SizedBox(
                                width: Dimens.r50,
                                height: Dimens.r50,
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: GestureDetector(
                          onTap: widget.onTapTitle,
                          child: Text(
                            widget.title,
                            style: AppStyles.style18.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                widget.subTitle,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(
                                milliseconds: Dimens.duration300),
                            child: widget.isEditAmountVisible
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: widget.onTapEditAmount,
                                    child: Container(
                                      key: ValueKey(widget.isEditAmountVisible),
                                      decoration: BoxDecoration(
                                          color: AppColors.customBase,
                                          borderRadius: BorderRadius.circular(
                                              Dimens.r16)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimens.h8,
                                          horizontal: Dimens.w8),
                                      child: Text(
                                        context.localization?.editAmount ?? '',
                                        style: AppStyles.style14.copyWith(
                                            color: AppColors.passioInset),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(
                                    key: ValueKey(widget.isEditAmountVisible),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Dimens.w8.verticalSpace,
            Row(
              children: [
                TitleDescriptionColumn(
                  title: context.localization?.calories,
                  description: widget.totalCalories,
                  tagTitle: widget.tagCalories,
                  tagDescription: widget.tagCaloriesData,
                ),
                TitleDescriptionColumn(
                  title: context.localization?.carbs,
                  description: widget.totalCarbs,
                ),
                TitleDescriptionColumn(
                  title: context.localization?.protein,
                  description: widget.totalProteins,
                ),
                TitleDescriptionColumn(
                  title: context.localization?.fat,
                  description: widget.totalFat,
                ),
              ],
            ),
          ],
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

    PassioFoodIcons passioFoodIcons = await NutritionAI.instance
        .lookupIconsFor(widget.passioID ?? '', type: widget.entityType);

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon =
        await NutritionAI.instance.fetchIconFor(widget.passioID ?? '');
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}

class TitleDescriptionColumn extends StatelessWidget {
  final String? title;
  final String? description;
  final String? tagTitle;
  final String? tagDescription;

  const TitleDescriptionColumn(
      {super.key,
      required this.title,
      required this.description,
      this.tagTitle,
      this.tagDescription});

  Widget get titleWidget => Text(
        title ?? "",
        style: AppStyles.style14,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );

  Widget get descriptionWidget => Text(
        description ?? "",
        style: AppStyles.style18,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          tagTitle.isNotNullOrEmpty
              ? Material(type: MaterialType.transparency, child: titleWidget)
              : titleWidget,
          tagDescription.isNotNullOrEmpty
              ? Material(
                  type: MaterialType.transparency,
                  child: descriptionWidget,
                )
              : descriptionWidget,
        ],
      ),
    );
  }
}
