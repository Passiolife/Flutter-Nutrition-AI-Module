import 'package:nutrition_ai/nutrition_ai.dart';

abstract interface class PassioSearchListener {
  void onFoodItemSelected(PassioFoodDataInfo result);
  void onNameSelected(String name);
}
