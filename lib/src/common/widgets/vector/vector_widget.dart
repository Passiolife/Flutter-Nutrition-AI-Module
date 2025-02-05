import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

class VectorWidget extends StatelessWidget {
  const VectorWidget({
    required this.imagePath,
    this.width,
    this.height,
    this.onTap,
    this.semanticsLabel,
    super.key,
  });

  final String imagePath;
  final double? width, height;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: VectorGraphic(
        loader: AssetBytesLoader(imagePath),
        semanticsLabel: semanticsLabel,
        width: width ?? 24.r,
        height: height ?? 24.r,
      ),
    );
  }
}
