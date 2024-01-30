import 'package:flutter/cupertino.dart';

import '../../../common/util/context_extension.dart';

typedef OnTapItem = Function(BuildContext dialogContext, String? item);

class MoreActionsDialog {
  MoreActionsDialog.show({
    required BuildContext context,
    OnTapItem? onTapItem,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (dialogContext) => CupertinoActionSheet(
        title: Text(context.localization?.menu ?? ''),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () =>
                onTapItem?.call(dialogContext, context.localization?.progress),
            child: Text(
              context.localization?.progress ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () =>
                onTapItem?.call(dialogContext, context.localization?.favorites),
            child: Text(
              context.localization?.favorites ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () =>
                onTapItem?.call(dialogContext, context.localization?.profile),
            child: Text(
              context.localization?.profile ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () =>
                onTapItem?.call(dialogContext, context.localization?.cancel),
            child: Text(
              context.localization?.cancel ?? '',
            ),
          ),
        ],
      ),
    );
  }
}
