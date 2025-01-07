import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';

class ImagePreviewSection extends StatelessWidget {
  const ImagePreviewSection({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph32,
      child: ClipRRect(
        borderRadius: AppBorderCircular.ba8,
        child: Image.file(
          file,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
