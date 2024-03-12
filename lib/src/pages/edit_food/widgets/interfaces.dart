import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';

abstract interface class EditFoodListener {
  void onChangeDate(DateTime dateTime);
  void onChangeMealTime(MealLabel mealLabel);
  void onChangeFavorite(bool isFavorite);
  void onChangeServingUnit(String unit);
  void onChangeServingQuantity(double quantity, bool resetSlider);
  void onAddIngredient();
  void onTapIngredient(FoodRecordIngredient foodRecordIngredient);
  void onDeleteIngredient(FoodRecordIngredient foodRecordIngredient);
  void onTapMoreDetails();
  void onTapOpenFoodFacts();
}