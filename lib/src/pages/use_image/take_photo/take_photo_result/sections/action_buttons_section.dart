import 'package:flutter/material.dart';

import '../widgets/action_buttons_widget.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionButtonsWidget(
      onTapCreateRecipe: () {},
      onTapLogSelected: () {},
    );
  }
}
