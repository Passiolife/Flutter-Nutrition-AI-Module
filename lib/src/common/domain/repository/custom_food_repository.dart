import 'dart:typed_data';

import '../../models/food_record/food_record.dart';

abstract class CustomFoodRepository {
  const CustomFoodRepository();

  // Food Related
  Future<String> addFood({required FoodRecord foodRecord});

  Future<String> updateFood({required FoodRecord foodRecord});

  // Image Related
  Future<void> addFoodImage({required String id, required Uint8List image});

  Future<FoodRecord?> fetchFoodByBarcode({required String barcode});

  Future<List<FoodRecord>> fetchAll();
}
