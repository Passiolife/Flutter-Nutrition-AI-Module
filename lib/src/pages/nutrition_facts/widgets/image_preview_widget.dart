import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({
    super.key,
    required this.image,
  });

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph24 + AppPadding.pt16,
      child: ClipRRect(
        borderRadius: AppBorderCircular.ba8,
        child: Image.memory(
          image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
