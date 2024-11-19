import 'dart:typed_data';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_common_constants.dart';
import '../../../../../common/util/unit_extension.dart';
import 'nutrient_view_model.dart';

class FoodCreatorViewModel {
  final String id;
  final String refCode;
  final String passioID;
  final String iconId;
  final String name;
  final String additionalData;
  final double servingQuantity;
  final String servingUnit;
  final double weightValue;
  final String weightSymbol;
  final String? barcode;
  final Unit? calories;
  final Unit? fat;
  final Unit? carbs;
  final Unit? protein;
  final Unit? satFat;
  final Unit? transFat;
  final Unit? cholesterol;
  final Unit? sodium;
  final Unit? dietaryFiber;
  final Unit? totalSugars;
  final Unit? addedSugars;
  final Unit? vitaminD;
  final Unit? calcium;
  final Unit? potassium;
  final Uint8List? image;

  static String get _uniqueId =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static String get _uniqueIconId =>
      '${AppCommonConstants.userFoods}$_uniqueId';

  const FoodCreatorViewModel._({
    required this.id,
    required this.refCode,
    required this.passioID,
    required this.iconId,
    required this.name,
    required this.additionalData,
    required this.servingQuantity,
    required this.servingUnit,
    required this.weightValue,
    required this.weightSymbol,
    this.barcode,
    this.calories,
    this.fat,
    this.carbs,
    this.protein,
    this.satFat,
    this.transFat,
    this.cholesterol,
    this.sodium,
    this.dietaryFiber,
    this.totalSugars,
    this.addedSugars,
    this.vitaminD,
    this.calcium,
    this.potassium,
    this.image,
  });

  factory FoodCreatorViewModel.fromFoodRecord(
    FoodRecord foodRecord, {
    bool setIdToEmpty = false,
    bool setIconIdToEmpty = false,
  }) {
    final iconId =
        foodRecord.iconId.isEmpty ? _uniqueIconId : foodRecord.iconId;

    return FoodCreatorViewModel._(
      id: setIdToEmpty ? '' : foodRecord.id,
      refCode: foodRecord.refCode,
      passioID: foodRecord.passioID,
      iconId: setIconIdToEmpty ? '' : foodRecord.iconId,
      name: foodRecord.name,
      additionalData: foodRecord.additionalData,
      barcode: foodRecord.barcode,
      servingQuantity: foodRecord.getSelectedQuantity(),
      servingUnit: foodRecord.getSelectedUnit(),
      weightValue: foodRecord.computedWeight.value,
      weightSymbol: foodRecord.computedWeight.symbol,
      calories: foodRecord.nutrientsSelectedSize().calories,
      fat: foodRecord.nutrientsSelectedSize().fat,
      carbs: foodRecord.nutrientsSelectedSize().carbs,
      protein: foodRecord.nutrientsSelectedSize().proteins,
      satFat: foodRecord.nutrientsSelectedSize().satFat,
      transFat: foodRecord.nutrientsSelectedSize().transFat,
      cholesterol: foodRecord.nutrientsSelectedSize().cholesterol,
      sodium: foodRecord.nutrientsSelectedSize().sodium,
      dietaryFiber: foodRecord.nutrientsSelectedSize().fibers,
      totalSugars: foodRecord.nutrientsSelectedSize().sugars,
      addedSugars: foodRecord.nutrientsSelectedSize().sugarsAdded,
      vitaminD: foodRecord.nutrientsSelectedSize().vitaminD,
      calcium: foodRecord.nutrientsSelectedSize().calcium,
      potassium: foodRecord.nutrientsSelectedSize().potassium,
    );
  }

  factory FoodCreatorViewModel.empty() {
    return FoodCreatorViewModel._(
      id: '',
      refCode: '',
      passioID: '',
      iconId: '',
      name: '',
      additionalData: '',
      barcode: '',
      servingQuantity: 0,
      servingUnit: '',
      weightValue: 0,
      weightSymbol: '',
      calories: null,
      fat: null,
      carbs: null,
      protein: null,
      satFat: null,
      transFat: null,
      cholesterol: null,
      sodium: null,
      dietaryFiber: null,
      totalSugars: null,
      addedSugars: null,
      vitaminD: null,
      calcium: null,
      potassium: null,
    );
  }

  FoodCreatorViewModel copyWith({
    String? id,
    String? refCode,
    String? passioID,
    String? iconId,
    String? name,
    String? additionalData,
    String? barcode,
    double? servingQuantity,
    String? servingUnit,
    double? weightValue,
    String? weightSymbol,
    Unit? calories,
    Unit? fat,
    Unit? carbs,
    Unit? protein,
    Unit? satFat,
    Unit? transFat,
    Unit? cholesterol,
    Unit? sodium,
    Unit? dietaryFiber,
    Unit? totalSugars,
    Unit? addedSugars,
    Unit? vitaminD,
    Unit? calcium,
    Unit? potassium,
    Uint8List? image,
  }) {
    return FoodCreatorViewModel._(
      id: id ?? this.id,
      refCode: refCode ?? this.refCode,
      passioID: passioID ?? this.passioID,
      iconId: iconId ?? this.iconId,
      name: name ?? this.name,
      additionalData: additionalData ?? this.additionalData,
      barcode: barcode ?? this.barcode,
      servingQuantity: servingQuantity ?? this.servingQuantity,
      servingUnit: servingUnit ?? this.servingUnit,
      weightValue: weightValue ?? this.weightValue,
      weightSymbol: weightSymbol ?? this.weightSymbol,
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      satFat: satFat ?? this.satFat,
      transFat: transFat ?? this.transFat,
      cholesterol: cholesterol ?? this.cholesterol,
      sodium: sodium ?? this.sodium,
      dietaryFiber: dietaryFiber ?? this.dietaryFiber,
      totalSugars: totalSugars ?? this.totalSugars,
      addedSugars: addedSugars ?? this.addedSugars,
      vitaminD: vitaminD ?? this.vitaminD,
      calcium: calcium ?? this.calcium,
      potassium: potassium ?? this.potassium,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodCreatorViewModel &&
        other.iconId == iconId &&
        other.name == name &&
        other.additionalData == additionalData &&
        other.barcode == barcode &&
        other.servingQuantity == servingQuantity &&
        other.servingUnit == servingUnit &&
        other.weightValue == weightValue &&
        other.weightSymbol == weightSymbol &&
        other.calories == calories &&
        other.fat == fat &&
        other.carbs == carbs &&
        other.protein == protein &&
        other.satFat == satFat &&
        other.transFat == transFat &&
        other.cholesterol == cholesterol &&
        other.sodium == sodium &&
        other.dietaryFiber == dietaryFiber &&
        other.totalSugars == totalSugars &&
        other.addedSugars == addedSugars &&
        other.vitaminD == vitaminD &&
        other.calcium == calcium &&
        other.potassium == potassium;
  }

  @override
  int get hashCode {
    return iconId.hashCode ^
        name.hashCode ^
        additionalData.hashCode ^
        barcode.hashCode ^
        servingQuantity.hashCode ^
        servingUnit.hashCode ^
        weightValue.hashCode ^
        weightSymbol.hashCode ^
        calories.hashCode ^
        fat.hashCode ^
        carbs.hashCode ^
        protein.hashCode ^
        satFat.hashCode ^
        transFat.hashCode ^
        cholesterol.hashCode ^
        sodium.hashCode ^
        dietaryFiber.hashCode ^
        totalSugars.hashCode ^
        addedSugars.hashCode ^
        vitaminD.hashCode ^
        calcium.hashCode ^
        potassium.hashCode;
  }

  FoodCreatorViewModel updateFoodDetails({
    Uint8List? newImage,
    String? newName,
    String? newAdditionalData,
  }) {
    return copyWith(
      image: newImage ?? image,
      name: newName ?? name,
      additionalData: newAdditionalData ?? additionalData,
    );
  }

  FoodCreatorViewModel updateBarcode(String? newBarcode) {
    return copyWith(barcode: newBarcode);
  }

  FoodCreatorViewModel updateRequiredNutritionFacts({
    double? newServingQuantity,
    String? newServingUnit,
    double? newWeightValue,
    String? newWeightSymbol,
    Unit? newCalories,
    Unit? newFat,
    Unit? newCarbs,
    Unit? newProtein,
  }) {
    return copyWith(
      servingQuantity: newServingQuantity,
      servingUnit: newServingUnit,
      weightValue: newWeightValue,
      weightSymbol: newWeightSymbol,
      calories: newCalories,
      fat: newFat,
      carbs: newCarbs,
      protein: newProtein,
    );
  }

  FoodCreatorViewModel updateOtherNutritionFacts({
    NutrientViewModel? newSatFat,
    NutrientViewModel? newTransFat,
    NutrientViewModel? newCholesterol,
    NutrientViewModel? newSodium,
    NutrientViewModel? newDietaryFiber,
    NutrientViewModel? newTotalSugars,
    NutrientViewModel? newAddedSugars,
    NutrientViewModel? newVitaminD,
    NutrientViewModel? newCalcium,
    NutrientViewModel? newPotassium,
  }) {
    return copyWith(
      satFat: newSatFat?.toUnitMass(),
      transFat: newTransFat?.toUnitMass(),
      cholesterol: newCholesterol?.toUnitMass(),
      sodium: newSodium?.toUnitMass(),
      dietaryFiber: newDietaryFiber?.toUnitMass(),
      totalSugars: newTotalSugars?.toUnitMass(),
      addedSugars: newAddedSugars?.toUnitMass(),
      vitaminD: newVitaminD?.toUnitMass(),
      calcium: newCalcium?.toUnitMass(),
      potassium: newPotassium?.toUnitMass(),
    );
  }

  bool get validate {
    final bool isNameNotEmpty = name.isNotEmpty;
    final bool isServingQuantityNotNull = servingQuantity != 0;
    final bool isServingUnitNotNull = servingUnit.isNotEmpty;

    const gram = 'gram';
    const ml = 'ml';

    // Check if serving unit is not gram or ml and if so, ensure weight value and unit are not null
    final bool isWeightValid = (servingUnit != gram && servingUnit != ml)
        ? weightValue != 0 && weightSymbol.isNotEmpty
        : true;

    final caloriesValid = calories != null;
    final fatValid = fat != null;
    final carbsValid = carbs != null;
    final proteinValid = protein != null;

    return isNameNotEmpty &&
        isServingQuantityNotNull &&
        isServingUnitNotNull &&
        isWeightValid &&
        caloriesValid &&
        fatValid &&
        carbsValid &&
        proteinValid;
  }

  FoodRecord toFoodRecord() {
    // Create a list of serving sizes with a default serving unit if not provided
    final servingSizes = [PassioServingSize(servingQuantity, servingUnit)];

    double servingWeightValue;
    // Create a serving weight with a default value of 100 grams if not provided
    if (servingUnit.toLowerCase() != 'gram' &&
        servingUnit.toLowerCase() != 'ml') {
      servingWeightValue = weightValue / servingQuantity;
    } else {
      servingWeightValue = 1;
    }

    UnitMass servingWeight = UnitMass(
      servingWeightValue,
      (weightSymbol == 'ml' || servingUnit.toLowerCase() == 'ml')
          ? UnitMassType.milliliter
          : UnitMassType.grams,
    );

    // Create a list of serving units with the serving weight and a default serving unit if not provided
    final servingUnits = [
      PassioServingUnit(servingUnit, servingWeight),
      PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
    ];

    // Create a food amount object with the selected quantity, unit, serving sizes, and serving units
    final amount = PassioFoodAmount(
      selectedQuantity: servingQuantity,
      selectedUnit: servingUnit,
      servingSizes: servingSizes,
      servingUnits: servingUnits,
    );

    // Create a food metadata object with the barcode
    final metadata = PassioFoodMetadata(barcode: barcode);

    // Define a reference unit of 100 grams for nutrient conversion
    final targetUnit = UnitMass(100, UnitMassType.grams);
    final currentUnit = UnitMass(weightValue, UnitMassType.grams);

    final referenceNutrients = PassioNutrients.fromNutrients(
      calories:
          calories?.convertBasedOn(targetUnit, currentUnit) as UnitEnergy?,
      fat: fat?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      carbs: carbs?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      proteins: protein?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      satFat: satFat?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      transFat: transFat?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      cholesterol:
          cholesterol?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      sodium: sodium?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      fibers:
          dietaryFiber?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      sugars: totalSugars?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      sugarsAdded:
          addedSugars?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      vitaminD: vitaminD?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      calcium: calcium?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
      potassium:
          potassium?.convertBasedOn(targetUnit, currentUnit) as UnitMass?,
    );

    final passioId = passioID;

    final bool isIconIdEmpty = iconId.isEmpty;
    final bool isImageNull = image == null;
    final bool isUserFoodIcon = iconId.startsWith(AppCommonConstants.userFoods);

    final newIconId = (isIconIdEmpty || (isImageNull && isIconIdEmpty) || (!isImageNull && !isUserFoodIcon))
        ? _uniqueIconId
        : iconId;

    // Create an ingredient object with the amount, metadata, name, and reference nutrients
    final ingredient = PassioIngredient(
      amount: amount,
      iconId: newIconId,
      id: passioId,
      metadata: metadata,
      name: name,
      refCode: refCode,
      referenceNutrients: referenceNutrients,
    );

    //   // Create a food record ingredient from the Passio ingredient and add additional data
    final foodRecordIngredient =
        FoodRecordIngredient.fromPassioIngredient(ingredient);
    foodRecordIngredient.id = id;
    foodRecordIngredient.additionalData = additionalData;

    // Create a food record from the food record ingredient
    final foodRecord =
        FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);

    return foodRecord;
  }
}
