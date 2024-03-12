import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../widgets/added_to_diary_widget.dart';

class AddedToDiaryDialog {
  AddedToDiaryDialog.show({
    required BuildContext context,
    Function(BuildContext context)? onTapViewDiary,
    Function(BuildContext context)? onTapContinue,
  }) {
    showGeneralDialog(
      context: context,
      barrierColor: AppColors.transparent,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: AddedToDiaryWidget(
            onTapViewDiary: () => onTapViewDiary?.call(context),
            onTapContinue: () => onTapContinue?.call(context),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: AppDimens.duration400),
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
