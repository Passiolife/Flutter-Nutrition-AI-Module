import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../nutrition_ai_module.dart';
import '../constant/app_common_constants.dart';
import 'vector/vector_widget.dart';

class PassioImageWidget extends StatefulWidget {
  const PassioImageWidget({
    this.iconId,
    this.image,
    this.type = PassioIDEntityType.item,
    this.iconSize = IconSize.px90,
    this.radius = 30,
    this.heroTag,
    this.foodRecord,
    super.key,
  });

  final String? iconId;
  final Uint8List? image;
  final PassioIDEntityType type;
  final IconSize iconSize;
  final double radius;
  final Object? heroTag;
  final FoodRecord? foodRecord;

  @override
  State<PassioImageWidget> createState() => _PassioImageWidgetState();
}

class _PassioImageWidgetState extends State<PassioImageWidget> {
  late ValueNotifier<Uint8List?> _image;

  bool get _isRecipeIcon =>
      widget.iconId?.startsWith(AppCommonConstants.recipePrefix) ?? false;

  bool get _isCustomFoodIcon => widget.iconId == FoodRecord.userFoodPrefix;

  bool get _isCustomFoodCustomIcon =>
      (widget.iconId?.startsWith(FoodRecord.userFoodPrefix) ?? false) &&
      (widget.iconId != FoodRecord.userFoodPrefix);

  bool get _isCustomRecipeCustomIcon =>
      (widget.iconId?.startsWith(FoodRecord.userRecipePrefix) ?? false) &&
      (widget.iconId != FoodRecord.userRecipePrefix);

  @override
  void initState() {
    _image = ValueNotifier(null);
    _fetchImage();
    super.initState();
  }

  @override
  void dispose() {
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isRecipeIcon
        ? CircleAvatar(
            radius: widget.radius,
            backgroundImage: const AssetImage(AppImages.imgRecipe),
          )
        : _isCustomFoodIcon
            ? VectorWidget(
                imagePath: AppImages.icCustomFoods,
                width: widget.radius * 2,
                height: widget.radius * 2,
              )
            : IconButton(
                onPressed: null,
                icon: ValueListenableBuilder<Uint8List?>(
                  valueListenable: _image,
                  builder: (context, value, child) => value != null
                      ? Hero(
                          tag: widget.heroTag ?? UniqueKey(),
                          child: CircleAvatar(
                            radius: widget.radius,
                            backgroundImage: MemoryImage(value),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              );
  }

  Future<void> _fetchImage() async {
    if (widget.image != null) {
      _image.value = widget.image;
      return;
    }
    if (_isRecipeIcon) {
      return;
    } else if (widget.iconId == null) {
      return;
    } else if (_isCustomFoodCustomIcon || _isCustomRecipeCustomIcon) {
      final result = await NutritionAIModule.instance.configuration.connector
          .fetchUserFoodImage(id: widget.iconId!);
      _image.value = result;
      return;
    }
    /* else if (widget.iconId!.startsWith(FoodRecord.userFoodPrefix) ||
        widget.iconId!.startsWith(FoodRecord.userRecipePrefix)) {

      final result = await NutritionAIModule.instance.configuration.connector
          .fetchUserFoodImage(id: widget.iconId!);
      _image.value = result;
      return;
    } */
    else if (_isCustomFoodIcon) {
      _image.value =
          (await rootBundle.load(AppImages.icCustomFoods)).buffer.asUint8List();
      return;
    }
    try {
      final result = await NutritionAI.instance.lookupIconsFor(
        widget.iconId!,
        iconSize: widget.iconSize,
        type: widget.type,
      );

      setImage(result.cachedIcon ?? result.defaultIcon);
      if (result.cachedIcon != null) {
        return;
      }

      if (result.cachedIcon == null && widget.iconId!.isNotEmpty) {
        final fetchedImage = await NutritionAI.instance.fetchIconFor(
          widget.iconId!,
          iconSize: widget.iconSize,
        );
        if (fetchedImage != null) {
          setImage(fetchedImage);
        }
      }
    } catch (error) {
      // Handle potential errors during image fetching
      log("Error fetching image: $error");
    }
  }

  void setImage(PlatformImage? image) {
    if (mounted) {
      _image.value = image?.pixels;
    }
  }
}
