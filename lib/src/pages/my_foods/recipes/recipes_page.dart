import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../common/constant/app_button_styles.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import 'bloc/recipes_bloc.dart';
import 'recipe_creator/recipe_creator_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final _bloc = RecipesBloc();

  List<FoodRecord>? _list;

  @override
  void initState() {
    _fetchUserFoods();
    super.initState();
  }

  @override
  void dispose() {
    _list = null;
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipesBloc, RecipesState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: SlidableAutoCloseBehavior(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    itemCount: _list?.length ?? 0,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = _list?.elementAt(index);
                      if (data == null) return const SizedBox.shrink();
                      return Slidable(
                        key: UniqueKey(),
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          extentRatio: 0.6,
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () => _doDeleteRecord(data),
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) => _doEditRecord(data),
                              backgroundColor: AppColors.indigo600Main,
                              foregroundColor: Colors.white,
                              label: context.localization?.edit ?? '',
                            ),
                            SlidableAction(
                              onPressed: (context) => _doDeleteRecord(data),
                              backgroundColor: AppColors.red500,
                              foregroundColor: Colors.white,
                              label: context.localization?.delete ?? '',
                            ),
                          ],
                        ),
                        child: FoodItemRowWidget(
                          rippleColor: AppColors.white,
                          padding: EdgeInsets.all(8.r),
                          index: index,
                          title: data.name,
                          iconId: data.iconId,
                          subtitle: data.additionalData,
                          onTap: () async {
                            _doEditRecord(data);
                          },
                          onTapAdd: () {
                            // _bloc.add(DoFoodLogEvent(foodRecord: data));
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return 8.verticalSpace;
                    },
                  ),
                ),
              ),
              AppButton(
                buttonText: context.localization?.createNewRecipe,
                appButtonModel: AppButtonStyles.primary,
                onTap: _doCreateNewFood,
              ),
            ],
          ),
        );
      },
    );
  }

  void _fetchUserFoods() {
    // _bloc.add(const FetchUserFoodsEvent());
  }

  Future<void> _doCreateNewFood() async {
    await RecipeCreatorPage.navigate(context: context);
    /*final result = await FoodCreatorPage.navigate(context: context);
    if (result != null && result) {
      _fetchUserFoods();
    }*/
  }

  Future<void> _doEditRecord(FoodRecord foodRecord) async {
    await RecipeCreatorPage.navigate(context: context);
    /*final result = await FoodCreatorPage.navigate(
        context: context, foodRecord: foodRecord, isUpdate: true);
    if (result != null && result) {
      _fetchUserFoods();
    }*/
  }

  void _doDeleteRecord(FoodRecord foodRecord) {
    // _bloc.add(DoDeleteUserFoodEvent(foodRecord: foodRecord));
  }

  void _handleStateChanges(BuildContext context, RecipesState state) {
    /*if (state is ListenerState) {
      switch (state) {
        case FetchUserFoodsListenerState():
          _list = state.data;
          break;
        case LogSuccessState():
          context.showSnackbar(text: context.localization?.itemAddedToDiary);
          break;
      }
    }*/
  }
}
