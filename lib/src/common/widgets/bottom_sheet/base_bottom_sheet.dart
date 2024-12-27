import 'package:flutter/material.dart';

import '../../constant/app_padding.dart';
import '../../constant/app_shadow.dart';
import '../../extension/context_extension.dart';

class BaseBottomSheet extends StatelessWidget {
  const BaseBottomSheet({
    required this.child,
    this.height,
    super.key,
  });

  final Widget child;

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: height,
      decoration: AppShadows.base,
      padding: AppPadding.ph16,
      child: child,
    );
  }
}
