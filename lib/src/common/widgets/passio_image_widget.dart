import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

class PassioImageWidget extends StatefulWidget {
  PassioImageWidget({
    required this.iconId,
    this.type = PassioIDEntityType.item,
    this.iconSize = IconSize.px90,
    this.radius = 30,
    this.heroTag,
  }) : super(key: ValueKey(iconId));

  final String iconId;
  final PassioIDEntityType type;
  final IconSize iconSize;
  final double radius;
  final String? heroTag;

  @override
  State<PassioImageWidget> createState() => _PassioImageWidgetState();
}

class _PassioImageWidgetState extends State<PassioImageWidget> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

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
    return ValueListenableBuilder<PlatformImage?>(
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
    try {
      final result = await NutritionAI.instance.lookupIconsFor(
        widget.iconId,
        iconSize: widget.iconSize,
        type: widget.type,
      );

      _image.value = result.cachedIcon ?? result.defaultIcon;

      if (result.cachedIcon == null && widget.iconId.isNotEmpty) {
        final fetchedImage = await NutritionAI.instance.fetchIconFor(
          widget.iconId,
          iconSize: widget.iconSize,
        );
        if (fetchedImage != null) {
          _image.value = fetchedImage;
        }
      }
    } catch (error) {
      // Handle potential errors during image fetching
      log("Error fetching image: $error");
    }
  }
}
