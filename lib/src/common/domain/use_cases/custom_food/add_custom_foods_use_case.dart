import 'dart:typed_data';

import '../../../models/food_record/food_record.dart';
import 'save_custom_food_use_case.dart';

class AddCustomFoodsUseCase {
  final AddCustomFoodUseCase addCustomFoodUseCase;

  const AddCustomFoodsUseCase({required this.addCustomFoodUseCase});

  Future<List<String>> call({
    required List<({FoodRecord foodRecord, Uint8List? image})> data,
    required bool isNew,
  }) async {
    List<Future> futures = [];

    for (({FoodRecord foodRecord, Uint8List? image}) record in data) {
      futures.add(addCustomFoodUseCase.call(
          foodRecord: record.foodRecord, image: record.image, isNew: isNew));
    }

    final result = await Future.wait(futures);

    return result.map((e) => e as String).toList();
  }
}
