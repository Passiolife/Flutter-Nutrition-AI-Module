import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../common/extension/null_safety_extension.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/models/food_record/food_record_ingredient.dart';
import '../../../../common/util/double_extensions.dart';

part 'edit_nutrition_facts_event.dart';
part 'edit_nutrition_facts_state.dart';

class EditNutritionFactsBloc
    extends Bloc<EditNutritionFactsEvent, EditNutritionFactsState> {
  FoodRecord? _foodRecord;

  // Details
  String? _iconId = '';
  String? _name = '';
  String? _barcode = '';
  Uint8List? _imageBytes;

  // Nutrition Facts
  double? _calories;
  double? _carbs;
  double? _protein;
  double? _fat;

  // Portions
  double? _selectedQuantity;
  String? _selectedUnit;
  List<String>? _units;
  double? _weight;

  EditNutritionFactsBloc() : super(EditNutritionFactsInitial()) {
    on<ProcessEvent>(_handleProcessEvent);
    on<UpdateDetailsEvent>(_handleUpdateDetailsEvent);
    on<UpdateNutritionFactsEvent>(_handleUpdateNutritionFactsEvent);
    on<UpdatePortionsEvent>(_handleUpdatePortionsEvent);
    on<UpdateNameEvent>(_handleUpdateNameEvent);
    on<UpdateBarcodeEvent>(_handleUpdateBarcodeEvent);
    on<SaveEvent>(_handleSaveEvent);
  }

  void _handleProcessEvent(
      ProcessEvent event, Emitter<EditNutritionFactsState> emit) {
    _foodRecord = event.foodRecord;

    _iconId = _foodRecord?.iconId;
    _barcode = _foodRecord?.barcode ?? event.barcode ?? '';
    _name = _foodRecord?.name;
    _imageBytes = event.imageBytes;

    _calories = _foodRecord?.totalCaloriesOptional;
    _carbs = _foodRecord?.totalCarbsOptional;
    _protein = _foodRecord?.totalProteinsOptional;
    _fat = _foodRecord?.totalFatOptional;

    _selectedQuantity = _foodRecord?.getSelectedQuantity();
    _selectedUnit = _foodRecord?.getSelectedUnit();
    _units = _foodRecord?.servingUnits.map((e) => e.unitName).toList();
    _weight = _foodRecord?.computedWeight.value;

    add(const UpdateDetailsEvent());
    add(const UpdateNutritionFactsEvent());
    add(UpdatePortionsEvent());
  }

  void _handleUpdateDetailsEvent(
      UpdateDetailsEvent event, Emitter<EditNutritionFactsState> emit) async {
    emit(UpdateDetailsState(
      iconId: _iconId,
      barcode: _barcode,
      name: _name,
      imageBytes: _imageBytes,
    ));
  }

  void _handleUpdateNutritionFactsEvent(
      UpdateNutritionFactsEvent event, Emitter<EditNutritionFactsState> emit) {
    emit(UpdateNutritionFactsState(
      calories: _calories?.let((it) => it.format(places: 2)) ?? '',
      carbs: _carbs?.let((it) => it.format(places: 2)) ?? '',
      protein: _protein?.let((it) => it.format(places: 2)) ?? '',
      fat: _fat?.let((it) => it.format(places: 2)) ?? '',
    ));
  }

  void _handleUpdatePortionsEvent(
      UpdatePortionsEvent event, Emitter<EditNutritionFactsState> emit) {
    emit(UpdatePortionsState(
      selectedQuantity:
          _selectedQuantity?.let((it) => it.format(places: 2)) ?? '',
      selectedUnit: _selectedUnit,
      units: _units,
      weight: _weight?.let((it) => it.format(places: 2)) ?? '',
    ));
  }

  void _handleUpdateNameEvent(
      UpdateNameEvent event, Emitter<EditNutritionFactsState> emit) async {
    _name = event.name;
  }

  void _handleUpdateBarcodeEvent(
      UpdateBarcodeEvent event, Emitter<EditNutritionFactsState> emit) async {
    _barcode = event.barcode;
    add(UpdateDetailsEvent());
  }

  void _handleSaveEvent(
      SaveEvent event, Emitter<EditNutritionFactsState> emit) async {
    FoodRecord? updatedFoodRecord = _foodRecord?.clone();
    if (_foodRecord == null) {
    } else {
      final calories = UnitEnergy(_calories!, UnitEnergyType.kilocalories);
      final carbs = UnitMass(_carbs!, UnitMassType.grams);
      final proteins = UnitMass(_protein!, UnitMassType.grams);
      final fat = UnitMass(_fat!, UnitMassType.grams);
      final weight = UnitMass(_weight!, UnitMassType.grams);

      final nutrients = PassioNutrients.fromNutrients(
        weight: weight,
        calories: calories,
        carbs: carbs,
        proteins: proteins,
        fat: fat,
      );
      FoodRecordIngredient foodRecordIngredient =
          FoodRecordIngredient.fromNutrientsWithDefaults(nutrients);
      foodRecordIngredient.initializeFoodRecord(
        newName: _name,
        newBarcode: _barcode,
        selectedQuantity: _selectedQuantity!,
        selectedUnit: _selectedUnit!,
      );
      foodRecordIngredient.updateWeight(weight: _weight!);
      print(foodRecordIngredient);
      /*if (_name?.isNotNullOrEmpty == true) {
        updatedFoodRecord = updatedFoodRecord?.updateName(name: _name!);
      }
      if (_barcode?.isNotNullOrEmpty == true) {
        updatedFoodRecord = updatedFoodRecord?.updateBarcode(barcode: _barcode);
      }*/
    }
  }
}
