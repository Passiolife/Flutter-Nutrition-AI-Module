import 'package:nutrition_ai/nutrition_ai.dart';

abstract interface class PassioSearchListener {
  void onFoodItemSelected(PassioSearchResult result);
  void onNameSelected(String name);
}