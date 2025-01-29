import 'dart:developer';
import 'dart:typed_data';

import '../../../../../nutrition_ai_module.dart';
import '../../../helper/custom_food_helper.dart';
import '../../../models/api_error.dart';
import '../../../util/image_utility/image_utility.dart';
import '../../repository/nutrition_ai_repository.dart';
import '../base_api_usecase.dart';

class GetFoodRecordsByImageRecognition
    with
        BaseApiUseCase<List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>,
            List<Uint8List>?> {
  final NutritionAIRepository repository;
  final ImageUtility imageUtility;

  const GetFoodRecordsByImageRecognition({
    required this.imageUtility,
    required this.repository,
  });

  @override
  Future<
      ({
        APIError? error,
        List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})> response,
      })> call(List<Uint8List>? params) async {
    if (params == null) {
      return (
        response: <({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>[],
        error: null,
      );
    }

    final List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage =
        (await Future.wait(
            params.map((image) async => repository.recognizeImage(image))));

    if (recognitionResultsByImage.isEmpty) {
      return (
        response: <({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>[],
        error: null
      );
    }

    final List<PassioAdvisorFoodInfo> allRecognizedFoodInfo =
        recognitionResultsByImage.expand((list) => list).toList();

    final List<Future<FoodRecord?>> foodRecordFutures = allRecognizedFoodInfo
        .where((data) => data.foodDataInfo != null)
        .map((data) async {
      final foodData = data.foodDataInfo;
      if (foodData == null) return null;
      final foodItem = await repository.fetchFoodItemForDataInfo(foodData);
      if (foodItem == null) return null;
      return FoodRecord.fromPassioFoodItem(
        foodItem,
        resultType: data.resultType,
      );
    }).toList();

    final List<FoodRecord> fetchedFoodRecords =
        (await Future.wait(foodRecordFutures)).whereType<FoodRecord>().toList();

    final List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})> finalFoodRecords =
        fetchedFoodRecords
            .map<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>(
                (e) => (foodRecord: e, image: null, isBarcodeNotFound: false,))
            .toList();

    final Map<int, int> indexes = recognitionResultsByImage
        .asMap()
        .entries
        .fold<Map<int, int>>({}, (result, rowEntry) {
      rowEntry.value.asMap().entries.forEach((colEntry) {
        if (colEntry.value.resultType == PassioFoodResultType.barcode ||
            colEntry.value.resultType == PassioFoodResultType.nutritionFacts) {
          result[rowEntry.key] = colEntry.key; // Add to the result map
        }
      });
      return result;
    });

    log('Indexes of resultType == "barcode": $indexes');

    final List<Future<Map<int, Uint8List>>> futureResizedImages =
        indexes.entries.map((entry) async {
      final image = params[entry.key];
      final imageWidth = 100;
      final imageHeight = 100;

      // Perform the asynchronous resize
      final resizedImage = await imageUtility.resizeUint8List(
        image,
        width: imageWidth,
        height: imageHeight,
      );

      // Return the map with the resized image
      return {entry.key: resizedImage};
    }).toList();

    final List<Map<int, Uint8List>> resizedImages =
        await Future.wait(futureResizedImages);

    final Map<int, Uint8List> finalResizedImages = {
      for (var map in resizedImages) ...map,
    };

    final List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>
        packagedFoodRecords =
        recognitionResultsByImage.asMap().entries.expand((entry) {
      final index = entry.key;
      final values = entry.value;
      return values.map((value) => (index: index, value: value));
    }).where((e) {
      return e.value.resultType == PassioFoodResultType.barcode ||
          e.value.resultType == PassioFoodResultType.nutritionFacts;
    }).map((e) {
      final image = finalResizedImages[e.index];
      if (e.value.packagedFoodItem != null) {
        final foodRecord =
            FoodRecord.fromPassioFoodItem(e.value.packagedFoodItem!);
        return (foodRecord: foodRecord, image: image, isBarcodeNotFound: false);
      } else {
        final barcode = e.value.productCode;
        final nutrients = PassioNutrients.fromNutrients();
        final servingUnits = CustomFoodHelper.getDefaultServingUnits();
        final selectedUnit = CustomFoodHelper.defaultServingUnit;
        final resultType = e.value.resultType;

        final foodRecordIngredient = FoodRecordIngredient.fromCustomData(
          barcode: barcode,
          nutrients: nutrients,
          selectedUnit: selectedUnit,
          servingUnits: servingUnits,
          resultType: resultType,
        );
        final foodRecord =
            FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);
        return (foodRecord: foodRecord, image: image, isBarcodeNotFound: true);
      }
    }).toList();
    /*final List<({FoodRecord foodRecord, Uint8List? image})> packagedFoodRecords = recognitionResultsByImage
        .asMap()
        .entries.expand((e) => e.)
        .where((entry) => entry.value[entry.key].packagedFoodItem != null)
        .map((e) {
          final result = (foodRecord: e);
      */ /*rowEntry.value.asMap().entries.forEach((colEntry) {
        if (colEntry.value.resultType == PassioFoodResultType.barcode ||
            colEntry.value.resultType == PassioFoodResultType.nutritionFacts) {
          result[rowEntry.key] = colEntry.key; // Add to the result map
        }
      });*/ /*
      return result;
    }).toList();*/

    // List<FoodRecord> packagedFoodRecords = allRecognizedFoodInfo
    //     .where((e) => e.packagedFoodItem != null)
    //     .map((e) => FoodRecord.fromPassioFoodItem(
    //           e.packagedFoodItem!,
    //           resultType: e.resultType,
    //         ))
    //     .toList();

    final List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})> foodRecords =
        finalFoodRecords + packagedFoodRecords;

    // recognizedData.forEach((element) {
    //   print(element);
    // });
    // final recognizedData = await repository.recognizeImages(params);
    /*
    var foodRecordFutures =
        recognizedData.where((e) => e.foodDataInfo != null).map((e) async {
      final foodData = e.foodDataInfo;
      if (foodData == null) return null;
      final foodItem = await repository.fetchFoodItemForDataInfo(foodData);
      if (foodItem == null) return null;
      return FoodRecord.fromPassioFoodItem(
        foodItem,
        resultType: e.resultType,
      );
    }).toList();

    // Use Future.wait to resolve all futures and filter out nulls
    List<FoodRecord> fetchedFoodRecords = (await Future.wait(foodRecordFutures))
        .whereType<FoodRecord>()
        .toList();

    List<FoodRecord> packagedFoodRecords = recognizedData
        .where((e) => e.packagedFoodItem != null)
        .map((e) => FoodRecord.fromPassioFoodItem(
              e.packagedFoodItem!,
              resultType: e.resultType,
            ))
        .toList();

    final foodRecords = fetchedFoodRecords + packagedFoodRecords;
*/
    return (response: foodRecords, error: null);
  }
}
