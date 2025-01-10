import '../../../../nutrition_ai_module.dart';
import '../../domain/repository/food_log_repositoy.dart';

class FoodLogRepositoryImpl extends FoodLogRepository {
  final PassioConnector connector;

  const FoodLogRepositoryImpl({required this.connector});

  @override
  Future<void> addFoodLog({required FoodRecord foodRecord}) async {
    await connector.updateRecord(foodRecord: foodRecord, isNew: true);
  }

  @override
  Future<void> updateFoodLog({required FoodRecord foodRecord}) async {
    await connector.updateRecord(foodRecord: foodRecord, isNew: false);
  }
}