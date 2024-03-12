import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

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
    on<DoConversionEvent>(_handleDoFoodItemToFoodRecordConversionEvent);
    on<DoUpdateServingQuantityEvent>(_handleDoUpdateServingSizeEvent);
    on<DoUpdateServingUnitEvent>(_handleDoUpdateServingUnitEvent);
    on<DoUpdateMealLabelEvent>(_handleDoUpdateMealLabelEvent);
    on<DoUpdateDateEvent>(_handleDoUpdateDateEvent);
    on<DoAddIngredientEvent>(_handleDoAddIngredientEvent);
    on<DoRemoveIngredientEvent>(_handleDoRemoveIngredientEvent);
    on<DoReplaceIngredientEvent>(_handleDoReplaceIngredientEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  FutureOr<void> _handleDoFoodItemToFoodRecordConversionEvent(
      DoConversionEvent event, Emitter<EditFoodState> emit) {
    if (event.foodItem != null) {
      _foodRecord = FoodRecord.fromPassioFoodItem(event.foodItem!);
    } else if (event.foodRecordIngredient != null) {
      _foodRecord =
          FoodRecord.fromFoodRecordIngredient(event.foodRecordIngredient!);
    } else {
      _foodRecord = event.foodRecord;
    }
    if (_foodRecord == null) return null;
    _updateSliderData(true);
    emit(ConversionSuccessState(
        foodRecord: _foodRecord, sliderData: _sliderData));
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(
      DoUpdateServingQuantityEvent event, Emitter<EditFoodState> emit) async {
    _foodRecord?.setSelectedQuantity(event.quantity);
    _updateSliderData(event.resetSlider);
    emit(UpdateServingQuantitySuccessState(
      quantity: event.quantity,
      foodRecord: _foodRecord,
      sliderData: _sliderData,
    ));
  }

  FutureOr<void> _handleDoUpdateServingUnitEvent(
      DoUpdateServingUnitEvent event, Emitter<EditFoodState> emit) async {
    _foodRecord?.setSelectedUnitKeepWeight(event.unit);
    add(DoUpdateServingQuantityEvent(quantity: _foodRecord?.getSelectedQuantity() ?? 1, resetSlider: true));
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
    final ingredientFoodRecord = FoodRecord.fromPassioFoodItem(event.foodItem);
    _foodRecord?.addIngredient(ingredientFoodRecord, index: _foodRecord?.ingredients.length ?? 0);
    add(DoUpdateServingQuantityEvent(quantity: _foodRecord?.getSelectedQuantity() ?? 1, resetSlider: true));
    // emit(AddIngredientSuccessState(
    //     ingredientsCount: _foodRecord?.ingredients.length ?? 0));
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
        maxSlider = maxSlider.roundToDouble();
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

  FutureOr<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<EditFoodState> emit) async {
    if (_foodRecord != null) {
      _connector.updateRecord(foodRecord: _foodRecord!, isNew: true);
      emit(LogSuccessState());
    }
  }

  FutureOr<void> _handleDoRemoveIngredientEvent(
      DoRemoveIngredientEvent event, Emitter<EditFoodState> emit) {
    _foodRecord?.ingredients.remove(event.ingredient);
    emit(RemoveIngredientSuccessState(
        ingredientsCount: _foodRecord?.ingredients.length ?? 0));
  }

  FutureOr<void> _handleDoReplaceIngredientEvent(
      DoReplaceIngredientEvent event, Emitter<EditFoodState> emit) {
    if (_foodRecord != null) {
      _foodRecord!.replaceIngredient(event.ingredient, event.index);
      emit(ReplaceIngredientSuccessState(
          ingredient: _foodRecord!.ingredients.elementAt(event.index)));
    }
  }
}
