import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/util/passio_food_item_data_extension.dart';

part 'multi_food_scan_event.dart';

part 'multi_food_scan_state.dart';

class MultiFoodScanBloc extends Bloc<MultiFoodScanEvent, MultiFoodScanState> {

  // [insertFoodRecordUseCase] is use to insert food record into DB.
  // final UpdateFoodRecordUseCase? updateFoodRecordUseCase;

  // [_passioIds] contains the set of unique PassioIDs.
  // With the help of this we can eliminate the duplication in list.
  final _passioIds = <String>{};

  /// [_connector] use to perform operations.
  PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  MultiFoodScanBloc() : super(QuickFoodScanInitial()) {
    on<RecognitionResultEvent>(_handleRecognitionResultEvent);
    on<ShowFoodDetailsViewEvent>(_handleShowFoodDetailsViewEvent);
    on<DoAddAllEvent>(_handleDoAddAllEvent);
    on<DoNewRecipeEvent>(_handleDoNewRecipeEvent);
    on<DoClearAllEvent>(_handleDoClearAllEvent);
  }

  Future _handleRecognitionResultEvent(RecognitionResultEvent event, Emitter<MultiFoodScanState> emit) async {
    /// [foodCandidates] from recognition result.
    final foodCandidates = event.foodCandidates;

    var passioID = foodCandidates.detectedCandidates.firstOrNull?.passioID;
    var barcode = foodCandidates.barcodeCandidates?.firstOrNull?.value;
    var packagedFoodCode = foodCandidates.packagedFoodCandidates?.firstOrNull?.packagedFoodCode;

    PassioIDAttributes? attributes;

    // If the scan result is Bar code.
    if (barcode != null) {
      if (_passioIds.add(barcode)) {
        attributes = await NutritionAI.instance.fetchAttributesForBarcode(barcode);
      }
    }
    // If the scan result is food package.
    else if (packagedFoodCode != null) {
      if (_passioIds.add(packagedFoodCode)) {
        attributes = await NutritionAI.instance.fetchAttributesForPackagedFoodCode(packagedFoodCode);
      }
    }
    // If the scan result is passioID.
    else if (passioID != null) {
      if (_passioIds.add(passioID)) {
        attributes = await NutritionAI.instance.lookupPassioAttributesFor(passioID);
      }
    }
    // There is no any result then show searching UI.
    else {
      emit(QuickFoodLoadingState(isLoading: true));
    }

    if (attributes != null) {
      final foodRecord = FoodRecord.from(passioIDAttributes: attributes, dateTime: event.dateTime);
      emit(QuickFoodSuccessState(foodRecord: foodRecord));
    }
  }

  Future _handleShowFoodDetailsViewEvent(ShowFoodDetailsViewEvent event, Emitter<MultiFoodScanState> emit) async {
    emit(ShowFoodDetailsViewState(isVisible: event.isVisible, index: event.index));
  }

  Future<void> _handleDoAddAllEvent(DoAddAllEvent event, Emitter<MultiFoodScanState> emit) async {
    try {
      for (var element in event.data.reversed) {
        if (element != null) {
          await _connector.updateRecord(foodRecord: element, isNew: true);
          emit(FoodInsertSuccessState());
        }
      }
      // Here, clearing the [_passioIds] So next time same food item can be insert into the set.
      _passioIds.clear();
    } catch (e) {
      emit(FoodInsertFailureState());
    }
  }

  FutureOr<void> _handleDoNewRecipeEvent(DoNewRecipeEvent event, Emitter<MultiFoodScanState> emit) async {

    try {
      // Here, clearing the [_passioIds] So next time same food item can be insert into the set.
      _passioIds.clear();

      // Here taking first record from [event.data].
      FoodRecord? latestFoodRecord = event.data.first;
      // Here, updating the name of the food record which user has inputted.
      // Here clearing the ingredients.
      latestFoodRecord?.ingredients?.asMap().forEach((index, ingredient) {
        PassioFoodItemData? updatedIngredient = (latestFoodRecord.entityType != PassioIDEntityType.recipe) ? ingredient.copyWith(
            passioID: latestFoodRecord.passioID, name: latestFoodRecord.name) : ingredient;
        latestFoodRecord.ingredients?[index] = updatedIngredient;
      });

      // Looping all the data which are present on screen.
      event.data.asMap().forEach((index, value) {
        // Checking if index is > 0, because already we have took first record [latestFoodRecord] from data, so no need to add same ingredients twice.
        if (index > 0) {
          value?.ingredients?.forEach((ingredient) {
            PassioFoodItemData? updatedIngredient = (value.entityType != PassioIDEntityType.recipe) ? ingredient.copyWith(
                passioID: value.passioID, name: value.name) : ingredient;
            latestFoodRecord?.addIngredients(ingredient: updatedIngredient, isFirst: false);
          });
        }
      });

      // We are updating the name here because it overrides name with "Recipe with" text.
      latestFoodRecord?.name = event.name;
      if (latestFoodRecord == null) {
        emit(NewRecipeFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.updateRecord(foodRecord: latestFoodRecord, isNew: true);
      emit(NewRecipeSuccessState());
    } catch (e) {
      emit(NewRecipeFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoClearAllEvent(DoClearAllEvent event, Emitter<MultiFoodScanState> emit) async {
    _passioIds.clear();
  }
}
