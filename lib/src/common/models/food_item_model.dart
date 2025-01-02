import 'food_record/food_record.dart';

class FoodItemModel {
  final String iconId;
  final String title;
  final String subtitle;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final bool isSelected;
  final double selectedQuantity;
  final String selectedUnit;
  final List<String> units;

  const FoodItemModel({
    required this.iconId,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.selectedQuantity,
    required this.selectedUnit,
    required this.units,
    this.isSelected = true,
  });

  factory FoodItemModel.fromFoodRecord(FoodRecord foodRecord) {
    return FoodItemModel(
      iconId: foodRecord.iconId,
      title: foodRecord.name,
      subtitle:
      '${foodRecord.getSelectedQuantity()} ${foodRecord
          .getSelectedUnit()} (${foodRecord.computedWeight.value} ${foodRecord
          .computedWeight.symbol})',
      calories: foodRecord.totalCalories,
      carbs: foodRecord.totalCarbs,
      protein: foodRecord.totalProteins,
      fat: foodRecord.totalFat,
      selectedQuantity: foodRecord.getSelectedQuantity(),
      selectedUnit: foodRecord.getSelectedUnit(),
      units: foodRecord.servingUnits.map((e) => e.unitName).toList(),
      isSelected: true,
    );
  }

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      iconId: json['iconId'],
      title: json['title'],
      subtitle: json['subtitle'],
      calories: json['calories'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      selectedQuantity: json['selectedQuantity'],
      selectedUnit: json['selectedUnit'],
      units: List<String>.from(json['units']),
      isSelected: json['isSelected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iconId': iconId,
      'title': title,
      'subtitle': subtitle,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'selectedQuantity': selectedQuantity,
      'selectedUnit': selectedUnit,
      'units': units,
      'isSelected': isSelected,
    };
  }

  FoodItemModel clone() {
    var json = toJson();
    return FoodItemModel.fromJson(json);
  }

  FoodItemModel copyWith({
    String? iconId,
    String? title,
    String? subtitle,
    double? calories,
    double? carbs,
    double? protein,
    double? fat,
    double? selectedQuantity,
    String? selectedUnit,
    List<String>? units,
    bool? isSelected,
  }) {
    return FoodItemModel(
      iconId: iconId ?? this.iconId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      units: units ?? this.units,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  FoodItemModel updateIsSelected(bool isSelected) {
    return copyWith(isSelected: isSelected);
  }

  FoodItemModel updateSelectedQuantity(double selectedQuantity) {
    return copyWith(selectedQuantity: selectedQuantity);
  }

  FoodItemModel updateSelectedUnit(String selectedUnit) {
    return copyWith(selectedUnit: selectedUnit);
  }
}
