import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/page_view/primary_page_view.dart';
import '../../custom_foods/custom_foods_page.dart';
import '../../favorites/favorites_page.dart';
import '../../recipes/recipes_page.dart';
import '../bloc/my_foods_bloc.dart';

class MyFoodsBodySection extends StatelessWidget {
  const MyFoodsBodySection({super.key});

  List<Widget> get children =>
      [
        const CustomFoodsPage(),
        const RecipesPage(),
        const FavoritesPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFoodsBloc, MyFoodsState>(
      buildWhen: (_, state) {
        return state is TabChangedState;
      },
      builder: (context, state) {
        final page = context.read<MyFoodsBloc>().page;
        return Expanded(
          child: PrimaryPageView(
            initialPage: page,
            children: children,
            onPageChanged: (value) => _onPageChanged(context: context, value: value),
          ),
        );
      },
    );
  }

  void _onPageChanged({required BuildContext context, required int value}) {
    context.read<MyFoodsBloc>().add(PageChangeEvent(page: value));
  }
}
