import 'dart:typed_data';

import '../../../../../nutrition_ai_module.dart';
import '../../../extension/core_extension.dart';
import '../../../helper/custom_food_helper.dart';
import '../../../models/api_error.dart';
import '../../../util/image_utility/image_utility.dart';
import '../../repository/custom_food_repository.dart';
import '../../repository/nutrition_ai_repository.dart';
import '../base_api_usecase.dart';

class FoodRecordItem {
  final FoodRecord foodRecord;
  final Uint8List? image;
  final bool isBarcodeNotFound;

  const FoodRecordItem({
    required this.foodRecord,
    this.image,
    required this.isBarcodeNotFound,
  });
}

class GetFoodRecordsByImageRecognition
    with BaseApiUseCase<List<FoodRecordItem>, List<Uint8List>?> {
  final NutritionAIRepository repository;
  final CustomFoodRepository customFoodRepository;
  final ImageUtility imageUtility;

  const GetFoodRecordsByImageRecognition({
    required this.imageUtility,
    required this.repository,
    required this.customFoodRepository,
  });

  @override
  Future<
      ({
        APIError? error,
        List<FoodRecordItem> response,
      })> call(List<Uint8List>? params) async {
    if (params == null) {
      return (response: <FoodRecordItem>[], error: null);
    }

    final List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage =
        await _getRecognitionResults(params);

    if (recognitionResultsByImage.isEmpty) {
      return (response: <FoodRecordItem>[], error: null);
    }

    final basicFoodRecords =
        await _processBasicFoodItems(recognitionResultsByImage);
    final packagedFoodRecords =
        await _processPackagedFoodItems(params, recognitionResultsByImage);

    return (response: basicFoodRecords + packagedFoodRecords, error: null);

    /*final List<PassioAdvisorFoodInfo> allRecognizedFoodInfo =
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

    final List<FoodRecordItem> finalFoodRecords = fetchedFoodRecords
        .map<FoodRecordItem>((e) => FoodRecordItem(
              foodRecord: e,
              image: null,
              isBarcodeNotFound: false,
            ))
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

    final packagedFoodRecordsFutures =
        recognitionResultsByImage.asMap().entries.expand((entry) {
      final index = entry.key;
      final values = entry.value;
      return values.map((value) => (index: index, value: value));
    }).where((e) {
      return e.value.resultType == PassioFoodResultType.barcode ||
          e.value.resultType == PassioFoodResultType.nutritionFacts;
    }).map((e) async {
      final image = finalResizedImages[e.index];
      final resultType = e.value.resultType;
      final barcode = e.value.productCode;

      FoodRecord? foodRecord;
      bool isBarcodeNotFound;

      if (barcode != null) {
        foodRecord =
            await customFoodRepository.fetchFoodByBarcode(barcode: barcode);
      }
      if (foodRecord != null) {
        isBarcodeNotFound = false;
      } else if (e.value.packagedFoodItem != null) {
        foodRecord = FoodRecord.fromPassioFoodItem(
          e.value.packagedFoodItem!,
          resultType: resultType,
        );
        if (foodRecord.resultType == PassioFoodResultType.nutritionFacts &&
            foodRecord.name.isNullOrEmpty) {
          foodRecord.name = 'Scanned Nutrition Label';
        }

        isBarcodeNotFound = false;
      } else {
        final nutrients = PassioNutrients.fromNutrients();
        final servingUnits = CustomFoodHelper.getDefaultServingUnits();
        final selectedUnit = CustomFoodHelper.defaultServingUnit;

        final foodRecordIngredient = FoodRecordIngredient.fromCustomData(
          barcode: barcode,
          nutrients: nutrients,
          selectedUnit: selectedUnit,
          servingUnits: servingUnits,
          resultType: resultType,
        );
        foodRecord = FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);
        isBarcodeNotFound = true;
      }
      return FoodRecordItem(
          foodRecord: foodRecord,
          image: image,
          isBarcodeNotFound: isBarcodeNotFound);
    });

    final List<FoodRecordItem> packagedFoodRecords =
        await Future.wait(packagedFoodRecordsFutures);

    final List<FoodRecordItem> foodRecords =
        finalFoodRecords + packagedFoodRecords;

    return (response: foodRecords, error: null);*/
  }

  Future<List<List<PassioAdvisorFoodInfo>>> _getRecognitionResults(
      List<Uint8List> params) async {
    return Future.wait(
      params.map((image) => repository.recognizeImage(image)),
    );
  }

  Future<List<FoodRecordItem>> _processBasicFoodItems(
      List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage) async {
    final List<PassioAdvisorFoodInfo> allRecognizedFoodInfo =
        recognitionResultsByImage
            .expand((results) => results)
            .where((info) => info.foodDataInfo != null)
            .toList();

    final foodRecords = await Future.wait(
      allRecognizedFoodInfo.map(_convertToFoodRecord),
    );

    return foodRecords
        .whereType<FoodRecord>()
        .map((record) => FoodRecordItem(
              foodRecord: record,
              isBarcodeNotFound: false,
            ))
        .toList();
  }

  Future<FoodRecord?> _convertToFoodRecord(PassioAdvisorFoodInfo info) async {
    final foodItem =
        await repository.fetchFoodItemForDataInfo(info.foodDataInfo!);
    return foodItem.let((value) => FoodRecord.fromPassioFoodItem(
          value,
          resultType: info.resultType,
        ));
  }

  Future<List<FoodRecordItem>> _processPackagedFoodItems(
    List<Uint8List> params,
    List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage,
  ) async {
    final targetResults = recognitionResultsByImage
        .asMap().entries
        .expand((entry) {
      final index = entry.key;
      final values = entry.value;
      return values.map((value) => (index: index, value: value));
    })
        .where((e) => _isPackagedResultType(e.value))
        .toList();

    if (targetResults.isEmpty) return [];

    final Set<int> imageIndexesToResize =
        _getImageIndexesToResize(recognitionResultsByImage);
    final Map<int, Uint8List> resizedImages =
        await _resizeImages(params, imageIndexesToResize);

    /*
    final packagedFoodRecordsFutures =
        recognitionResultsByImage.asMap().entries.expand((entry) {
      final index = entry.key;
      final values = entry.value;
      return values.map((value) => (index: index, value: value));
    }).where((e) {
      return e.value.resultType == PassioFoodResultType.barcode ||
          e.value.resultType == PassioFoodResultType.nutritionFacts;
    }).map((e) async {
      final image = finalResizedImages[e.index];
      final resultType = e.value.resultType;
      final barcode = e.value.productCode;
    */
    return Future.wait(
      targetResults
          .map((entry) => _createPackagedFoodRecord(entry.index, entry.value, resizedImages)),
    );
  }

  bool _isPackagedResultType(PassioAdvisorFoodInfo info) {
    return info.resultType == PassioFoodResultType.barcode ||
        info.resultType == PassioFoodResultType.nutritionFacts;
  }

  Set<int> _getImageIndexesToResize(
      List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage) {
    final indexes = <int>{};
    for (var i = 0; i < recognitionResultsByImage.length; i++) {
      if (recognitionResultsByImage[i].any(_isPackagedResultType)) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  Future<Map<int, Uint8List>> _resizeImages(
      List<Uint8List> params, Set<int> imageIndexes) async {
    final resizedImages = await Future.wait(
      imageIndexes.map((index) async {
        final resized = await imageUtility.resizeUint8List(
          params[index],
          width: 100,
          height: 100,
        );
        return MapEntry(index, resized);
      }),
    );
    return Map.fromEntries(resizedImages);
  }

  Future<FoodRecordItem> _createPackagedFoodRecord(
    int index,
    PassioAdvisorFoodInfo info,
    Map<int, Uint8List> resizedImages,
  ) async {
    final image = resizedImages[index];
    final barcode = info.productCode;
    FoodRecord? foodRecord;
    bool isBarcodeNotFound = false;

    if (barcode != null) {
      foodRecord =
          await customFoodRepository.fetchFoodByBarcode(barcode: barcode);
    }

    if (foodRecord != null) {
    } else if (info.packagedFoodItem != null) {
      foodRecord = FoodRecord.fromPassioFoodItem(
        info.packagedFoodItem!,
        resultType: info.resultType,
      );
      if (foodRecord.resultType == PassioFoodResultType.nutritionFacts &&
          foodRecord.name.isNullOrEmpty) {
        foodRecord.name = 'Scanned Nutrition Label';
      }
    } else {
      foodRecord = _createDefaultFoodRecord(info);
      isBarcodeNotFound = true;
    }

    return FoodRecordItem(
      foodRecord: foodRecord,
      image: image,
      isBarcodeNotFound: isBarcodeNotFound,
    );
  }

  FoodRecord _createDefaultFoodRecord(PassioAdvisorFoodInfo info) {
    final foodRecordIngredient = FoodRecordIngredient.fromCustomData(
      barcode: info.productCode,
      nutrients: PassioNutrients.fromNutrients(),
      selectedUnit: CustomFoodHelper.defaultServingUnit,
      servingUnits: CustomFoodHelper.getDefaultServingUnits(),
      resultType: info.resultType,
    );

    return FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);
  }
}
