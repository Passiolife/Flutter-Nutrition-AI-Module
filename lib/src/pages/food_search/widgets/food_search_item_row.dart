import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/string_extensions.dart';

typedef OnTapItem = Function(PassioIDAndName? data);

class FoodSearchItemRow extends StatefulWidget {
  const FoodSearchItemRow({this.data, this.foodItemsImages, this.onTapItem, super.key});

  final PassioIDAndName? data;

  final Map<String?, PlatformImage?>? foodItemsImages;

  final OnTapItem? onTapItem;

  @override
  State<FoodSearchItemRow> createState() => _FoodSearchItemRowState();
}

class _FoodSearchItemRowState extends State<FoodSearchItemRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  bool get isValidPassioId =>
      !((widget.data?.passioID.contains(AppConstants.removeIcon) ?? false) || (widget.data?.passioID.contains(AppConstants.searching) ?? false));

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => isValidPassioId ? widget.onTapItem?.call(widget.data) : null,
      child: Card(
        color: AppColors.passioInset,
        surfaceTintColor: AppColors.passioInset,
        margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r16)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.h8, horizontal: Dimens.w12),
          child: Row(
            children: [
              if (widget.data?.passioID.contains(AppConstants.removeIcon) ?? false)
                SizedBox(
                  width: Dimens.r50,
                  height: Dimens.r50,
                )
              else if (widget.data?.passioID.contains(AppConstants.searching) ?? false)
                SizedBox(
                  width: Dimens.r50,
                  height: Dimens.r50,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: Dimens.r16,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                )
              else
                ValueListenableBuilder(
                  valueListenable: _image,
                  builder: (context, value, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: Dimens.r50,
                        height: Dimens.r50,
                        key: UniqueKey(),
                        child: value != null
                            ? PassioIcon(
                                image: value,
                                key: UniqueKey(),
                              )
                            : SizedBox(
                                key: UniqueKey(),
                              ),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.data?.name.toUpperCaseWord ?? '',
                  style: AppStyles.style18.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Visibility(
                visible: isValidPassioId,
                child: Visibility(
                  visible: !(widget.data?.passioID.contains("removeIcon") ?? false),
                  child: Image.asset(
                    AppImages.icPlusCircle,
                    width: Dimens.r30,
                    height: Dimens.r30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.data?.passioID != AppConstants.removeIcon &&
        widget.data?.passioID != AppConstants.searching &&
        !(widget.foodItemsImages?.containsKey(widget.data?.passioID) ?? false)) {
      /// Here, wait for the
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        PassioID passioID = widget.data?.passioID ?? '';
        PassioFoodIcons passioFoodIcons = await NutritionAI.instance.lookupIconsFor(passioID);

        if (passioFoodIcons.cachedIcon != null) {
          _image.value = passioFoodIcons.cachedIcon;
          widget.foodItemsImages?.putIfAbsent(widget.data?.passioID ?? '', () => _image.value);
          return;
        }

        _image.value = passioFoodIcons.defaultIcon;
        var remoteIcon = await NutritionAI.instance.fetchIconFor(passioID);
        if (remoteIcon != null) {
          _image.value = remoteIcon;
        }

        /// Storing image into the map, so while scrolling it doesn't calls the API call again.
        widget.foodItemsImages?.putIfAbsent(widget.data?.passioID ?? '', () => _image.value);
      });
    } else {
      /// Fetching stored image using passioID.
      _image.value = widget.foodItemsImages?[widget.data?.passioID];
    }
  }
}
