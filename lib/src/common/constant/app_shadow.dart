import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class AppShadows {
  // Small Shadow
  static BoxDecoration sm = BoxDecoration(
    // Background color for the box
    color: AppColors.white,
    // Border radius for rounded corners
    borderRadius: BorderRadius.circular(AppDimens.r8),
    // Box shadow settings
    boxShadow: [
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity5),
        // Shadow offset (x, y)
        offset: const Offset(0, 1),
        // Blur radius of the shadow
        blurRadius: AppDimens.r2,
        // Spread radius of the shadow
        spreadRadius: 0,
      ),
    ],
  );

  // Base Shadow
  static BoxDecoration base = BoxDecoration(
    // Background color for the box
    color: AppColors.white,
    // Border radius for rounded corners
    borderRadius: BorderRadius.circular(AppDimens.r8),
    // Box shadow settings
    boxShadow: [
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity6),
        // Shadow offset (x, y)
        offset: const Offset(0, 1),
        // Blur radius of the shadow
        blurRadius: 2,
        // Spread radius of the shadow
        spreadRadius: 0,
      ),
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity10),
        // Shadow offset (x, y)
        offset: const Offset(0, 1),
        // Blur radius of the shadow
        blurRadius: 3,
        // Spread radius of the shadow
        spreadRadius: 0,
      ),
    ],
  );

  // Large Shadow
  static BoxDecoration lg = BoxDecoration(
    // Background color for the box
    color: AppColors.white,
    // Border radius for rounded corners
    borderRadius: BorderRadius.circular(AppDimens.r8),
    // Box shadow settings
    boxShadow: [
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity5),
        // Shadow offset (x, y)
        offset: const Offset(0, 4),
        // Blur radius of the shadow
        blurRadius: 6,
        // Spread radius of the shadow
        spreadRadius: -2,
      ),
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity10),
        // Shadow offset (x, y)
        offset: const Offset(0, 10),
        // Blur radius of the shadow
        blurRadius: 15,
        // Spread radius of the shadow
        spreadRadius: -3,
      ),
    ],
  );

  // Applied shadow effect to the search screen item row
  static BoxDecoration customShadow = BoxDecoration(
    // Background color for the box
    color: AppColors.white,
    // Border radius for rounded corners
    borderRadius: BorderRadius.circular(AppDimens.r8),
    // Box shadow settings
    boxShadow: [
      BoxShadow(
        // Shadow color with opacity
        color: AppColors.black.withOpacity(AppDimens.opacity10),
        // Shadow offset (x, y)
        offset: const Offset(0, 2),
        // Blur radius of the shadow
        blurRadius: AppDimens.r8,
        // Spread radius of the shadow
        spreadRadius: 0,
      ),
    ],
  );

  static BoxShadow ring1BlackOpacity5 = BoxShadow(
    // Shadow color with opacity
    color: AppColors.black.withOpacity(AppDimens.opacity5),
    // Shadow offset (x, y)
    offset: const Offset(0, 0),
    // Blur radius of the shadow
    blurRadius: 0,
    // Spread radius of the shadow
    spreadRadius: AppDimens.r1,
  );
}

extension AppShadowExtension on BoxDecoration {
  BoxDecoration addAll(List<BoxShadow> shadows, {int? atIndex}) {
    if (atIndex != null) {
      boxShadow?.insertAll(atIndex, shadows);
    } else {
      boxShadow?.addAll(shadows);
    }
    return this;
  }
}
