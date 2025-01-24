import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../common/domain/repository/custom_food_repository.dart';
import '../../../../common/domain/repository/food_log_repositoy.dart';
import '../../../../common/extension/null_safety_extension.dart';
import '../../../../common/helper/custom_food_helper.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/models/food_record/food_record_ingredient.dart';
import '../../../../common/util/double_extensions.dart';

part 'edit_nutrition_facts_event.dart';
part 'edit_nutrition_facts_state.dart';

class EditNutritionFactsBloc
    extends Bloc<EditNutritionFactsEvent, EditNutritionFactsState> {
  FoodLogRepository foodLogRepository;
  CustomFoodRepository customFoodRepository;

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

  EditNutritionFactsBloc({
    required this.foodLogRepository,
    required this.customFoodRepository,
  }) : super(const EditNutritionFactsInitial()) {
    on<ProcessEvent>(_handleProcessEvent);

    on<RefreshDetailsEvent>(_handleRefreshDetailsEvent);
    on<RefreshNutritionFactsEvent>(_handleRefreshNutritionFactsEvent);
    on<RefreshPortionsEvent>(_handleRefreshPortionsEvent);

    on<UpdateNameEvent>(_handleUpdateNameEvent);
    on<UpdateBarcodeEvent>(_handleUpdateBarcodeEvent);
    on<UpdateNutritionFactsEvent>(_handleUpdateNutritionFactsEvent);
    on<UpdatePortionsEvent>(_handleUpdatePortionsEvent);

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
    _selectedUnit =
        _foodRecord?.getSelectedUnit() ?? CustomFoodHelper.defaultServingUnit;
    _units = _foodRecord?.servingUnits.map((e) => e.unitName).toList() ?? [];
    _units?.addAll(CustomFoodHelper.getDefaultServingUnits()
        .where((element) => !_units!.contains(element.unitName))
        .map((e) => e.unitName));
    _weight = _foodRecord?.computedWeight.value;

    add(const RefreshDetailsEvent());
    add(const RefreshNutritionFactsEvent());
    add(const RefreshPortionsEvent());
  }

  void _handleRefreshDetailsEvent(
      RefreshDetailsEvent event, Emitter<EditNutritionFactsState> emit) async {
    emit(RefreshDetailsState(
      iconId: _iconId,
      barcode: _barcode,
      name: _name,
      imageBytes: _imageBytes,
    ));
  }

  void _handleRefreshNutritionFactsEvent(
      RefreshNutritionFactsEvent event, Emitter<EditNutritionFactsState> emit) {
    emit(RefreshNutritionFactsState(
      calories: _calories?.let((it) => it.format(places: 2)) ?? '',
      carbs: _carbs?.let((it) => it.format(places: 2)) ?? '',
      protein: _protein?.let((it) => it.format(places: 2)) ?? '',
      fat: _fat?.let((it) => it.format(places: 2)) ?? '',
    ));
  }

  void _handleUpdateNutritionFactsEvent(
      UpdateNutritionFactsEvent event, Emitter<EditNutritionFactsState> emit) {
    if (event.calories != null) {
      _calories = event.calories;
    }
    if (event.carbs != null) {
      _carbs = event.carbs;
    }
    if (event.protein != null) {
      _protein = event.protein;
    }
    if (event.fat != null) {
      _fat = event.fat;
    }
  }

  void _handleRefreshPortionsEvent(
      RefreshPortionsEvent event, Emitter<EditNutritionFactsState> emit) {
    emit(RefreshPortionsState(
      selectedQuantity:
          _selectedQuantity?.let((it) => it.format(places: 2)) ?? '',
      selectedUnit: _selectedUnit,
      units: _units,
      weight: _weight?.let((it) => it.format(places: 2)) ?? '',
    ));
  }

  void _handleUpdatePortionsEvent(
      UpdatePortionsEvent event, Emitter<EditNutritionFactsState> emit) {
    if (event.quantity != null) {
      _selectedQuantity = event.quantity;
    }
    if (event.unit != null) {
      _selectedUnit = event.unit;
    }
    if (event.weight != null) {
      _weight = event.weight;
    }
  }

  void _handleUpdateNameEvent(
      UpdateNameEvent event, Emitter<EditNutritionFactsState> emit) async {
    _name = event.name;
  }

  void _handleUpdateBarcodeEvent(
      UpdateBarcodeEvent event, Emitter<EditNutritionFactsState> emit) async {
    _barcode = event.barcode;
    add(const RefreshDetailsEvent());
  }

  void _handleSaveEvent(
      SaveEvent event, Emitter<EditNutritionFactsState> emit) async {
    try {
      final foodRecordIngredient = _foodRecord?.ingredients.firstOrNull;

      final calories = UnitEnergy(_calories!, UnitEnergyType.kilocalories);
      final carbs = UnitMass(_carbs!, UnitMassType.grams);
      final proteins = UnitMass(_protein!, UnitMassType.grams);
      final fat = UnitMass(_fat!, UnitMassType.grams);
      final weight = UnitMass(_weight!, UnitMassType.grams);

      return;

      final nutrients = PassioNutrients.fromNutrients(
        weight: weight,
        alcohol: foodRecordIngredient?.referenceNutrients.alcohol,
        calcium: foodRecordIngredient?.referenceNutrients.calcium,
        calories: calories,
        carbs: carbs,
        cholesterol: foodRecordIngredient?.referenceNutrients.cholesterol,
        chromium: foodRecordIngredient?.referenceNutrients.chromium,
        fat: fat,
        fibers: foodRecordIngredient?.referenceNutrients.fibers,
        folicAcid: foodRecordIngredient?.referenceNutrients.folicAcid,
        iodine: foodRecordIngredient?.referenceNutrients.iodine,
        iron: foodRecordIngredient?.referenceNutrients.iron,
        magnesium: foodRecordIngredient?.referenceNutrients.magnesium,
        monounsaturatedFat:
            foodRecordIngredient?.referenceNutrients.monounsaturatedFat,
        phosphorus: foodRecordIngredient?.referenceNutrients.phosphorus,
        polyunsaturatedFat:
            foodRecordIngredient?.referenceNutrients.polyunsaturatedFat,
        potassium: foodRecordIngredient?.referenceNutrients.potassium,
        proteins: proteins,
        satFat: foodRecordIngredient?.referenceNutrients.satFat,
        selenium: foodRecordIngredient?.referenceNutrients.selenium,
        sodium: foodRecordIngredient?.referenceNutrients.sodium,
        sugars: foodRecordIngredient?.referenceNutrients.sugars,
        sugarsAdded: foodRecordIngredient?.referenceNutrients.sugarsAdded,
        sugarAlcohol: foodRecordIngredient?.referenceNutrients.sugarAlcohol,
        transFat: foodRecordIngredient?.referenceNutrients.transFat,
        vitaminA: foodRecordIngredient?.referenceNutrients.vitaminA,
        vitaminB6: foodRecordIngredient?.referenceNutrients.vitaminB6,
        vitaminB12: foodRecordIngredient?.referenceNutrients.vitaminB12,
        vitaminB12Added:
            foodRecordIngredient?.referenceNutrients.vitaminB12Added,
        vitaminC: foodRecordIngredient?.referenceNutrients.vitaminC,
        vitaminD: foodRecordIngredient?.referenceNutrients.vitaminD,
        vitaminE: foodRecordIngredient?.referenceNutrients.vitaminE,
        vitaminEAdded: foodRecordIngredient?.referenceNutrients.vitaminEAdded,
        vitaminKDihydrophylloquinone: foodRecordIngredient
            ?.referenceNutrients.vitaminKDihydrophylloquinone,
        vitaminKMenaquinone4:
            foodRecordIngredient?.referenceNutrients.vitaminKMenaquinone4,
        vitaminKPhylloquinone:
            foodRecordIngredient?.referenceNutrients.vitaminKPhylloquinone,
        vitaminARAE: foodRecordIngredient?.referenceNutrients.vitaminARAE,
        zinc: foodRecordIngredient?.referenceNutrients.zinc,
      );

      final ingredient = FoodRecordIngredient.fromCustomData(
        id: _foodRecord?.id ?? '',
        nutrients: nutrients,
        name: _name!,
        iconId: CustomFoodHelper.generateIconId(),
        servingUnits: CustomFoodHelper.generateCustomServingUnits(
            _selectedUnit!, _weight!),
        servingSizes: [],
        selectedQuantity: _selectedQuantity!,
        selectedUnit: _selectedUnit!,
        barcode: _barcode,
      );

      final foodRecord = FoodRecord.fromFoodRecordIngredient(ingredient);

      final results = await Future.wait([
        customFoodRepository.addFood(foodRecord: foodRecord),
        customFoodRepository.addFoodImage(
          id: foodRecord.iconId,
          image: _imageBytes!,
        ),
      ]);

      final userFoodId = results.first as String;

      foodRecord.refCode = '${FoodRecord.userFoodPrefix}$userFoodId';

      await foodLogRepository.addFoodLog(foodRecord: foodRecord);

      emit(const SaveSuccessState());
    } catch (e) {
      log(e.toString());
    }
    // FoodRecord? updatedFoodRecord = _foodRecord?.clone();
    // if (updatedFoodRecord == null) {
    // } else {
    //   FoodRecordIngredient foodRecordIngredient =
    //       FoodRecordIngredient.fromNutrientsWithDefaults(nutrients);
    //   foodRecordIngredient.initializeFoodRecord(
    //       newName: _name,
    //       newBarcode: _barcode,
    //       selectedQuantity: _selectedQuantity!,
    //       selectedUnit: _selectedUnit!,
    //       newServingUnits: updatedFoodRecord.servingUnits);
    //   foodRecordIngredient =
    //       foodRecordIngredient.updateWeight(weight: _weight!);
    //   updatedFoodRecord =
    //       FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);
    //   print(updatedFoodRecord);
    //   /*if (_name?.isNotNullOrEmpty == true) {
    //     updatedFoodRecord = updatedFoodRecord?.updateName(name: _name!);
    //   }
    //   if (_barcode?.isNotNullOrEmpty == true) {
    //     updatedFoodRecord = updatedFoodRecord?.updateBarcode(barcode: _barcode);
    //   }*/
    // }
  }
}
