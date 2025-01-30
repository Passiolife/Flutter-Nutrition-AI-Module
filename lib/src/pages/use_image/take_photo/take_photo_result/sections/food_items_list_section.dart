import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/string_extensions.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/util/show_widget_util.dart';
import '../../../../../common/widgets/item_added_to_diary_widget.dart';
import '../../../../adjust_serving_size/adjust_serving_size_page.dart';
import '../../../../edit_nutrition_facts/edit_nutrition_facts_page.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../models/take_photo_result_view_model.dart';
import '../widgets/barcode_not_found_widget.dart';
import '../widgets/custom_food_created_widget.dart';
import '../widgets/food_item_widget.dart';

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
        final foodItems = state.foodRecordsViewModel;
        return Expanded(
          child: ListView.separated(
            itemCount: foodItems.length,
            padding: AppPadding.pv16,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final foodItemModel = foodItems.elementAt(index);
              if (foodItemModel.isBarcodeNotFound) {
                return BarcodeNotFoundWidget(
                  image: foodItemModel.image,
                  iconId: foodItemModel.foodRecord.iconId,
                  onTap: () {
                    // _showAddedToDiaryDialog(context);
                    // _showEditNutritionFactsDialog(context, foodItemModel);
                  },
                );
              }
              return FoodItemWidget(
                image: foodItemModel.image,
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
        );
        return Expanded(
          child: Column(
            children: [
              /*// Incomplete Food Records List
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
                ),*/
              // Food Records List
              Expanded(
                child: ListView.separated(
                  itemCount: foodItems.length,
                  padding: AppPadding.pv16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final foodItemModel = foodItems.elementAt(index);
                    return FoodItemWidget(
                      image: foodItemModel.image,
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
    _showAdjustServingSize(
      context: context,
      viewModel: viewModel,
      index: index,
    );
    /*Navigator.pushNamed(
      context,
      Routes.adjustServingSize,
      arguments: {
        AppCommonConstants.data: viewModel.foodRecord,
        AppCommonConstants.index: index,
        AppCommonConstants.image: viewModel.image,
      },
    );*/

    /*// Adjust serving size:
    FoodRecord? updatedFoodRecord = await AdjustServingSize.navigate(
      context: context,
      foodRecord: viewModel.foodRecord,
      image: viewModel.image,
      index: index,
    );
    if (updatedFoodRecord != null && context.mounted) {
      context.read<TakePhotoResultBloc>().add(
          UpdateFoodRecordEvent(index: index, foodRecord: updatedFoodRecord));
    }*/
  }

  Future<void> _showAdjustServingSize({
    required BuildContext context,
    required FoodRecordViewModel viewModel,
    required int index,
  }) async {
    final FoodRecord? newFoodRecord = await AdjustServingSizePage.navigate(
      context: context,
      index: index,
      foodRecord: viewModel.foodRecord,
      image: viewModel.image,
      onTapEditing: () {
        _showEditNutritionFactsDialog(
          context: context,
          viewModel: viewModel,
          index: index,
        );
      },
    );
    if (newFoodRecord != null && context.mounted) {
      context
          .read<TakePhotoResultBloc>()
          .add(UpdateFoodRecordEvent(index: index, foodRecord: newFoodRecord));
    }
  }

  Future<void> _showEditNutritionFactsDialog({
    required BuildContext context,
    required FoodRecordViewModel viewModel,
    required int index,
  }) async {
    final newFoodRecord = await EditNutritionFactsPage.navigate(
      context: context,
      index: index,
      foodRecord: viewModel.foodRecord,
      imageBytes: viewModel.image,
      shouldReturnOnSave: true,
    );
    if (newFoodRecord != null && newFoodRecord != viewModel.foodRecord && context.mounted) {
      Navigator.pop(context);
      context
          .read<TakePhotoResultBloc>()
          .add(UpdateFoodRecordEvent(index: index, foodRecord: newFoodRecord));
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

  /*Future<void> _showEditNutritionFactsDialog(
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
    */ /*if(newFoodRecord!=null) {
      setState(() {
        _foodRecord = newFoodRecord;
      });
    }*/ /*
  }*/

  void _showCustomFoodCreatedDialog(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CustomFoodCreatedWidget();
      },
    );
  }

  void _showAddedToDiaryDialog(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialog(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        return ItemAddedToDiaryWidget(
          title: '5 Items Added To Diary\n1 Custom Food Created',
          subtitle: context.localization.viewYourDiaryOrAddMore,
          positiveText: context.localization.addMore.toUpperCaseWord,
        );
      },
    );
  }
}
