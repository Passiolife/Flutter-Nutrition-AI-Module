import 'dart:typed_data';

import '../../connectors/passio_connector.dart';
import '../../domain/repository/passio_connector_repository.dart';
import '../../models/food_record/food_record.dart';
import '../../models/water_record/water_record.dart';
import '../../util/result.dart';

class PassioConnectorRepositoryImpl implements PassioConnectorRepository {
  final PassioConnector _connector;

  const PassioConnectorRepositoryImpl({required PassioConnector connector})
      : _connector = connector;

  @override
  Future<Result<List<FoodRecord>>> fetchDayRecords(
      {required DateTime dateTime}) async {
    try {
      final List<FoodRecord> data = await _connector.fetchDayRecords(dateTime: dateTime);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch day records'));
    }
  }

  @override
  Future<Result<List<FoodRecord>>> fetchRecords({required DateTime fromDate, required DateTime endDate}) async {
    try {
      final List<FoodRecord> data = await _connector.fetchRecords(fromDate: fromDate, endDate: endDate);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch records'));
    }
  }

  @override
  Future<Result<double>> fetchMeasuredWeight({required DateTime dateTime}) async {
    try {
      final double data = await _connector.fetchMeasuredWeight(dateTime: dateTime);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch measured weight'));
    }
  }

  @override
  Future<Result<double>> fetchConsumedWater({required DateTime dateTime}) async {
    try {
      final double data = await _connector.fetchConsumedWater(dateTime: dateTime);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch measured weight'));
    }
  }

  @override
  Future<Result<void>> updateRecord({required FoodRecord foodRecord, required bool isNew}) async {
    try {
      final void data = await _connector.updateRecord(foodRecord: foodRecord, isNew: isNew);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to update record'));
    }
  }

  @override
  Future<Result<List<WaterRecord>>> fetchWaterRecords({required DateTime fromDate, required DateTime endDate}) async {
    try {
      final List<WaterRecord> data = await _connector.fetchWaterRecords(fromDate: fromDate, endDate: endDate);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch water records.'));
    }
  }

  @override
  Future<Result<void>> updateWater({required WaterRecord waterRecord, required bool isNew}) async {
    try {
      final void data = await _connector.updateWater(waterRecord: waterRecord, isNew: isNew);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to update water.'));
    }
  }

  @override
  Future<Result<void>> deleteWater({required WaterRecord waterRecord}) async {
    try {
      final void data = await _connector.deleteWaterRecord(record: waterRecord);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to update water.'));
    }
  }

  ///
  /// Custom Foods
  ///
  @override
  Future<Result<List<FoodRecord>>> fetchUserFoods() async {
    try {
      final List<FoodRecord> data = await _connector.fetchUserFoods();
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch user foods.'));
    }
  }

  @override
  Future<Result<String>> updateUserFood({required FoodRecord foodRecord, required bool isNew}) async {
    try {
      final String data = await _connector.updateUserFood(foodRecord: foodRecord, isNew: isNew);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to update user food.'));
    }
  }

  @override
  Future<Result<void>> deleteUserFood({required FoodRecord foodRecord}) async {
    try {
      final void data = await _connector.deleteUserFood(foodRecord: foodRecord);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to delete user food.'));
    }
  }

  @override
  Future<Result<void>> updateUserFoodImage({required String id, required Uint8List image, required bool isNew}) async {
    try {
      final void data = await _connector.updateUserFoodImage(id: id, image: image, isNew: isNew);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to update user food image.'));
    }
  }

  @override
  Future<Result<Uint8List?>> fetchUserFoodImage({required String id}) async {
    try {
      final Uint8List? data = await _connector.fetchUserFoodImage(id: id);
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch user food image.'));
    }
  }

  @override
  Future<Result<List<FoodRecord>>> fetchUserRecipes() async {
    try {
      final List<FoodRecord> data = await _connector.fetchUserRecipes();
      return Result.success(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch user recipes.'));
    }
  }

}
