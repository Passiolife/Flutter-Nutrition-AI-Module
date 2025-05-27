import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/tab_bar/primary_tab_bar.dart';
import '../bloc/my_foods_bloc.dart';

class MyFoodsTabBarSection extends StatelessWidget {
  const MyFoodsTabBarSection({super.key});

  List<Tab> _getTabs(BuildContext context) =>
      [
        Tab(text: context.localization.custom ?? ''),
        Tab(text: context.localization.recipes ?? ''),
        Tab(text: context.localization.favorites ?? ''),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFoodsBloc, MyFoodsState>(
      buildWhen: (_, state) {
        return state is PageChangedState;
      },
      builder: (context, state) {
        final page = context.read<MyFoodsBloc>().page;
        return PrimaryTabBar(
          initialIndex: page,
          tabs: _getTabs(context),
          onTap: (value) => _onTap(context: context, value: value),
        );
      },
    );
  }

  void _onTap({required BuildContext context, required int value}) {
    context.read<MyFoodsBloc>().add(TabChangeEvent(page: value));
  }
}
