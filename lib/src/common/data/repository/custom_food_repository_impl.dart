import 'dart:typed_data';

import '../../connectors/passio_connector.dart';
import '../../domain/repository/custom_food_repository.dart';
import '../../models/food_record/food_record.dart';

class CustomFoodRepositoryImpl extends CustomFoodRepository {
  final PassioConnector connector;

  const CustomFoodRepositoryImpl({required this.connector});

  @override
  Future<String> addFood({required FoodRecord foodRecord}) async {
    return await connector.updateUserFood(foodRecord: foodRecord, isNew: true);
  }

  @override
  Future<String> updateFood({required FoodRecord foodRecord}) async {
    await connector.updateUserFood(foodRecord: foodRecord, isNew: false);
    return foodRecord.id;
  }

  @override
  Future<void> addFoodImage({required String id, required Uint8List image}) async {
    await connector.updateUserFoodImage(id: id, image: image, isNew: true);
    return;
  }

  @override
  Future<List<FoodRecord>> fetchAll() async {
    return await connector.fetchUserFoods();
  }

  @override
  Future<FoodRecord?> fetchFoodByBarcode({required String barcode}) async {
    return await connector.fetchUserFoodByBarcode(barcode: barcode);
  }
}
