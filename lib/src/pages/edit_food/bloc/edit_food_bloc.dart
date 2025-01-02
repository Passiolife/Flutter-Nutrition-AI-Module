import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/constant/app_constants.dart';
import '../ui/widgets/typedefs.dart';

part 'edit_food_event.dart';
part 'edit_food_state.dart';

class EditFoodBloc extends Bloc<EditFoodEvent, EditFoodState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  FoodRecord? foodRecord;

  // [_sliderMultiplier] is use to multiply the quantity with [currentValue].
  // So for ex: user selects 100gm then slider should be max up to 500.
  double get _sliderMultiplier => 5.0;

  SliderData _sliderData =
      (minSlider: FoodRecord.zeroQuantity, maxSlider: 1, divisions: 1);

  ({String? unit, double value}) _cachedMaxForSlider = (unit: null, value: 0);

  EditFoodBloc() : super(const EditFoodInitial()) {
    on<DoConversionEvent>(_handleDoConversionEvent);
    on<DoUpdateServingQuantityEvent>(_handleDoUpdateServingSizeEvent);
    on<DoUpdateServingUnitEvent>(_handleDoUpdateServingUnitEvent);
    on<DoUpdateMealLabelEvent>(_handleDoUpdateMealLabelEvent);
    on<DoUpdateDateEvent>(_handleDoUpdateDateEvent);
    on<DoAddIngredientEvent>(_handleDoAddIngredientEvent);
    on<DoRemoveIngredientEvent>(_handleDoRemoveIngredientEvent);
    on<DoReplaceIngredientEvent>(_handleDoReplaceIngredientEvent);
    on<DoFavoriteChangeEvent>(_handleDoFavoriteChangeEvent);
    on<DoLogEvent>(_handleDoLogEvent);
    on<DoDeleteLogEvent>(_handleDoDeleteLogEvent);
    on<DoFetchUserCreatedFoodEvent>(_handleDoFetchUserCreatedFoodEvent);
    on<DoUserFoodFlowEvent>(_handleDoUserFoodFlowEvent);
    on<DoFetchUserCreatedRecipeEvent>(_handleDoFetchUserCreatedRecipeEvent);
  }

  FutureOr<void> _handleDoConversionEvent(
      DoConversionEvent event, Emitter<EditFoodState> emit) async {
    emit(const ConversionLoadingState());
    if (event.foodItem != null) {
      foodRecord = FoodRecord.fromPassioFoodItem(event.foodItem!);
    } else if (event.foodRecordIngredient != null) {
      foodRecord =
          FoodRecord.fromFoodRecordIngredient(event.foodRecordIngredient!);
    } else if (event.detectedCandidate != null) {
      final foodItem = await NutritionAI.instance
          .fetchFoodItemForPassioID(event.detectedCandidate!.passioID);
      if (foodItem != null) {
        foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      }
    } else if (event.foodDataInfo != null) {
      PassioFoodItem? foodItem = await NutritionAI.instance
          .fetchFoodItemForDataInfo(event.foodDataInfo!);

      if (foodItem != null) {
        foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      }

      if (event.shouldUpdateServingUnit) {
        bool hasUnit = foodRecord?.setSelectedUnit(
                event.foodDataInfo?.nutritionPreview.servingUnit ?? '') ??
            false;
        if (!hasUnit) {
          foodRecord?.setSelectedUnit('gram');
        }
        foodRecord?.setSelectedQuantity(hasUnit
            ? event.foodDataInfo?.nutritionPreview.servingQuantity ?? 1
            : event.foodDataInfo?.nutritionPreview.weightQuantity ?? 1);
      }
    } else {
      foodRecord = event.foodRecord;
    }
    if (foodRecord != null) {
      foodRecord?.isFavorite =
          await _connector.favoriteExists(foodRecord: foodRecord!);
    }
    if (foodRecord == null) {
      emit(const ConversionFailureState(message: 'Something went wrong.'));
      return;
    }
    if (event.mealLabel != null) {
      foodRecord?.mealLabel = event.mealLabel;
    }
    if (foodRecord?.getCreatedAt() == null) {
      foodRecord?.logMeal();
    }

    _updateSliderData(true);
    emit(ConversionSuccessState(
        foodRecord: foodRecord, sliderData: _sliderData));
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(
      DoUpdateServingQuantityEvent event, Emitter<EditFoodState> emit) async {
    foodRecord?.setSelectedQuantity(event.quantity);
    _updateSliderData(event.resetSlider);
    if (foodRecord != null) {
      emit(UpdateServingQuantitySuccessState(
        quantity: foodRecord!.getSelectedQuantity(),
        foodRecord: foodRecord,
        sliderData: _sliderData,
        unit: foodRecord!.getSelectedUnit(),
      ));
    }
  }

  FutureOr<void> _handleDoUpdateServingUnitEvent(
      DoUpdateServingUnitEvent event, Emitter<EditFoodState> emit) async {
    foodRecord?.setSelectedUnitKeepWeight(event.unit);
    add(DoUpdateServingQuantityEvent(
        quantity: foodRecord?.getSelectedQuantity() ?? 1, resetSlider: true));
  }

  FutureOr<void> _handleDoUpdateMealLabelEvent(
      DoUpdateMealLabelEvent event, Emitter<EditFoodState> emit) {
    foodRecord?.mealLabel = event.mealLabel;
  }

  FutureOr<void> _handleDoUpdateDateEvent(
      DoUpdateDateEvent event, Emitter<EditFoodState> emit) {
    foodRecord?.setCreatedAt(event.dateTime);
    emit(UpdateDateSuccessState(dateTime: event.dateTime));
  }

  FutureOr<void> _handleDoAddIngredientEvent(
      DoAddIngredientEvent event, Emitter<EditFoodState> emit) async {
    PassioFoodItem? foodItem =
        await NutritionAI.instance.fetchFoodItemForDataInfo(event.searchResult);
    if (foodItem == null) return;
    final ingredientFoodRecord = FoodRecord.fromPassioFoodItem(foodItem);
    foodRecord?.addIngredient(ingredientFoodRecord,
        index: foodRecord?.ingredients.length ?? 0);
    add(DoUpdateServingQuantityEvent(
      quantity: foodRecord?.getSelectedQuantity() ?? 1,
      resetSlider: true,
    ));
  }

  FutureOr<void> _handleDoRemoveIngredientEvent(
      DoRemoveIngredientEvent event, Emitter<EditFoodState> emit) {
    foodRecord?.removeIngredient(event.index);
    add(DoUpdateServingQuantityEvent(
      quantity: foodRecord?.getSelectedQuantity() ?? 1,
      resetSlider: true,
    ));
  }

  FutureOr<void> _handleDoReplaceIngredientEvent(
      DoReplaceIngredientEvent event, Emitter<EditFoodState> emit) {
    if (foodRecord != null) {
      foodRecord!.replaceIngredient(event.ingredient, event.index);
      add(DoUpdateServingQuantityEvent(
        quantity: foodRecord?.getSelectedQuantity() ?? 1,
        resetSlider: true,
      ));
    }
  }

  FutureOr<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<EditFoodState> emit) async {
    if (foodRecord != null) {
      await _connector.updateRecord(
          foodRecord: foodRecord!, isNew: !event.isUpdate);
      emit(const LogSuccessState());
    }
  }

  FutureOr<void> _handleDoFavoriteChangeEvent(
      DoFavoriteChangeEvent event, Emitter<EditFoodState> emit) async {
    if (foodRecord != null) {
      if (foodRecord?.isFavorite ?? false) {
        await _connector.deleteFavorite(foodRecord: foodRecord!);
        foodRecord?.isFavorite = false;
      } else {
        final cloneRecord = foodRecord?..removeMeal();
        await _connector.updateFavorite(foodRecord: cloneRecord!, isNew: true);
        foodRecord?.isFavorite = true;
      }
      emit(FavoriteChangeSuccessState(
          isFavorite: foodRecord?.isFavorite ?? false));
    }
  }

  Future<void> _handleDoDeleteLogEvent(
      DoDeleteLogEvent event, Emitter<EditFoodState> emit) async {
    if (foodRecord != null) {
      _connector.deleteRecord(foodRecord: foodRecord!);
      emit(LogDeleteSuccessState(
          milliseconds: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void _updateSliderData(bool shouldReset) {
    if (shouldReset) {
      final currentValue = foodRecord?.getSelectedQuantity() ?? 1;
      double maxSlider = _sliderMultiplier;
      if (_cachedMaxForSlider.unit != foodRecord?.getSelectedUnit()) {
        maxSlider = _sliderMultiplier * max(currentValue, 1);
        _cachedMaxForSlider = (
          unit: foodRecord?.getSelectedUnit(),
          value: maxSlider,
        );
      } else if (_cachedMaxForSlider.value > _sliderMultiplier &&
          _cachedMaxForSlider.value > currentValue) {
        maxSlider = _cachedMaxForSlider.value;
      } else if (_sliderMultiplier > currentValue) {
        maxSlider = _sliderMultiplier;
      } else {
        maxSlider = currentValue;
        _cachedMaxForSlider =
            (unit: foodRecord?.getSelectedUnit(), value: currentValue);
      }

      if (maxSlider >= 500) {
        maxSlider = (maxSlider / 10).ceilToDouble() * 10;
      } else {
        maxSlider = maxSlider.ceilToDouble();
      }
      _sliderData = (
        minSlider: _sliderData.minSlider,
        maxSlider: maxSlider,
        divisions: switch (maxSlider) {
          < 10 => (maxSlider / 0.5).round(),
          < 500 => (maxSlider / 1).round(),
          _ => (maxSlider / 10).round(),
        },
      );
    }
  }

  FutureOr<void> _handleDoFetchUserCreatedFoodEvent(
      DoFetchUserCreatedFoodEvent event, Emitter<EditFoodState> emit) async {
    // Check if the provided foodRecord is null; if so, emit a failure state.
    final foodRecord = event.foodRecord;
    final logUpdateOnCreate = event.logUpdateOnCreate;

    if (foodRecord == null) {
      emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
      return;
    }

    final id = foodRecord.refCode.replaceFirst(AppCommonConstants.userFood, '');

    // Fetch the user food record based on the extracted ID.
    try {
      final userFoodRecord = await _connector.fetchUserFood(id: id);

      // If user food record retrieval fails, emit a failure state.
      if (userFoodRecord == null) {
        emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
      } else {
        // If successful, emit a success state.
        emit(UserFoodFetchSuccessState(
            logUpdateOnCreate: event.logUpdateOnCreate,
            userFoodRecord: userFoodRecord));
      }
    } catch (error) {
      // Catch any unexpected errors and emit a failure state.
      emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
    }
  }

  FutureOr<void> _handleDoUserFoodFlowEvent(
      DoUserFoodFlowEvent event, Emitter<EditFoodState> emit) async {
    emit(UserFoodFlowState(timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

  FutureOr<void> _handleDoFetchUserCreatedRecipeEvent(
      DoFetchUserCreatedRecipeEvent event, Emitter<EditFoodState> emit) async {
    // Check if the provided foodRecord is null; if so, emit a failure state.
    final foodRecord = event.foodRecord;
    final logUpdateOnCreate = event.logUpdateOnCreate;

    if (foodRecord == null) {
      emit(UserRecipeFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
      return;
    }

    final id = foodRecord.recipeIdFromRefCode;

    // Fetch the user food record based on the extracted ID.
    try {
      final userFoodRecord = await _connector.fetchUserRecipe(id: id);

      // If user food record retrieval fails, emit a failure state.
      if (userFoodRecord == null) {
        emit(UserRecipeFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
      } else {
        // If successful, emit a success state.
        emit(UserRecipeFetchSuccessState(
          logUpdateOnCreate: event.logUpdateOnCreate,
          userRecipeRecord: userFoodRecord,
        ));
      }
    } catch (error) {
      // Catch any unexpected errors and emit a failure state.
      emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
    }
  }
}
