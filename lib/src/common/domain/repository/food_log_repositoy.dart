import '../../../../nutrition_ai_module.dart';
import '../../models/api_error.dart';

abstract class FoodLogRepository {
  const FoodLogRepository();

  Future<void> addFoodLog({required FoodRecord foodRecord});
  Future<void> updateFoodLog({required FoodRecord foodRecord});

  /*Future<(APIError? error, void)> addFoodRecords(List<FoodRecord> foodRecords) async {
    try {
      final foodLog = await connector.updateRecord(foodRecord: foodRecord, isNew: isNew);
      return Right(foodLog);
    } on Failure catch (e) {
      return Left(e);
    }
  }*/

/*Future<Either<Failure, FoodLog>> getFoodLog() async {
    try {
      final foodLog = await _dataSource.getFoodLog();
      return Right(foodLog);
    } on Failure catch (e) {
      return Left(e);
    }
  }



  Future<Either<Failure, FoodLog>> updateFoodLog(FoodLog foodLog) async {
    try {
      final foodLog = await _dataSource.updateFoodLog(foodLog);
      return Right(foodLog);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  Future<Either<Failure, FoodLog>> deleteFoodLog(FoodLog foodLog) async {
    try {
      final foodLog = await _dataSource.deleteFoodLog(foodLog);
      return Right(foodLog);
    } on Failure catch (e) {
      return Left(e);
    }
  }*/
}