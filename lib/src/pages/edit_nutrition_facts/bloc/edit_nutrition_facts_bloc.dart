import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/domain/use_cases/custom_food/create_custom_food_ingredient_use_case.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/helper/custom_food_helper.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/double_extensions.dart';

part 'edit_nutrition_facts_event.dart';
part 'edit_nutrition_facts_state.dart';

class EditNutritionFactsBloc
    extends Bloc<EditNutritionFactsEvent, EditNutritionFactsState> {
  CreateCustomFoodIngredientUseCase createCustomFoodIngredientUseCase;

  FoodRecord? foodRecord;
  FoodRecord? barcodeFoodRecord;

  String? _id;

  // Details
  String? _iconId;
  String? _name = '';
  String? _barcode;
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

  bool get isUpdate => _id.isNotNullOrEmpty;

  EditNutritionFactsBloc({
    required this.createCustomFoodIngredientUseCase,
  }) : super(const EditNutritionFactsInitial()) {
    on<ProcessEvent>(_handleProcessEvent);

    on<RefreshDetailsEvent>(_handleRefreshDetailsEvent);
    on<RefreshNutritionFactsEvent>(_handleRefreshNutritionFactsEvent);
    on<RefreshPortionsEvent>(_handleRefreshPortionsEvent);
    on<RefreshActionButtonsEvent>(_handleRefreshActionButtonsEvent);

    on<UpdateNameEvent>(_handleUpdateNameEvent);
    on<UpdateBarcodeEvent>(_handleUpdateBarcodeEvent);
    on<UpdateNutritionFactsEvent>(_handleUpdateNutritionFactsEvent);
    on<UpdatePortionsEvent>(_handleUpdatePortionsEvent);

    on<PopulateBarcodeScannerDataEvent>(_handlePopulateBarcodeScannerDataEvent);

    on<SaveEvent>(_handleSaveEvent);
  }

  void _handleProcessEvent(
      ProcessEvent event, Emitter<EditNutritionFactsState> emit) {
    foodRecord = event.foodRecord?.clone() ?? foodRecord;
    barcodeFoodRecord =
        event.barcodeFoodRecord?.clone() ?? barcodeFoodRecord;

    _id = barcodeFoodRecord?.id ?? foodRecord?.id;

    _iconId = barcodeFoodRecord?.iconId ?? foodRecord?.iconId;
    _barcode = barcodeFoodRecord?.barcode ?? foodRecord?.barcode ?? event.barcode;
    _name = barcodeFoodRecord?.name ?? foodRecord?.name;
    _imageBytes = event.imageBytes;

    _calories = barcodeFoodRecord?.totalCaloriesOptional ?? foodRecord?.totalCaloriesOptional;
    _carbs = barcodeFoodRecord?.totalCarbsOptional ?? foodRecord?.totalCarbsOptional;
    _protein = barcodeFoodRecord?.totalProteinsOptional ?? foodRecord?.totalProteinsOptional;
    _fat = barcodeFoodRecord?.totalFatOptional ?? foodRecord?.totalFatOptional;

    _selectedQuantity = barcodeFoodRecord?.getSelectedQuantity() ?? foodRecord?.getSelectedQuantity();
    _selectedUnit =
        barcodeFoodRecord?.getSelectedUnit() ?? foodRecord?.getSelectedUnit() ?? CustomFoodHelper.defaultServingUnit;
    _units = CustomFoodHelper.getServingUnitNames(unit: _selectedUnit);
    _weight = barcodeFoodRecord?.computedWeight.value ?? foodRecord?.computedWeight.value;

    add(const RefreshDetailsEvent());
    add(const RefreshNutritionFactsEvent());
    add(const RefreshPortionsEvent());
    add(const RefreshActionButtonsEvent());
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

  void _handlePopulateBarcodeScannerDataEvent(
      PopulateBarcodeScannerDataEvent event,
      Emitter<EditNutritionFactsState> emit) async {
    final data = event.data;
    if (data == null) return;
    if (data is String) {
      add(UpdateBarcodeEvent(barcode: data));
    } else if (data is FoodRecord) {
      Uint8List? imageBytes;
      if (data.iconId.isNullOrEmpty) {
        imageBytes = _imageBytes;
      }
      add(ProcessEvent(barcodeFoodRecord: data, imageBytes: imageBytes));
    } else {
      return;
    }
  }

  void _handleRefreshActionButtonsEvent(RefreshActionButtonsEvent event,
      Emitter<EditNutritionFactsState> emit) async {
    emit(RefreshActionButtonsState(isUpdate: isUpdate));
  }

  void _handleSaveEvent(
      SaveEvent event, Emitter<EditNutritionFactsState> emit) async {
    if ((barcodeFoodRecord != null && foodRecord == barcodeFoodRecord) ||
        (_name == foodRecord?.name &&
            _barcode == foodRecord?.barcode &&
            _calories == foodRecord?.totalCaloriesOptional?.parseFormatted(places: 2) &&
            _carbs == foodRecord?.totalCarbsOptional?.parseFormatted(places: 2) &&
            _protein == foodRecord?.totalProteinsOptional?.parseFormatted(places: 2) &&
            _fat == foodRecord?.totalFatOptional?.parseFormatted(places: 2) &&
            _selectedQuantity == foodRecord?.getSelectedQuantity() &&
            _selectedUnit == foodRecord?.getSelectedUnit() &&
            _weight == foodRecord?.computedWeight.value)) {
      emit(SaveSuccessState(foodRecord: foodRecord));
      return;
    }

    final foodRecordIngredient = foodRecord?.ingredients.firstOrNull;

    final updatedIngredient = await createCustomFoodIngredientUseCase.call(
      ingredient: foodRecordIngredient,
      id: _id,
      name: _name,
      iconId: _imageBytes == null ? _iconId : null,
      selectedQuantity: _selectedQuantity,
      selectedUnit: _selectedUnit,
      servingWeight: _weight,
      barcode: _barcode,
      calories: _calories,
      carbs: _carbs,
      proteins: _protein,
      fat: _fat,
    );

    final newFoodRecord =
        FoodRecord.fromFoodRecordIngredient(updatedIngredient);
    emit(SaveSuccessState(foodRecord: newFoodRecord));
  }
}
