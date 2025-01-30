import 'dart:typed_data';

import '../../../models/food_record/food_record.dart';
import '../../repository/custom_food_repository.dart';

class AddCustomFoodUseCase {
  final CustomFoodRepository customFoodRepository;

  const AddCustomFoodUseCase({required this.customFoodRepository});

  Future<String> call({
    required FoodRecord foodRecord,
    Uint8List? image,
  }) async {
    final List<dynamic> results = await Future.wait([
      customFoodRepository.addFood(foodRecord: foodRecord),
      if (image != null)
        customFoodRepository.addFoodImage(id: foodRecord.iconId, image: image),
    ]);
    return results.first as String;
  }
}
