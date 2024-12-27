import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../bloc/food_scan_bloc.dart';
import '../widgets/help_widget.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(
      // title: context.localization?.foodScanner,
      title: context.localization?.barcodeScan,
      isMenuVisible: false,
      suffix: HelpWidget(
        onTap: () => _handleHelp(context: context)
      ),
    );
  }

  void _handleHelp({required BuildContext context}) {
    context
        .read<FoodScanBloc>()
        .add(const IntroScreenEvent(shouldVisible: true));
  }
}
