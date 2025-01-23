import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class VectorWidget extends StatelessWidget {
  const VectorWidget({
    required this.imagePath,
    this.width,
    this.height,
    super.key,
  });

  final String imagePath;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(imagePath),
      width: width,
      height: height,
    );
  }
}
