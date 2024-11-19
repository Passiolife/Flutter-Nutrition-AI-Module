import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai_module/src/common/constant/app_constants.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../widgets/typedefs.dart';

part 'edit_food_event.dart';
part 'edit_food_state.dart';

class EditFoodBloc extends Bloc<EditFoodEvent, EditFoodState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  FoodRecord? _foodRecord;

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
  }

  FutureOr<void> _handleDoConversionEvent(
      DoConversionEvent event, Emitter<EditFoodState> emit) async {
    emit(const ConversionLoadingState());
    if (event.foodItem != null) {
      _foodRecord = FoodRecord.fromPassioFoodItem(event.foodItem!);
    } else if (event.foodRecordIngredient != null) {
      _foodRecord =
          FoodRecord.fromFoodRecordIngredient(event.foodRecordIngredient!);
    } else if (event.detectedCandidate != null) {
      final foodItem = await NutritionAI.instance
          .fetchFoodItemForPassioID(event.detectedCandidate!.passioID);
      if (foodItem != null) {
        _foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      }
    } else if (event.foodDataInfo != null) {
      PassioFoodItem? foodItem = await NutritionAI.instance
          .fetchFoodItemForDataInfo(event.foodDataInfo!);

      if (foodItem != null) {
        _foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      }

      if (event.shouldUpdateServingUnit) {
        bool hasUnit = _foodRecord?.setSelectedUnit(
                event.foodDataInfo?.nutritionPreview.servingUnit ?? '') ??
            false;
        if (!hasUnit) {
          _foodRecord?.setSelectedUnit('gram');
        }
        _foodRecord?.setSelectedQuantity(hasUnit
            ? event.foodDataInfo?.nutritionPreview.servingQuantity ?? 1
            : event.foodDataInfo?.nutritionPreview.weightQuantity ?? 1);
      }
    } else {
      _foodRecord = event.foodRecord;
    }
    if (_foodRecord != null) {
      _foodRecord?.isFavorite =
          await _connector.favoriteExists(foodRecord: _foodRecord!);
    }
    if (_foodRecord == null) {
      emit(const ConversionFailureState(message: 'Something went wrong.'));
      return;
    }
    if (event.mealLabel != null) {
      _foodRecord?.mealLabel = event.mealLabel;
    }
    _updateSliderData(true);
    emit(ConversionSuccessState(
        foodRecord: _foodRecord, sliderData: _sliderData));
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(
      DoUpdateServingQuantityEvent event, Emitter<EditFoodState> emit) async {
    _foodRecord?.setSelectedQuantity(event.quantity);
    _updateSliderData(event.resetSlider);
    if (_foodRecord != null) {
      emit(UpdateServingQuantitySuccessState(
        quantity: _foodRecord!.getSelectedQuantity(),
        foodRecord: _foodRecord,
        sliderData: _sliderData,
        unit: _foodRecord!.getSelectedUnit(),
      ));
    }
  }

  FutureOr<void> _handleDoUpdateServingUnitEvent(
      DoUpdateServingUnitEvent event, Emitter<EditFoodState> emit) async {
    _foodRecord?.setSelectedUnitKeepWeight(event.unit);
    add(DoUpdateServingQuantityEvent(
        quantity: _foodRecord?.getSelectedQuantity() ?? 1, resetSlider: true));
  }

  FutureOr<void> _handleDoUpdateMealLabelEvent(
      DoUpdateMealLabelEvent event, Emitter<EditFoodState> emit) {
    _foodRecord?.mealLabel = event.mealLabel;
  }

  FutureOr<void> _handleDoUpdateDateEvent(
      DoUpdateDateEvent event, Emitter<EditFoodState> emit) {
    _foodRecord?.setCreatedAt(event.dateTime);
    emit(UpdateDateSuccessState(dateTime: event.dateTime));
  }

  FutureOr<void> _handleDoAddIngredientEvent(
      DoAddIngredientEvent event, Emitter<EditFoodState> emit) async {
    PassioFoodItem? foodItem =
        await NutritionAI.instance.fetchFoodItemForDataInfo(event.searchResult);
    if (foodItem == null) return;
    final ingredientFoodRecord = FoodRecord.fromPassioFoodItem(foodItem);
    _foodRecord?.addIngredient(ingredientFoodRecord,
        index: _foodRecord?.ingredients.length ?? 0);
    add(DoUpdateServingQuantityEvent(
      quantity: _foodRecord?.getSelectedQuantity() ?? 1,
      resetSlider: true,
    ));
  }

  FutureOr<void> _handleDoRemoveIngredientEvent(
      DoRemoveIngredientEvent event, Emitter<EditFoodState> emit) {
    _foodRecord?.removeIngredient(event.index);
    add(DoUpdateServingQuantityEvent(
      quantity: _foodRecord?.getSelectedQuantity() ?? 1,
      resetSlider: true,
    ));
  }

  FutureOr<void> _handleDoReplaceIngredientEvent(
      DoReplaceIngredientEvent event, Emitter<EditFoodState> emit) {
    if (_foodRecord != null) {
      _foodRecord!.replaceIngredient(event.ingredient, event.index);
      add(DoUpdateServingQuantityEvent(
          quantity: _foodRecord?.getSelectedQuantity() ?? 1,
          resetSlider: true));
    }
  }

  FutureOr<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<EditFoodState> emit) async {
    if (_foodRecord != null) {
      await _connector.updateRecord(
          foodRecord: _foodRecord!, isNew: !event.isUpdate);
      emit(const LogSuccessState());
    }
  }

  FutureOr<void> _handleDoFavoriteChangeEvent(
      DoFavoriteChangeEvent event, Emitter<EditFoodState> emit) async {
    if (_foodRecord != null) {
      if (_foodRecord?.isFavorite ?? false) {
        await _connector.deleteFavorite(foodRecord: _foodRecord!);
        _foodRecord?.isFavorite = false;
      } else {
        await _connector.updateFavorite(foodRecord: _foodRecord!, isNew: true);
        _foodRecord?.isFavorite = true;
      }
      emit(FavoriteChangeSuccessState(
          isFavorite: _foodRecord?.isFavorite ?? false));
    }
  }

  Future<void> _handleDoDeleteLogEvent(
      DoDeleteLogEvent event, Emitter<EditFoodState> emit) async {
    if (_foodRecord != null) {
      _connector.deleteRecord(foodRecord: _foodRecord!);
      emit(LogDeleteSuccessState(
          milliseconds: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void _updateSliderData(bool shouldReset) {
    if (shouldReset) {
      final currentValue = _foodRecord?.getSelectedQuantity() ?? 1;
      double maxSlider = _sliderMultiplier;
      if (_cachedMaxForSlider.unit != _foodRecord?.getSelectedUnit()) {
        maxSlider = _sliderMultiplier * max(currentValue, 1);
        _cachedMaxForSlider = (
          unit: _foodRecord?.getSelectedUnit(),
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
            (unit: _foodRecord?.getSelectedUnit(), value: currentValue);
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

    // Extract the ID from foodRecord, using a fallback empty string if sourceId is null.
    final id = foodRecord.sourceId?.replaceFirst(AppCommonConstants.userFoods, '') ?? '';

    // Fetch the user food record based on the extracted ID.
    try {
      final userFoodRecord = await _connector.fetchUserFood(id: id);

      // If user food record retrieval fails, emit a failure state.
      if (userFoodRecord == null) {
        emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
      } else {
        // If successful, emit a success state.
        emit(UserFoodFetchSuccessState(logUpdateOnCreate: event.logUpdateOnCreate, userFoodRecord: userFoodRecord));
      }
    } catch (error) {
      // Catch any unexpected errors and emit a failure state.
      emit(UserFoodFetchFailureState(logUpdateOnCreate: logUpdateOnCreate));
    }
  }

  FutureOr<void> _handleDoUserFoodFlowEvent(DoUserFoodFlowEvent event, Emitter<EditFoodState> emit) async {
    emit(UserFoodFlowState(timeStamp: DateTime.now().millisecondsSinceEpoch));
  }
}
