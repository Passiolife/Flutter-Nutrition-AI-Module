import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_padding.dart';
import '../../extension/core_extension.dart';

class VectorWidget extends StatelessWidget {
  const VectorWidget({
    required this.imagePath,
    this.width,
    this.height,
    this.onTap,
    this.semanticsLabel,
    this.tooltip,
    this.blendMode = BlendMode.srcIn,
    this.color,
    this.fit = BoxFit.contain,
    this.padding,
    super.key,
  });

  final String imagePath;
  final double? width, height;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final String? tooltip;
  final Color? color;
  final BlendMode blendMode;
  final BoxFit fit;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: padding,
      tooltip: tooltip,
      icon: VectorGraphic(
        loader: AssetBytesLoader(imagePath),
        semanticsLabel: semanticsLabel,
        width: width ?? 24.r,
        height: height ?? 24.r,
        colorFilter: color.let((it) => ColorFilter.mode(it, blendMode)),
        fit: fit,
      ),
    );
  }
}
