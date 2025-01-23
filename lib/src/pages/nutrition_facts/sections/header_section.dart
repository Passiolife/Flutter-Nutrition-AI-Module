import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/app_bar/custom_app_bar.dart';
import '../../../common/widgets/icons/help_widget.dart';
import '../bloc/nutrition_facts_bloc.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: context.localization.barcodeScan,
      actions: [
        HelpWidget(
          onTap: () {
            context.read<NutritionFactsBloc>().add(const ShowIntroScreenEvent());
          },
        ),
      ],
    );
  }
}
