import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../widgets/intro_widget.dart';

class IntroDialog {
  IntroDialog.show(
      {required BuildContext context,
      Function(BuildContext context)? onTapOk}) {
    showGeneralDialog(
      context: context,
      barrierColor: AppColors.gray500.withOpacity(AppDimens.opacity75),
      pageBuilder: (context, animation1, animation2) {
        return IntroWidget(onTap: () => onTapOk?.call(context));
      },
      transitionDuration: const Duration(milliseconds: AppDimens.duration250),
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
