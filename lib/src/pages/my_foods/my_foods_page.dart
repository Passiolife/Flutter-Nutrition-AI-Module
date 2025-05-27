import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/router/routes.dart';
import 'bloc/my_foods_bloc.dart';
import 'sections/my_foods_app_bar_section.dart';
import 'sections/my_foods_body_section.dart';
import 'sections/my_foods_tab_bar_section.dart';

part 'screen/my_foods_screen.dart';

class MyFoodsPage extends StatelessWidget {
  const MyFoodsPage({required this.page, super.key});

  final int page;

  static MaterialPageRoute route({int page = 0}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.myFoods),
      builder: (_) => MyFoodsPage(page: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyFoodsBloc(),
      child: _MyFoodsScreen(),
    );
  }
}