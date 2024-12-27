import 'package:flutter/material.dart';

import '../constant/app_border.dart';
import '../constant/app_colors.dart';

class ShowWidgetUtil {
  const ShowWidgetUtil._();

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = false,
    bool useRootNavigator = true,
    Color backgroundColor = AppColors.white,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      shape: shape ?? RoundedRectangleBorder(borderRadius: AppBorderCircular.bt16),
      useRootNavigator: useRootNavigator,
      backgroundColor: backgroundColor,
      context: context,
      builder: builder,
    );
  }
}
