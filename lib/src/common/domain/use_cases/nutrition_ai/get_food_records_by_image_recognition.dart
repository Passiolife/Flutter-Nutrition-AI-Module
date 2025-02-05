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
  final FoodRecord? foodRecord;
  final Uint8List? image;
  final bool isBarcodeNotFound;

  const FoodRecordItem({
    this.foodRecord,
    this.image,
    this.isBarcodeNotFound = false,
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
  Future<({APIError? error, List<FoodRecordItem> response})> call(
      List<Uint8List>? params) async {
    if (params == null) {
      return (response: <FoodRecordItem>[], error: null);
    }

    final List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage =
        await _getRecognitionResults(params);

    if (recognitionResultsByImage.isEmpty) {
      return (response: <FoodRecordItem>[], error: null);
    }

    final basicFoodRecords =
        await _processBasicFoodItems(params, recognitionResultsByImage);
    final packagedFoodRecords =
        await _processPackagedFoodItems(params, recognitionResultsByImage);

    return (response: basicFoodRecords + packagedFoodRecords, error: null);
  }

  Future<List<List<PassioAdvisorFoodInfo>>> _getRecognitionResults(
      List<Uint8List> params) async {
    return Future.wait(
      params.map((image) => repository.recognizeImage(image)),
    );
  }

  Future<List<FoodRecordItem>> _processBasicFoodItems(List<Uint8List> params,
      List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage) async {
    final List<PassioAdvisorFoodInfo> allRecognizedFoodInfo =
        recognitionResultsByImage
            .expand((results) => results)
            .where((info) => info.foodDataInfo != null)
            .toList();

    final List<FoodRecord?> foodRecords = await Future.wait(
      allRecognizedFoodInfo.map(_convertToFoodRecord),
    );

    final List<FoodRecordItem> allRecognizedFoodItems = foodRecords
        .whereType<FoodRecord>()
        .map((record) => FoodRecordItem(
              foodRecord: record,
            ))
        .toList();

    final Set<int> imageIndexesToResize =
        _getNotRecognizedFoodImageIndexesToResize(recognitionResultsByImage);
    final Map<int, Uint8List> resizedImages =
        await _resizeImages(params, imageIndexesToResize);

    List<FoodRecordItem> notRecognizedFoodInfo = [];

    if (resizedImages.isNotEmpty) {
      notRecognizedFoodInfo = recognitionResultsByImage
          .asMap()
          .entries
          .map((entry) {
            return entry.value.isEmpty
                ? FoodRecordItem(
                    image: resizedImages[entry.key],
                  )
                : null;
      })
          .whereType<FoodRecordItem>().toList();
    }

    final foodRecordItems = allRecognizedFoodItems + notRecognizedFoodInfo;

    return foodRecordItems;
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
        .asMap()
        .entries
        .expand((entry) {
          final index = entry.key;
          final values = entry.value;
          return values.map((value) => (index: index, value: value));
        })
        .where((e) => _isPackagedResultType(e.value))
        .toList();

    if (targetResults.isEmpty) return [];

    final Set<int> imageIndexesToResize =
        _getPackagedImageIndexesToResize(recognitionResultsByImage);
    final Map<int, Uint8List> resizedImages =
        await _resizeImages(params, imageIndexesToResize);

    return Future.wait(
      targetResults.map((entry) =>
          _createPackagedFoodRecord(entry.index, entry.value, resizedImages)),
    );
  }

  bool _isPackagedResultType(PassioAdvisorFoodInfo info) {
    return info.resultType == PassioFoodResultType.barcode ||
        info.resultType == PassioFoodResultType.nutritionFacts;
  }

  Set<int> _getNotRecognizedFoodImageIndexesToResize(
      List<List<PassioAdvisorFoodInfo>> recognitionResultsByImage) {
    final indexes = <int>{};
    for (var i = 0; i < recognitionResultsByImage.length; i++) {
      if (recognitionResultsByImage.elementAt(i).isEmpty) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  Set<int> _getPackagedImageIndexesToResize(
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
