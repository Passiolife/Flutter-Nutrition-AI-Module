import 'package:flutter/material.dart';

import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/adaptive_action_button_widget.dart';

typedef OnTapPositive = VoidCallback;

class NoFavoritesDataDialog {
  NoFavoritesDataDialog.show({
    required BuildContext context,
    OnTapPositive? onTapPositive,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: Dimens.duration300),
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(a1),
          child: child,
        );
      },
      pageBuilder: (dialogContext, animation, animation2) {
        return PopScope(
          canPop: false,
          child: AlertDialog.adaptive(
            title: Text(
              context.localization?.noFavoriteTitle ?? '',
              style: AppStyles.style17.copyWith(),
            ),
            content: Text(
              context.localization?.noFavoriteDescription ?? '',
              style: AppStyles.style17.copyWith(),
            ),
            actions: <Widget>[
              adaptiveAction(
                context: context,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onTapPositive?.call();
                },
                child: Text(context.localization?.ok ?? ''),
              ),
            ],
          ),
        );
      },
    );
  }
}
