import 'package:flutter/material.dart';
import '../../constant/app_constants.dart';
import '../vector/vector_widget.dart';

class IconChevronDownWidget extends StatelessWidget {
  const IconChevronDownWidget({
    this.color = AppColors.white,
    this.width,
    this.height,
    this.onTap,
    super.key,
  });

  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VectorWidget(
      imagePath: AppImages.icChevronDownNew,
      onTap: onTap,
      width: width,
      height: height,
      color: color,
      semanticsLabel: 'search',
    );
  }
}
