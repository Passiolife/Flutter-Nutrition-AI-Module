import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';

abstract interface class EditFoodListener {
  void onDateChanged(DateTime dateTime);
  void onMealTimeChanged(MealLabel mealLabel);
  void onServingUnitChanged(String unit);
  void onServingQuantityChanged(double quantity, bool resetSlider);
  void onAddIngredientRequested();
  void onIngredientTapped(FoodRecordIngredient foodRecordIngredient);
  void onIngredientDeleted(int index);
  void onLogTapped();
  void onCancelTapped();
}
