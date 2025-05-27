import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/core_extension.dart';
import '../view_models/food_creator_view_model.dart';
import '../view_models/nutrient_view_model.dart';

part 'food_creator_event.dart';
part 'food_creator_state.dart';

class FoodCreatorBloc extends Bloc<FoodCreatorEvent, FoodCreatorState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  FoodRecord? _userFoodRecord;
  FoodRecord? _loggedFoodRecord;
  PassioNutritionFacts? _nutritionFacts;
  bool _logUponCreate = false;
  FoodCreatorViewModel? _foodCreatorViewModel;

  FoodCreatorBloc() : super(const FoodCreatorInitialState()) {
    on<DoConversionEvent>(_handleDoConversionEvent);
    on<DoUpdateFoodDetailsEvent>(_handleDoUpdateFoodDetailsEvent);
    on<DoUpdateBarcodeEvent>(_handleDoUpdateBarcodeEvent);
    on<DoUpdateRequiredNutritionFactsEvent>(
        _handleDoUpdateRequiredNutritionFactsEvent);
    on<DoUpdateOtherNutritionFactsEvent>(
        _handleDoUpdateOtherNutritionFactsEvent);
    on<DoSaveEvent>(_handleDoSaveEvent);
  }

  Future<void> _handleDoConversionEvent(
      DoConversionEvent event, Emitter<FoodCreatorState> emit) async {
    _initializeConversion(event);

    if (_nutritionFacts != null) {
      _foodCreatorViewModel =
          FoodCreatorViewModel.fromNutritionFacts(_nutritionFacts!);
      _emitConversionSuccess(emit);
      return;
    }

    // Fetch or use the existing food record based on the update state
    final foodRecord = _userFoodRecord ?? _loggedFoodRecord;
    final setIdToEmpty = _userFoodRecord == null;
    if (foodRecord == null) {
      _foodCreatorViewModel = FoodCreatorViewModel.empty();
      return;
    }

    // Set up the ViewModel based on the food record and icon ID state
    final setIconIdToEmpty = _shouldSetIconIdToEmpty(foodRecord);
    _foodCreatorViewModel = FoodCreatorViewModel.fromFoodRecord(
      foodRecord,
      setIdToEmpty: setIdToEmpty,
      setIconIdToEmpty: setIconIdToEmpty,
    );

    // Fetch and update image
    await _fetchAndSetUserFoodImage(foodRecord);

    // Emit the state with the final ViewModel
    if (_foodCreatorViewModel != null) {
      _emitConversionSuccess(emit);
    }
  }

  void _initializeConversion(DoConversionEvent event) {
    _userFoodRecord = event.userFoodRecord;
    _loggedFoodRecord = event.loggedFoodRecord;
    _nutritionFacts = event.nutritionFacts;
    _logUponCreate = event.logUponCreate;
  }

  bool _shouldSetIconIdToEmpty(FoodRecord foodRecord) {
    return !(_userFoodRecord != null) &&
        (foodRecord.iconId.startsWith(AppCommonConstants.userFood));
  }

  Future<void> _fetchAndSetUserFoodImage(FoodRecord foodRecord) async {
    if (foodRecord.iconId.startsWith(AppCommonConstants.userFood)) {
      final image = await _connector.fetchUserFoodImage(id: foodRecord.iconId);
      if (_foodCreatorViewModel != null) {
        _foodCreatorViewModel =
            _foodCreatorViewModel!.updateFoodDetails(newImage: image);
      }
    }
  }

  void _emitConversionSuccess(Emitter<FoodCreatorState> emit) {
    emit(ConversionSuccessListenerState(
      viewModel: _foodCreatorViewModel!,
      saveEnabled: _foodCreatorViewModel!.validate,
    ));
    emit(ConversionSuccessBuilderState());
  }

  FutureOr<void> _handleDoUpdateFoodDetailsEvent(
      DoUpdateFoodDetailsEvent event, Emitter<FoodCreatorState> emit) async {
    _foodCreatorViewModel = _foodCreatorViewModel?.updateFoodDetails(
      newImage: event.image,
      newName: event.name,
      newAdditionalData: event.brand,
    );
    if (_foodCreatorViewModel != null) {
      emit(UpdateFoodDetailsSuccessListenerState(
        viewModel: _foodCreatorViewModel!,
        saveEnabled: _foodCreatorViewModel!.validate,
      ));
      emit(UpdateFoodDetailsSuccessBuilderState());
    }
  }

  FutureOr<void> _handleDoUpdateBarcodeEvent(
      DoUpdateBarcodeEvent event, Emitter<FoodCreatorState> emit) async {
    _foodCreatorViewModel = _foodCreatorViewModel?.updateBarcode(event.barcode);
    if (_foodCreatorViewModel != null) {
      emit(UpdateBarcodeSuccessListenerState(
        viewModel: _foodCreatorViewModel!,
        saveEnabled: _foodCreatorViewModel!.validate,
      ));
      emit(UpdateBarcodeSuccessBuilderState());
    }
  }

  FutureOr<void> _handleDoUpdateRequiredNutritionFactsEvent(
      DoUpdateRequiredNutritionFactsEvent event,
      Emitter<FoodCreatorState> emit) async {
    _foodCreatorViewModel = _foodCreatorViewModel?.updateRequiredNutritionFacts(
      newServingQuantity: event.servingQuantity,
      newServingUnit: event.servingUnit,
      newWeightValue: event.weightValue,
      newWeightSymbol: event.weightSymbol,
      newCalories: event.calories,
      newFat: event.fat,
      newCarbs: event.carbs,
      newProtein: event.protein,
    );
    if (_foodCreatorViewModel != null) {
      emit(UpdateRequiredNutritionFactsSuccessListenerState(
        viewModel: _foodCreatorViewModel!,
        saveEnabled: _foodCreatorViewModel!.validate,
      ));
      emit(UpdateRequiredNutritionFactsSuccessBuilderState());
    }
  }

  FutureOr<void> _handleDoUpdateOtherNutritionFactsEvent(
      DoUpdateOtherNutritionFactsEvent event,
      Emitter<FoodCreatorState> emit) async {
    _foodCreatorViewModel = _foodCreatorViewModel?.updateOtherNutritionFacts(
      newSatFat: event.satFat,
      newTransFat: event.transFat,
      newCholesterol: event.cholesterol,
      newSodium: event.sodium,
      newDietaryFiber: event.dietaryFiber,
      newTotalSugars: event.totalSugars,
      newAddedSugars: event.addedSugars,
      newVitaminD: event.vitaminD,
      newCalcium: event.calcium,
      newPotassium: event.potassium,
    );
    if (_foodCreatorViewModel != null) {
      emit(UpdateOtherNutritionFactsSuccessListenerState(
        viewModel: _foodCreatorViewModel!,
        saveEnabled: _foodCreatorViewModel!.validate,
      ));
      emit(UpdateOtherNutritionFactsSuccessBuilderState());
    }
  }

  FutureOr<void> _handleDoSaveEvent(
      DoSaveEvent event, Emitter<FoodCreatorState> emit) async {
    if (_foodCreatorViewModel == null) return;

    final foodRecord = _foodCreatorViewModel!.toFoodRecord();

    final isUpdate = _userFoodRecord != null && _userFoodRecord!.id.isNotNullOrBlank;

    if (foodRecord.iconId.startsWith(AppCommonConstants.userFood)) {
      // Use image from viewModel if available; otherwise, load default image
      final image = _foodCreatorViewModel?.image ??
          (await rootBundle.load(AppImages.imgMyFoodsThumbnail))
              .buffer
              .asUint8List();

      await _connector.updateUserFoodImage(
        id: foodRecord.iconId,
        image: image,
        isNew: !isUpdate,
      );
    }

    foodRecord.removeMeal();
    final userFoodId = await _connector.updateUserFood(
      foodRecord: foodRecord,
      isNew: !isUpdate,
    );

    if (_logUponCreate) {
      foodRecord.id = _loggedFoodRecord?.id ?? '';
      foodRecord.refCode = '${AppCommonConstants.userFood}$userFoodId';
      foodRecord
          .setCreatedAt(_loggedFoodRecord?.getCreatedAt() ?? DateTime.now());
      foodRecord.mealLabel = _loggedFoodRecord?.mealLabel;
      await _connector.updateRecord(foodRecord: foodRecord, isNew: false);
    }

    // Emit a success state
    emit(const SaveSuccessState());
  }
}
