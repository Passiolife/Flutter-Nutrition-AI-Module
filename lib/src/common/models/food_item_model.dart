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

  const FoodItemModel({
    required this.iconId,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.isSelected = false,
  });

  factory FoodItemModel.fromFoodRecord(FoodRecord foodRecord) {
    return FoodItemModel(
      iconId: foodRecord.iconId,
      title: foodRecord.name,
      subtitle: '${foodRecord.getSelectedQuantity()} ${foodRecord.getSelectedUnit()} (${foodRecord.computedWeight.value} ${foodRecord.computedWeight.symbol})',
      calories: foodRecord.totalCalories,
      carbs: foodRecord.totalCarbs,
      protein: foodRecord.totalProteins,
      fat: foodRecord.totalFat,
    );
  }
}
