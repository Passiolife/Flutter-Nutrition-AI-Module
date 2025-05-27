import 'package:flutter/material.dart';

import '../../constant/app_constants.dart';
import '../vector/vector_widget.dart';

class PlusIconWidget extends StatelessWidget {
  const PlusIconWidget({
    this.color = AppColors.white,
    this.width,
    this.height,
    this.onTap,
    this.semanticsLabel,
    this.tooltip,
    this.padding,
    super.key,
  });

  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final String? tooltip;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return VectorWidget(
      padding: padding,
      imagePath: AppImages.icPlus,
      onTap: onTap,
      width: width,
      height: height,
      color: color,
      semanticsLabel: semanticsLabel ?? 'Add',
      tooltip: tooltip ?? 'Add',
    );
  }
}