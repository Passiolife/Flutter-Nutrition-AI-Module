import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  /// [baseColor] Here you can customize your [baseColor] for shimmer.
  /// Otherwise, default color will be [Colors.grey.shade300].
  final Color? baseColor;

  /// [highlightColor] Here you can customize your [highlightColor] for shimmer.
  /// Otherwise, default color will be [Colors.grey.shade100].
  final Color? highlightColor;

  /// [ShimmerWidget.rectangular] This helps when you need a rectangle shimmer widget.
  const ShimmerWidget.rectangular({
    required this.height,
    this.width = double.infinity,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  /// [ShimmerWidget.circular] This helps when you need a circle shimmer widget.
  const ShimmerWidget.circular({
    required this.height,
    this.width = double.infinity,
    this.shapeBorder = const CircleBorder(),
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFF3a3a3a),
      highlightColor: highlightColor ?? const Color(0xFF4a4a4a),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: baseColor ?? Colors.white,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
