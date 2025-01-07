import 'package:flutter/material.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/button/primary_button.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          text: context.localization.cancel,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}