import 'dart:typed_data';

import '../../models/food_record/food_record.dart';
import '../../models/water_record/water_record.dart';
import '../../util/result.dart';

abstract class PassioConnectorRepository {
  const PassioConnectorRepository();

  // Records
  Future<Result<List<FoodRecord>>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  Future<Result<void>> updateRecord(
      {required FoodRecord foodRecord, required bool isNew});

  //
  Future<Result<List<FoodRecord>>> fetchDayRecords(
      {required DateTime dateTime});

  Future<Result<double>> fetchMeasuredWeight({required DateTime dateTime});

  // Water
  Future<Result<double>> fetchConsumedWater({required DateTime dateTime});

  Future<Result<List<WaterRecord>>> fetchWaterRecords({
    required DateTime fromDate,
    required DateTime endDate,
  });

  Future<Result<void>> updateWater(
      {required WaterRecord waterRecord, required bool isNew});

  Future<Result<void>> deleteWater({required WaterRecord waterRecord});

  // Custom Foods
  Future<Result<List<FoodRecord>>> fetchUserFoods();

  Future<Result<String>> updateUserFood({
    required FoodRecord foodRecord,
    required bool isNew,
  });

  Future<Result<void>> deleteUserFood({required FoodRecord foodRecord});

  // Custom Foods Images
  Future<Result<void>> updateUserFoodImage({
    required String id,
    required Uint8List image,
    required bool isNew,
  });

  Future<Result<Uint8List?>> fetchUserFoodImage({required String id});

  // Custom Recipes
  Future<Result<List<FoodRecord>>> fetchUserRecipes();


}
