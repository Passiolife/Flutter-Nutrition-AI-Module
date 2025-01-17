import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/domain/repository/nutrition_ai_repository.dart';
import '../../../common/extension/passio/passio_food_item_extension.dart';
import '../../../common/models/food_record/food_record.dart';

part 'photo_preview_event.dart';
part 'photo_preview_state.dart';

class PhotoPreviewBloc extends Bloc<PhotoPreviewEvent, PhotoPreviewState> {
  final NutritionAIRepository nutritionAIRepository;

  PassioFoodItem? _nutritionFacts;
  PassioFoodItem? _ingredients;
  PassioFoodItem? _finalFoodItem;

  PhotoPreviewBloc({required this.nutritionAIRepository})
      : super(PhotoPreviewInitial()) {
    on<DoProcessEvent>(_handleDoProcessEvent);
  }

  Future<void> _handleDoProcessEvent(
      DoProcessEvent event, Emitter<PhotoPreviewState> emit) async {
    final file = event.file;
    final image = await file.readAsBytes();
    final foodItem = await nutritionAIRepository.recognizeNutritionFacts(image);
    emit(AnalyzeCompletedState(timestamp: DateTime.now().millisecond));
    await Future.delayed(Duration(milliseconds: 500));

    if(foodItem?.hasNutritionFacts ?? false) {
      final foodRecord = FoodRecord.fromPassioFoodItem(foodItem!);
      emit(NutritionFactsFoundState(timestamp: DateTime.now().millisecond, foodRecord: foodRecord));

    } else {
      emit(NutritionFactsNotFoundState(timestamp: DateTime.now().millisecond));
    }
    if (foodItem == null) {
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
    }
  }
}
