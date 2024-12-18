import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_constants.dart';
import '../../common/constant/app_padding.dart';
import 'bloc/food_search_bloc.dart';
import 'models/navigation_data_provider.dart';
import 'sections/alternative_section.dart';
import 'sections/search_app_bar_section.dart';
import 'sections/keep_typing_section.dart';
import 'sections/my_foods_section.dart';
import 'sections/search_result_section.dart';

part 'screen/food_search_screen.dart';

class FoodSearchPage extends StatelessWidget {
  const FoodSearchPage({this.needsReturn = true, super.key});

  final bool needsReturn;

  // Static method to navigate to the FoodSearchPage.
  static Future navigate(BuildContext context, {bool needsReturn = true}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FoodSearchPage(needsReturn: needsReturn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchNavigationDataProvider(
      needsReturn: needsReturn,
      child: BlocProvider<FoodSearchBloc>(
        create: (_) => FoodSearchBloc(),
        child: FoodSearchScreen(),
      ),
    );
  }
}
