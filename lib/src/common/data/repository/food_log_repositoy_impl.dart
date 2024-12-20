import '../../../../nutrition_ai_module.dart';

class FoodLogRepositoryImpl {
  PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  const FoodLogRepositoryImpl();

  Future<void> addFoodLog(FoodRecord foodRecord, bool isNew) async {
    await _connector.updateRecord(foodRecord: foodRecord, isNew: isNew);
  }

}