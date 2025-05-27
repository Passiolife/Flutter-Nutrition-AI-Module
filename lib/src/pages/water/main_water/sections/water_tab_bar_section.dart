import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../../../../common/widgets/tab_bar/primary_tab_filled_bar.dart';
import '../bloc/water_bloc.dart';

class WaterTabBarSection extends StatelessWidget {
  const WaterTabBarSection({
    this.onTabChange,
    super.key,
  });

  final ValueChanged<int>? onTabChange;

  List<String?> _getTabs(BuildContext context) =>
      [
        context.localization.week,
        context.localization.month,
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      buildWhen: (_, state) {
        return state is UpdatePageState;
      },
      builder: (context, state) {
        int initialTab = context.read<WaterBloc>().selectedTab;
        return PrimaryTabFilledBar(
          initialTab: initialTab,
          tabs: _getTabs(context),
          onTabChange: (tab) => _onTabChange(context: context, tab: tab),
          margin: AppPadding.ph16,
        );
      },
    );
  }

  void _onTabChange({required BuildContext context, required int tab}) {
    context.read<WaterBloc>().add(UpdateTabEvent(tab));
  }
}
