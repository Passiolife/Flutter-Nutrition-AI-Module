import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/router/routes.dart';
import '../../../../adjust_serving_size/adjust_serving_size_page.dart';
import '../../../../edit_nutrition_facts/edit_nutrition_facts_page.dart';
import '../../../../food_search/models/food_selection_result.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../models/take_photo_result_view_model.dart';
import '../widgets/barcode_not_found_widget.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/image_not_found_widget.dart';
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
              final foodRecord = foodItemModel.foodRecord;
              final image = foodItemModel.image;

              if (foodRecord == null) {
                return ImageNotFoundWidget(
                  image: image,
                  onTap: () => _onTapNotRecognized(context: context, index: index),
                );
              } else if (foodItemModel.isBarcodeNotFound) {
                return BarcodeNotFoundWidget(
                  image: image,
                  iconId: foodRecord.iconId,
                  onTap: () {
                    _showEditNutritionFactsDialog(
                        context: context,
                        viewModel: foodItemModel,
                        index: index,
                        initialValidate: true);
                  },
                );
              } else if (foodItemModel.hasMissingData) {
                return MissingDataWidget(
                  image: image,
                  iconId: foodRecord.iconId,
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
                image: image,
                iconId: foodRecord.iconId,
                title: foodItemModel.title,
                subtitle: foodItemModel.subtitle,
                calories: foodRecord.totalCalories,
                carbs: foodRecord.totalCarbs,
                protein: foodRecord.totalProteins,
                fat: foodRecord.totalFat,
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

  Future<void> _onTapNotRecognized({
    required BuildContext context,
    required int index,
  }) async {
    final data = await Navigator.pushNamed(context, Routes.foodSearch);
    if (data != null && data is FoodSelectionResult && context.mounted) {
      context.read<TakePhotoResultBloc>().add(UpdateNotRecognizedFoodEvent(
            foodDataInfo: data.foodDataInfo,
            foodRecord: data.foodRecord,
            index: index,
          ));
    }
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
    final foodRecord = viewModel.foodRecord;
    if (foodRecord == null) return;
    final FoodRecord? newFoodRecord = await AdjustServingSizePage.navigate(
      context: context,
      index: index,
      foodRecord: foodRecord,
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
        newFoodRecord != foodRecord &&
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
      positiveButtonText: viewModel.isSaved
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
