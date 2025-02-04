import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/string_extensions.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../adjust_serving_size/adjust_serving_size_page.dart';
import '../../../../edit_nutrition_facts/edit_nutrition_facts_page.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../models/take_photo_result_view_model.dart';
import '../widgets/barcode_not_found_widget.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/missing_data_widget.dart';

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
                    _showEditNutritionFactsDialog(
                        context: context,
                        viewModel: foodItemModel,
                        index: index,
                        initialValidate: true);
                  },
                );
              } else if(foodItemModel.hasMissingData) {
                return MissingDataWidget(
                  image: foodItemModel.image,
                  iconId: foodItemModel.foodRecord.iconId,
                  title: foodItemModel.title,
                  onTap: () {
                    _showEditNutritionFactsDialog(
                        context: context,
                        viewModel: foodItemModel,
                        index: index,
                        initialValidate: true);
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
        Navigator.pop(context);
        _showEditNutritionFactsDialog(
          context: context,
          viewModel: viewModel,
          index: index,
        );
      },
    );
    if (newFoodRecord != null &&
        newFoodRecord != viewModel.foodRecord &&
        context.mounted) {
      context
          .read<TakePhotoResultBloc>()
          .add(UpdateFoodRecordEvent(index: index, foodRecord: newFoodRecord));
    }
  }

  Future<void> _showEditNutritionFactsDialog({
    required BuildContext context,
    required FoodRecordViewModel viewModel,
    required int index,
    bool initialValidate = false,
  }) async {
    final Uint8List? image = viewModel.image;
    final newFoodRecord = await EditNutritionFactsPage.navigate(
      context: context,
      index: index,
      foodRecord: viewModel.foodRecord,
      imageBytes: image,
      shouldReturnOnSave: true,
      initialValidate: initialValidate,
      positiveButtonText: viewModel.foodRecord.id.isNotNullOrEmpty
          ? context.localization.update
          : context.localization.save,
    );
    if (newFoodRecord != null &&
        newFoodRecord != viewModel.foodRecord &&
        context.mounted) {
      context.read<TakePhotoResultBloc>().add(CreateCustomFoodEvent(
          index: index, foodRecord: newFoodRecord, image: image));
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
}
