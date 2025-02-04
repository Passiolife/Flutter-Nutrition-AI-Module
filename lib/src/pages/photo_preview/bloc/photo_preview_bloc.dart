import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/domain/repository/food_log_repositoy.dart';
import '../../../common/domain/repository/nutrition_ai_repository.dart';
import '../../../common/domain/use_cases/custom_food/save_custom_food_use_case.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/extension/passio/passio_food_item_extension.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/image_utility/image_utility.dart';

part 'photo_preview_event.dart';
part 'photo_preview_state.dart';

class PhotoPreviewBloc extends Bloc<PhotoPreviewEvent, PhotoPreviewState> {
  final NutritionAIRepository nutritionAIRepository;
  final ImageUtility imageUtility;
  final AddCustomFoodUseCase addCustomFoodUseCase;
  final FoodLogRepository foodLogRepository;

  PhotoPreviewBloc({
    required this.nutritionAIRepository,
    required this.addCustomFoodUseCase,
    required this.foodLogRepository,
    required this.imageUtility,
  }) : super(PhotoPreviewInitial()) {
    on<DoProcessEvent>(_handleDoProcessEvent);

    on<SaveEvent>(_handleSaveEvent);
  }

  Future<void> _handleDoProcessEvent(
      DoProcessEvent event, Emitter<PhotoPreviewState> emit) async {
    final file = event.file;
    final image = await file.readAsBytes();
    final foodItem = await nutritionAIRepository.recognizeNutritionFacts(image);
    emit(AnalyzeCompletedState(timestamp: DateTime.now().millisecond));
    await Future.delayed(Duration(milliseconds: 500));

    // Image resizing
    final resizedImageBytes = await imageUtility.resizeToUint8List(file);

    if (foodItem?.hasNutritionFacts ?? false) {
      final foodRecord = FoodRecord.fromPassioFoodItem(foodItem!);
      emit(NutritionFactsFoundState(
        timestamp: DateTime.now().millisecond,
        foodRecord: foodRecord,
        imageBytes: resizedImageBytes,
      ));
    } else {
      emit(NutritionFactsNotFoundState(
          timestamp: DateTime.now().millisecond,
          imageBytes: resizedImageBytes));
    }
    /*if (foodItem == null) {
      emit(FailedToAnalyzedState(timestamp: DateTime.now().millisecond));
      return;
    } else if(foodItem.hasMacros) {
      if(foodItem.hasIngredientsDescription) {
        _finalFoodItem = foodItem;
        return;
      }
      _nutritionFacts = foodItem;

    } else if(foodItem.hasIngredientsDescription) {
      _ingredients = foodItem;
    }
    if (_nutritionFacts == null && _ingredients == null) {
      emit(BothNotFoundState(timestamp: DateTime.now().millisecond));
    } else if (_nutritionFacts == null) {
      emit(NutritionFactsNotFoundState(timestamp: DateTime.now().millisecond));
    } else if (_ingredients == null) {
      emit(IngredientsNotFoundState(timestamp: DateTime.now().millisecond));
    }*/
  }

  void _handleSaveEvent(
      SaveEvent event, Emitter<PhotoPreviewState> emit) async {
    final foodRecord = event.foodRecord;
    final imageBytes = event.imageBytes;

    final bool isUpdate = foodRecord.id.isNotNullOrEmpty;

    final userFoodId =  await addCustomFoodUseCase.call(
      foodRecord: foodRecord,
      isNew: !isUpdate,
      image: imageBytes,
    );

    /*if(isUpdate) {

      // results = await Future.wait([
      //   customFoodRepository.updateFood(foodRecord: foodRecord, isNew: false),
      // ]);
    } else {
      results = await Future.wait([
        customFoodRepository.updateFood(foodRecord: foodRecord, isNew: true),
        if (imageBytes != null)
          customFoodRepository.addFoodImage(
            id: foodRecord.iconId,
            image: imageBytes,
          ),
      ]);
    }*/

    // final userFoodId = results.first as String;

    foodRecord.refCode = '${FoodRecord.userFoodPrefix}$userFoodId';

    await foodLogRepository.addFoodLog(foodRecord: foodRecord);

    emit(const SaveSuccessState());
  }
}
