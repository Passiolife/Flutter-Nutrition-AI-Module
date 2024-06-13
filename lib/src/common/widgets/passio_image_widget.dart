import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../constant/app_common_constants.dart';
import '../constant/app_images.dart';

class PassioImageWidget extends StatefulWidget {
  const PassioImageWidget({
    required this.iconId,
    this.type = PassioIDEntityType.item,
    this.iconSize = IconSize.px90,
    this.radius = 30,
    this.heroTag,
    super.key,
  });

  final String iconId;
  final PassioIDEntityType type;
  final IconSize iconSize;
  final double radius;
  final Object? heroTag;

  @override
  State<PassioImageWidget> createState() => _PassioImageWidgetState();
}

class _PassioImageWidgetState extends State<PassioImageWidget> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  bool get _isRecipeIcon =>
      widget.iconId.startsWith(AppCommonConstants.recipePrefix);

  @override
  void initState() {
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
        : ValueListenableBuilder<PlatformImage?>(
            valueListenable: _image,
            builder: (context, value, child) => value != null
                ? Hero(
                    tag: widget.heroTag ?? UniqueKey(),
                    child: CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: MemoryImage(value.pixels),
                    ),
                  )
                : const CircularProgressIndicator(),
          );
  }

  Future<void> _fetchImage() async {
    if (_isRecipeIcon) {
      return;
    }
    try {
      final result = await NutritionAI.instance.lookupIconsFor(
        widget.iconId,
        iconSize: widget.iconSize,
        type: widget.type,
      );

      setImage(result.cachedIcon ?? result.defaultIcon);
      if (result.cachedIcon != null) {
        return;
      }

      if (result.cachedIcon == null && widget.iconId.isNotEmpty) {
        final fetchedImage = await NutritionAI.instance.fetchIconFor(
          widget.iconId,
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
      _image.value = image;
    }
  }
}
