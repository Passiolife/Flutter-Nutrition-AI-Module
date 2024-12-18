import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../bloc/recipes_bloc.dart';
import 'section/action_buttons_section.dart';
import 'section/recipe_list_section.dart';

part 'screen/recipes_screen.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipesBloc(),
      child: _RecipesScreen(),
    );
  }

  // void _fetchUserFoods() {
  //   _bloc.add(const FetchUserRecipeEvent());
  // }

  // Future<void> _doCreateNewFood() async {
  //   await RecipeCreatorPage.navigate(context: context);
  //   /*final result = await FoodCreatorPage.navigate(context: context);
  //   if (result != null && result) {
  //     _fetchUserFoods();
  //   }*/
  // }
  //
  // Future<void> _doEditRecord(FoodRecord foodRecord) async {
  //   await RecipeCreatorPage.navigate(context: context);
  //   /*final result = await FoodCreatorPage.navigate(
  //       context: context, foodRecord: foodRecord, isUpdate: true);
  //   if (result != null && result) {
  //     _fetchUserFoods();
  //   }*/
  // }
  //
  // void _doDeleteRecord(FoodRecord foodRecord) {
  //   // _bloc.add(DoDeleteUserFoodEvent(foodRecord: foodRecord));
  // }
  //
  // void _handleStateChanges(BuildContext context, RecipesState state) {
  //   /*if (state is ListenerState) {
  //     switch (state) {
  //       case FetchUserFoodsListenerState():
  //         _list = state.data;
  //         break;
  //       case LogSuccessState():
  //         context.showSnackbar(text: context.localization?.itemAddedToDiary);
  //         break;
  //     }
  //   }*/
  // }
}
