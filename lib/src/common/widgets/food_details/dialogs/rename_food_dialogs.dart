import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/context_extension.dart';
import '../../../util/string_extensions.dart';
import '../../adaptive_action_button_widget.dart';

typedef OnRenameFood = Function(String text);

class RenameFoodDialogs {
  RenameFoodDialogs.show({required BuildContext context, String? title, required String text, String? placeHolder, OnRenameFood? onRenameFood}) {
    TextEditingController controller = TextEditingController(text: text);
    showAdaptiveDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: Text(title ?? ''),
        content: CupertinoTextField(
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: placeHolder,
        ),
        actions: <Widget>[
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.localization?.cancel.toUpperCaseWord ?? ''),
          ),
          adaptiveAction(
            context: context,
            onPressed: () {
              String foodName;
              if (controller.text.isNotEmpty) {
                foodName = controller.text;
              } else {
                foodName = text;
              }
              if ((placeHolder?.isNotEmpty ?? false) && foodName.isEmpty) {
                foodName = placeHolder ?? '';
              }
              Navigator.pop(dialogContext);
              onRenameFood?.call(foodName);
            },
            child: Text(context.localization?.save.toUpperCaseWord ?? ''),
          ),
        ],
      ),
    );
  }
}
