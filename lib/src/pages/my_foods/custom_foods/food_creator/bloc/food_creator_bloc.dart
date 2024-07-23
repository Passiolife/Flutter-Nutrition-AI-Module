import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/util/flutter_image_compress_util.dart';
import '../../../../../common/util/unit_extension.dart';
import '../models/nutrient.dart';

part 'food_creator_event.dart';
part 'food_creator_state.dart';

class FoodCreatorBloc extends Bloc<FoodCreatorEvent, FoodCreatorState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  Uint8List? _image;
  Uint8List? _resizedImage;
  String? _name;
  String? _brand;
  String? _barcode;

  double? _servingQuantity;
  String? _servingUnit;
  double? _weightValue;
  String? _weightSymbol;
  Unit? _calories;
  Unit? _fat;
  Unit? _carbs;
  Unit? _protein;

  Nutrient? _satFat;
  Nutrient? _transFat;
  Nutrient? _cholesterol;
  Nutrient? _sodium;
  Nutrient? _dietaryFiber;
  Nutrient? _totalSugars;
  Nutrient? _addedSugars;
  Nutrient? _vitaminD;
  Nutrient? _calcium;
  Nutrient? _potassium;

  // final FoodCreatorModel _model = FoodCreatorModel();

  bool get _saveEnabled {
    // Check if name is not empty
    final bool isNameNotEmpty = _name?.isNotEmpty ?? false;

    // Check if serving quantity and unit are not null
    final bool isServingQuantityNotNull =
        _servingQuantity != null && _servingQuantity != 0;
    final bool isServingUnitNotNull = _servingUnit?.isNotEmpty ?? false;

    // Pending: Get the localization for gram and ml
    const gram = 'gram';
    const ml = 'ml';

    // Check if serving unit is not gram or ml and if so, ensure weight value and unit are not null
    final bool isWeightValid = (_servingUnit != gram && _servingUnit != ml)
        ? _weightValue != null && _weightSymbol != null
        : true;

    final calories = _calories != null;
    final fat = _fat != null;
    final carbs = _carbs != null;
    final protein = _protein != null;

    return isNameNotEmpty &&
        isServingQuantityNotNull &&
        isServingUnitNotNull &&
        isWeightValid &&
        calories &&
        fat &&
        carbs &&
        protein;
  }

  FoodCreatorBloc() : super(FoodCreatorInitial()) {
    on<DoUpdateFoodDetailsEvent>(_handleDoUpdateFoodDetailsEvent);
    on<DoUpdateBarcodeEvent>(_handleDoUpdateBarcodeEvent);
    on<DoUpdateRequiredNutritionFactsEvent>(
        _handleDoUpdateRequiredNutritionFactsEvent);
    on<DoUpdateOtherNutritionFactsEvent>(
        _handleDoUpdateOtherNutritionFactsEvent);
    on<DoSaveEvent>(_handleDoSaveEvent);
  }

  FutureOr<void> _handleDoUpdateFoodDetailsEvent(
      DoUpdateFoodDetailsEvent event, Emitter<FoodCreatorState> emit) async {
    if (_image != event.image) {
      _image = event.image;
      if (_image != null) {
        _resizedImage = await FlutterImageCompressUtil.compressWithList(
          _image!,
          minWidth: 200,
          minHeight: 200,
        );
      }
    }
    _name = event.name;
    _brand = event.brand;

    emit(UpdateSaveListenerState(saveEnabled: _saveEnabled));
    emit(const UpdateSaveBuilderState());
  }

  FutureOr<void> _handleDoUpdateBarcodeEvent(
      DoUpdateBarcodeEvent event, Emitter<FoodCreatorState> emit) async {
    _barcode = event.barcode;
    emit(UpdateSaveListenerState(saveEnabled: _saveEnabled));
    emit(const UpdateSaveBuilderState());
  }

  FutureOr<void> _handleDoUpdateRequiredNutritionFactsEvent(
      DoUpdateRequiredNutritionFactsEvent event,
      Emitter<FoodCreatorState> emit) async {
    _servingQuantity = event.servingQuantity;
    _servingUnit = event.servingUnit;
    _weightValue = event.weightValue;
    _weightSymbol = event.weightSymbol;
    _calories = event.calories;
    _fat = event.fat;
    _carbs = event.carbs;
    _protein = event.protein;

    emit(UpdateSaveListenerState(saveEnabled: _saveEnabled));
    emit(const UpdateSaveBuilderState());
  }

  FutureOr<void> _handleDoUpdateOtherNutritionFactsEvent(
      DoUpdateOtherNutritionFactsEvent event,
      Emitter<FoodCreatorState> emit) async {
    _satFat = event.satFat;
    _transFat = event.transFat;
    _cholesterol = event.cholesterol;
    _sodium = event.sodium;
    _dietaryFiber = event.dietaryFiber;
    _totalSugars = event.totalSugars;
    _addedSugars = event.addedSugars;
    _vitaminD = event.vitaminD;
    _calcium = event.calcium;
    _potassium = event.potassium;

    emit(UpdateSaveListenerState(saveEnabled: _saveEnabled));
    emit(const UpdateSaveBuilderState());
  }

  FutureOr<void> _handleDoSaveEvent(
      DoSaveEvent event, Emitter<FoodCreatorState> emit) async {
    try {
      // Create a list of serving sizes with a default serving unit if not provided
      final servingSizes = [
        PassioServingSize(_servingQuantity ?? 1, _servingUnit ?? '')
      ];

      // _weightValue ??= 100 / (_servingQuantity ?? 1);

      double servingWeightValue;
      // Create a serving weight with a default value of 100 grams if not provided
      if (_servingUnit?.toLowerCase() != 'gram' &&
          _servingUnit?.toLowerCase() != 'ml') {
        servingWeightValue = (_weightValue ?? 1) / (_servingQuantity ?? 1);
      } else {
        servingWeightValue = 1;
      }

      UnitMass servingWeight = UnitMass(
        servingWeightValue,
        (_weightSymbol == 'ml' || _servingUnit?.toLowerCase() == 'ml')
            ? UnitMassType.milliliter
            : UnitMassType.grams,
      );

      // Create a list of serving units with the serving weight and a default serving unit if not provided
      final servingUnits = [
        PassioServingUnit(_servingUnit ?? '', servingWeight),
        PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
      ];

      // Create a food amount object with the selected quantity, unit, serving sizes, and serving units
      final amount = PassioFoodAmount(
        selectedQuantity: _servingQuantity ?? 1,
        selectedUnit: _servingUnit ?? '',
        servingSizes: servingSizes,
        servingUnits: servingUnits,
      );

      // Create a food metadata object with the barcode
      final metadata = PassioFoodMetadata(barcode: _barcode);

      // Define a reference unit of 100 grams for nutrient conversion
      final targetUnit = UnitMass(100, UnitMassType.grams);
      final currentUnit =
          UnitMass(_weightValue ?? _servingQuantity ?? 1, UnitMassType.grams);

      // Convert nutrients based on the reference unit and serving weight
      final referenceNutrients = PassioNutrients.fromNutrients(
        calories:
            _calories?.convertBasedOn(targetUnit, currentUnit) as UnitEnergy?,
        fat: _fat?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        carbs: _carbs?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        proteins:
            _protein?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        satFat: _satFat?.toUnitMass()?.convertBasedOn(targetUnit, currentUnit)
            as UnitMass?,
        transFat: _transFat
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        cholesterol: _cholesterol
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        sodium: _sodium?.toUnitMass()?.convertBasedOn(targetUnit, currentUnit)
            as UnitMass?,
        fibers: _dietaryFiber
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        sugars: _totalSugars
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        sugarsAdded: _addedSugars
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        vitaminD: _vitaminD
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
        calcium: _calcium?.toUnitMass()?.convertBasedOn(targetUnit, currentUnit)
            as UnitMass?,
        potassium: _potassium
            ?.toUnitMass()
            ?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      );

      final isNew = !event.isUpdate;

      final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      final passioId = event.oldFoodRecord?.passioID ?? uniqueId;

      final String baseIconId = isNew
          ? '${AppCommonConstants.userFoods}$uniqueId'
          : event.oldFoodRecord?.iconId ?? '';
      final iconId = _image == null
          ? (event.oldFoodRecord?.iconId ?? baseIconId)
          : baseIconId;

      // Create an ingredient object with the amount, metadata, name, and reference nutrients
      final ingredient = PassioIngredient(
          amount: amount,
          iconId: iconId,
          id: passioId,
          metadata: metadata,
          name: _name ?? '',
          refCode: '',
          referenceNutrients: referenceNutrients);

      // Create a food record ingredient from the Passio ingredient and add additional data
      final foodRecordIngredient =
          FoodRecordIngredient.fromPassioIngredient(ingredient);
      foodRecordIngredient.id = event.oldFoodRecord?.id ?? '';
      foodRecordIngredient.additionalData = _brand ?? '';

      // Create a food record from the food record ingredient
      final foodRecord =
          FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);

      if (foodRecord.iconId.startsWith(AppCommonConstants.userFoods) &&
          _image != null) {
        _resizedImage ??= (await rootBundle.load(AppImages.imgMyFoodsThumbnail))
            .buffer
            .asUint8List();
        await _connector.updateUserFoodImage(
          id: foodRecord.iconId,
          image: _resizedImage!,
          isNew: isNew,
        );
      }
      await _connector.updateUserFood(foodRecord: foodRecord, isNew: isNew);

      // Emit a success state
      emit(const SaveSuccessState());
    } on Exception catch (e) {
      // Emit a failure state with the error message if an exception occurs
      emit(SaveFailureState(message: e.toString()));
    }
  }
}
