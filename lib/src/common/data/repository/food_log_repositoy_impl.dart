import '../../../../nutrition_ai_module.dart';

abstract interface class FoodLogRepository {
  Future<void> addFoodLog({required FoodRecord foodRecord, required bool isNew});
}

class FoodLogRepositoryImpl extends FoodLogRepository {
  // PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  final PassioConnector connector;

  FoodLogRepositoryImpl({required this.connector});

  @override
  Future<void> addFoodLog({required FoodRecord foodRecord, required bool isNew}) async {
    await connector.updateRecord(foodRecord: foodRecord, isNew: isNew);
  }

}