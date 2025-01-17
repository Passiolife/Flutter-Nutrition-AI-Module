import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../models/take_photo_result_view_model.dart';
import '../widgets/adjust_serving_size.dart';
import '../widgets/edit_nutrition_facts.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/incomplete_food_item_widget.dart';

class FoodItemsListSection extends StatelessWidget {
  const FoodItemsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial || state is ResultsSuccessState;
      },
      builder: (context, state) {
        if (state is! ResultsSuccessState) return const SizedBox.shrink();
        final incompleteFoodItems = state.incompleteFoodRecordsViewModel;
        final foodItems = state.foodRecordsViewModel;
        return Expanded(
          child: Column(
            children: [
              // Incomplete Food Records List
              if (incompleteFoodItems.isNotEmpty)
                ListView.separated(
                  itemCount: incompleteFoodItems.length,
                  padding: AppPadding.pv16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final foodItemModel = incompleteFoodItems.elementAt(index);
                    return IncompleteFoodItemWidget(
                      iconId: foodItemModel.foodRecord.iconId,
                      title: foodItemModel.title,
                      onTap: () {
                        _showEditNutritionFactsDialog(context, foodItemModel);
                      },
                    );
                    return FoodItemWidget(
                      iconId: foodItemModel.foodRecord.iconId,
                      title: foodItemModel.title,
                      subtitle: foodItemModel.subtitle,
                      calories: foodItemModel.foodRecord.totalCalories,
                      carbs: foodItemModel.foodRecord.totalCarbs,
                      protein: foodItemModel.foodRecord.totalProteins,
                      fat: foodItemModel.foodRecord.totalFat,
                      index: index,
                      initialSelection: foodItemModel.isSelected,
                      onChangeSelection: (isSelected) => _onChangeSelection(
                        context: context,
                        index: index,
                        isSelected: isSelected,
                      ),
                      onTap: () => _onTap(
                        context: context,
                        viewModel: foodItemModel,
                        index: index,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return 8.verticalSpace;
                  },
                ),
              // Food Records List
              ListView.separated(
                itemCount: foodItems.length,
                padding: AppPadding.pv16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final foodItemModel = foodItems.elementAt(index);
                  return FoodItemWidget(
                    iconId: foodItemModel.foodRecord.iconId,
                    title: foodItemModel.title,
                    subtitle: foodItemModel.subtitle,
                    calories: foodItemModel.foodRecord.totalCalories,
                    carbs: foodItemModel.foodRecord.totalCarbs,
                    protein: foodItemModel.foodRecord.totalProteins,
                    fat: foodItemModel.foodRecord.totalFat,
                    index: index,
                    initialSelection: foodItemModel.isSelected,
                    onChangeSelection: (isSelected) => _onChangeSelection(
                      context: context,
                      index: index,
                      isSelected: isSelected,
                    ),
                    onTap: () => _onTap(
                      context: context,
                      viewModel: foodItemModel,
                      index: index,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return 8.verticalSpace;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onTap({
    required BuildContext context,
    required FoodRecordViewModel viewModel,
    required int index,
  }) async {
    // Adjust serving size:
    FoodRecord? updatedFoodRecord = await AdjustServingSize.navigate(
      context: context,
      foodRecord: viewModel.foodRecord,
      index: index,
    );
    if (updatedFoodRecord != null && context.mounted) {
      context.read<TakePhotoResultBloc>().add(
          UpdateFoodRecordEvent(index: index, foodRecord: updatedFoodRecord));
    }
  }

  void _onChangeSelection({
    required BuildContext context,
    required int index,
    required bool isSelected,
  }) {
    context.read<TakePhotoResultBloc>().add(
          SelectFoodItemEvent(
            index: index,
            isSelected: isSelected,
          ),
        );
  }

  Future<void> _showEditNutritionFactsDialog(
      BuildContext context, FoodRecordViewModel viewModel) async {
    final foodRecord = viewModel.foodRecord;
    final newFoodRecord = await EditNutritionFacts.navigate(
      context: context,
      foodRecord: foodRecord,
    );
    if (newFoodRecord != null && context.mounted) {
      context
          .read<TakePhotoResultBloc>()
          .add(VerifyMissingDataEvent(foodRecord: newFoodRecord));
    }
    /*if(newFoodRecord!=null) {
      setState(() {
        _foodRecord = newFoodRecord;
      });
    }*/
  }
}
