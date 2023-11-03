import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../models/food_record/food_record.dart';
import '../../../util/double_extensions.dart';
import '../../../util/string_extensions.dart';

part 'food_details_event.dart';

part 'food_details_state.dart';

/// [SliderData] use to get callbacks of slider.
typedef SliderData = ({double sliderMax, double sliderMin, double sliderStep, double sliderValue});

class FoodDetailsBloc extends Bloc<EditFoodEvent, EditFoodState> {
  // [cachedMaxForSlider] stores the max value for the slider.
  ({String? unit, double value}) _cachedMaxForSlider = (unit: null, value: 0);
  final double minSliderValue = 0.00001;

  /// [_sliderMultiplier] is use to multiply the quantity with [currentValue].
  /// So for ex: user selects 100gm then slider should be max up to 500.
  final double _sliderMultiplier = 5.0;

  /// Here define the [_maxSliderFromData] value.
  /// It is sliderMultiplier * 1.0. So, the value is 5.0.
  double get _maxSliderFromData => 1.0 * _sliderMultiplier;

  /// [_sliderMaximumValue] contains the maximum value for the slider.
  double _sliderMaximumValue = 0;

  double get sliderMaximumValue => _sliderMaximumValue;

  set sliderMaximumValue(double value) {
    if (value < 500) {
      _sliderMaximumValue = value;
    } else {
      _sliderMaximumValue = (value / 10).ceilToDouble() * 10;
    }
  }

  /// [_sliderStep] contains the value for the stepping into the slider.
  double _sliderStep = 1;

  FoodDetailsBloc() : super(EditFoodInitial()) {
    on<DoUpdateUnitKeepWeightEvent>(_handleDoUpdateUnitKeepWeightEvent);
    on<DoUpdateQuantityEvent>(_handleDoUpdateQuantityEvent);
    on<DoUpdateServingSizeEvent>(_handleDoUpdateServingSizeEvent);
    on<DoSliderUpdateEvent>(_handleDoSliderUpdateEvent);
    on<DoAlternateEvent>(_handleDoAlternateEvent);
    on<DoUpdateAmountEditableEvent>(_handleDoUpdateAmountEditableEvent);
  }

  FutureOr<void> _handleDoUpdateQuantityEvent(DoUpdateQuantityEvent event, Emitter<EditFoodState> emit) {
    double currentValue = event.updatedQuantity.roundNumber(2) == 0 ? minSliderValue : event.updatedQuantity.roundNumber(2);
    event.data?.setFoodRecordServing(event.data?.selectedUnit ?? '', currentValue);
    add(DoSliderUpdateEvent(data: event.data, shouldReset: event.shouldReset));
  }

  FutureOr<void> _handleDoSliderUpdateEvent(DoSliderUpdateEvent event, Emitter<EditFoodState> emit) async {
    SliderData sliderData = _updateSliderData(event.data, event.shouldReset);
    emit(SliderUpdateState(sliderData: sliderData));
  }

  SliderData _updateSliderData(FoodRecord? foodRecord, bool shouldReset) {
    /// currentValue is the [selectedQuantity]. If it is null then set it 1.0.
    double currentValue = max(foodRecord?.selectedQuantity ?? 1, minSliderValue);

    if (shouldReset) {
      if (_cachedMaxForSlider.unit != foodRecord?.selectedUnit) {
        sliderMaximumValue = _sliderMultiplier * max(currentValue, 1);
        _cachedMaxForSlider = (unit: foodRecord?.selectedUnit, value: sliderMaximumValue);
      } else if (_cachedMaxForSlider.value > _maxSliderFromData && _cachedMaxForSlider.value > currentValue) {
        sliderMaximumValue = _cachedMaxForSlider.value;
      } else if (_maxSliderFromData > currentValue) {
        sliderMaximumValue = _maxSliderFromData;
      } else {
        sliderMaximumValue = currentValue;
        _cachedMaxForSlider = (unit: foodRecord?.selectedUnit, value: currentValue);
      }

      // Here, rounding the number.
      if (_sliderMaximumValue >= 500) {
        // Here rounding up number to the closest to 10.
        // for ex: 175 then it will be 180 and 201 then it will be 210.
        _sliderMaximumValue = (_sliderMaximumValue / 10).ceilToDouble() * 10;
      } else {
        _sliderMaximumValue = _sliderMaximumValue.roundToDouble();
      }
      // Here calculating the slider steps.
      _sliderStep = switch (sliderMaximumValue) {
        < 10 => sliderMaximumValue / 0.5,
        < 500 => sliderMaximumValue / 1,
        _ => sliderMaximumValue / 10,
      };
    }

    return (sliderValue: currentValue, sliderStep: _sliderStep, sliderMin: minSliderValue, sliderMax: sliderMaximumValue);
  }

  Future _handleDoAlternateEvent(DoAlternateEvent event, Emitter<EditFoodState> emit) async {
    if (event.passioID?.isNotNullOrEmpty ?? false) {
      final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.passioID!);
      final foodData = FoodRecord.from(passioIDAttributes: attributes);
      emit(AlternateSuccessState(data: foodData));
    }
  }

  FutureOr<void> _handleDoUpdateUnitKeepWeightEvent(DoUpdateUnitKeepWeightEvent event, Emitter<EditFoodState> emit) async {
    event.data?.setSelectedUnitKeepWeight(event.selectedUnitName);
    add(DoSliderUpdateEvent(data: event.data, shouldReset: true));
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(DoUpdateServingSizeEvent event, Emitter<EditFoodState> emit) {
    event.data?.setFoodRecordServing(event.updatedUnitName ?? '', event.updatedQuantity ?? 0);
    add(DoSliderUpdateEvent(data: event.data, shouldReset: true));
  }

  FutureOr<void> _handleDoUpdateAmountEditableEvent(DoUpdateAmountEditableEvent event, Emitter<EditFoodState> emit) {
    emit(UpdateAmountEditableState(isEditable: event.isEditable));
  }
}
