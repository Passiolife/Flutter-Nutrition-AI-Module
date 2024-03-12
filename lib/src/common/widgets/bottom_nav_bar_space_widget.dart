import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';

class BottomNavBarSpaceWidget extends StatelessWidget {
  const BottomNavBarSpaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // SizedBox is added to ensure that additional items don't get obscured by the bottom navigation bar.
    // AppDimens.h16: Represents the top spacing of the bottom navigation bar.
    // (context.bottomPadding + AppDimens.h16): Includes the bottom padding of the device and additional spacing for the bottom navigation bar.
    // AppDimens.h16: Additional space added to ensure the entire content remains visible.
    return SizedBox(
        height: AppDimens.h16 +
            (context.bottomPadding + AppDimens.h16) +
            AppDimens.h16);
  }
}
