import 'package:flutter/cupertino.dart';

import '../../../common/util/context_extension.dart';

typedef OnTapItem = Function(BuildContext dialogContext, String? item);

class AddItemDialog {
  AddItemDialog.show({
    required BuildContext context,
    OnTapItem? onTapItem,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (dialogContext) =>
          CupertinoActionSheet(
            title: Text(context.localization?.addItem ?? ''),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => onTapItem?.call(dialogContext, context.localization?.quickFoodScan),
                child: Text(
                  context.localization?.quickFoodScan ?? '',
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () => onTapItem?.call(dialogContext, context.localization?.multiFoodScan),
                child: Text(
                  context.localization?.multiFoodScan ?? '',
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () => onTapItem?.call(dialogContext, context.localization?.byTextSearch),
                child: Text(
                  context.localization?.byTextSearch ?? '',
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () => onTapItem?.call(dialogContext, context.localization?.fromFavorites),
                child: Text(
                  context.localization?.fromFavorites ?? '',
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => onTapItem?.call(dialogContext, context.localization?.cancel),
                child: Text(
                  context.localization?.cancel ?? '',
                ),
              ),
            ],
          ),
    );
  }
}
