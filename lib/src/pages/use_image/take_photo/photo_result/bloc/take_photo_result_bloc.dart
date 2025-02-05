import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/domain/repository/nutrition_ai_repository.dart';
import '../../../../../common/domain/use_cases/custom_food/add_custom_foods_use_case.dart';
import '../../../../../common/domain/use_cases/custom_food/create_custom_food_ingredient_use_case.dart';
import '../../../../../common/domain/use_cases/custom_food/save_custom_food_use_case.dart';
import '../../../../../common/domain/use_cases/food_logs/add_food_logs_use_case.dart';
import '../../../../../common/domain/use_cases/nutrition_ai/get_food_records_by_image_recognition.dart';
import '../../../../../common/models/daily_nutrition_model.dart';
import '../../../../../common/util/user_session.dart';
import '../../../../../nutrition_ai_module_configuration.dart';
import '../models/take_photo_result_view_model.dart';

part 'take_photo_result_event.dart';
part 'take_photo_result_state.dart';

class TakePhotoResultBloc
    extends Bloc<TakePhotoResultEvent, TakePhotoResultState> {
  // Views Properties
  TakePhotoResultViewModel _viewModel = TakePhotoResultViewModel.init();

  final GetFoodRecordsByImageRecognition foodRecordsByImageRecognition;
  final NutritionConfiguration nutritionConfiguration;
  final AddFoodLogsUseCase addFoodLogsUseCase;

  final AddCustomFoodUseCase addCustomFoodUseCase;
  final AddCustomFoodsUseCase addCustomFoodsUseCase;
  final CreateCustomFoodIngredientUseCase createCustomFoodIngredientUseCase;
  final NutritionAIRepository nutritionAIRepository;

  double caloriesTarget = 0;
  double carbsTarget = 0;
  double proteinTarget = 0;
  double fatTarget = 0;

  TakePhotoResultBloc({
    required this.nutritionConfiguration,
    required this.foodRecordsByImageRecognition,
    required this.addCustomFoodUseCase,
    required this.addFoodLogsUseCase,
    required this.addCustomFoodsUseCase,
    required this.createCustomFoodIngredientUseCase,
    required this.nutritionAIRepository,
  }) : super(const TakePhotoResultInitial()) {
    on<InitializeEvent>(_handleInitializeEvent);
    on<SetDefaultHeaderEvent>(_handleSetDefaultMealLabelEvent);
    on<UpdateMealLabelEvent>(_handleUpdateMealLabelEvent);
    on<UpdateTimeStampEvent>(_handleUpdateTimeStampEvent);
    on<SelectFoodItemEvent>(_handleSelectFoodItemEvent);
    on<UpdateMacroNutrientEvent>(_handleUpdateMacroNutrientEvent);
    on<UpdateActionButtonsEvent>(_handleUpdateActionButtonsEvent);
    on<DoProcessEvent>(_handleDoProcessEvent);
    on<UpdateFoodRecordEvent>(_handleUpdateFoodRecordEvent);
    on<CreateCustomFoodEvent>(_handleCreateCustomFoodEvent);
    on<DoLogEvent>(_handleDoLogEvent);
    on<UpdateNotRecognizedFoodEvent>(_handleUpdateNotRecognizedFoodEvent);
  }

  Future<void> _handleInitializeEvent(
      InitializeEvent event, Emitter<TakePhotoResultState> emit) async {
    _viewModel = TakePhotoResultViewModel.init();

    emit(const TakePhotoResultInitial());
  }

  Future<void> _handleSetDefaultMealLabelEvent(
      SetDefaultHeaderEvent event, Emitter<TakePhotoResultState> emit) async {
    emit(UpdateHeaderState(viewModel: _viewModel));
  }

  Future<void> _handleUpdateMealLabelEvent(
      UpdateMealLabelEvent event, Emitter<TakePhotoResultState> emit) async {
    _viewModel = _viewModel.updateMealLabel(event.mealLabel);
  }

  Future<void> _handleUpdateTimeStampEvent(
      UpdateTimeStampEvent event, Emitter<TakePhotoResultState> emit) async {
    final dateTime = event.timeStamp;
    if (dateTime == null) return;
    _viewModel = _viewModel.updateDateTime(dateTime);
  }

  Future<void> _handleSelectFoodItemEvent(
      SelectFoodItemEvent event, Emitter<TakePhotoResultState> emit) async {
    final index = event.index;
    final isSelected = event.isSelected;
    _viewModel = _viewModel.updateIsSelected(index, isSelected);
    add(UpdateMacroNutrientEvent());
    add(UpdateActionButtonsEvent());
  }

  Future<void> _handleUpdateMacroNutrientEvent(UpdateMacroNutrientEvent event,
      Emitter<TakePhotoResultState> emit) async {
    _viewModel = _viewModel.updateMacroNutrients();
    emit(UpdateMacroNutrientState(listMacros: _viewModel.listMacros));
  }

  Future<void> _handleUpdateActionButtonsEvent(UpdateActionButtonsEvent event,
      Emitter<TakePhotoResultState> emit) async {
    emit(UpdateActionButtonsState(
        viewModel: _viewModel,
        timestamp: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> _handleDoProcessEvent(
      DoProcessEvent event, Emitter<TakePhotoResultState> emit) async {
    add(SetDefaultHeaderEvent());
    final capturedImages = event.images;
    if (capturedImages != null) {
      final result = await foodRecordsByImageRecognition.call(capturedImages);

      emit(const FinishGeneratingResultsState());

      await Future.delayed(const Duration(milliseconds: 700));

      if (result.response.isEmpty) {
        emit(const ResultFailureState());
        return;
      }

      final profileModel =
          UserProfileModel.fromJson(UserSession.instance.userProfile!.toJson());

      caloriesTarget = profileModel.caloriesTarget.toDouble();
      carbsTarget = profileModel.carbsGram.toDouble();
      proteinTarget = profileModel.proteinGram.toDouble();
      fatTarget = profileModel.fatGram.toDouble();

      _viewModel = _viewModel.updateMacroNutrientsTarget(
          caloriesTarget, carbsTarget, proteinTarget, fatTarget);

      _viewModel = _viewModel.fromFoodRecords(result.response);

      add(UpdateMacroNutrientEvent());
      add(UpdateActionButtonsEvent());
      emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
      return;
    }
  }

  Future<void> _handleUpdateFoodRecordEvent(
      UpdateFoodRecordEvent event, Emitter<TakePhotoResultState> emit) async {
    final index = event.index;
    final foodRecord = event.foodRecord;
    _viewModel = _viewModel.updateFoodRecord(index, foodRecord);
    add(UpdateMacroNutrientEvent());
    add(UpdateActionButtonsEvent());
    emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
  }

  Future<void> _handleCreateCustomFoodEvent(
      CreateCustomFoodEvent event, Emitter<TakePhotoResultState> emit) async {
    final index = event.index;
    final foodRecord = event.foodRecord;
    final image = event.image;

    FoodRecordViewModel foodRecordViewModel =
        _viewModel.foodRecords.elementAt(index);

    bool isNew = !foodRecordViewModel.isSaved;

    // Show when it is first time.
    if (isNew) {
      emit(const CustomFoodCreatedState());
    }

    final id = await addCustomFoodUseCase.call(
      foodRecord: foodRecord,
      image: image,
      isNew: isNew,
    );
    foodRecord.id = id;

    bool shouldSelect = foodRecordViewModel.isBarcodeNotFound ||
        foodRecordViewModel.hasMissingData;
    foodRecordViewModel = foodRecordViewModel
        .updateFoodRecord(foodRecord)
        .updateIsSaved(true)
        .updateIsBarcodeNotFound(false)
        .updateHasMissingData(false);

    if (shouldSelect) {
      foodRecordViewModel = foodRecordViewModel.updateIsSelected(shouldSelect);
    }

    _viewModel =
        _viewModel.updateFoodRecordViewModel(index, foodRecordViewModel);
    add(UpdateMacroNutrientEvent());
    add(UpdateActionButtonsEvent());
    emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<TakePhotoResultState> emit) async {
    _viewModel.isLogLoading = true;
    emit(UpdateActionButtonsState(
      viewModel: _viewModel,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));

    // Create custom food which are not saved logic.
    final List<({FoodRecord foodRecord, Uint8List? image})> unsavedFoodRecords =
        getUnsavedFoodRecords();

    final List<({FoodRecord foodRecord, Uint8List? image})>
        unsavedCustomFoodRecords =
        await getUnsavedCustomFoodRecords(unsavedFoodRecords);

    final customFoodResult = await addCustomFoodsUseCase.call(
      data: unsavedCustomFoodRecords,
      isNew: true,
    );

    List<FoodRecord> unsavedCustomFoodRecordsUpdated =
        unsavedCustomFoodRecords.asMap().entries.map((e) {
      final insertId = customFoodResult.elementAt(e.key);
      e.value.foodRecord.id = insertId;
      return e.value.foodRecord;
    }).toList();

    // End: Create custom food which are not saved.

    List<FoodRecord> savedFoodRecords = _viewModel.foodRecords
        .where((element) {
          return element.isSelected &&
              (element.isSaved ||
                  element.foodRecord?.resultType !=
                      PassioFoodResultType.nutritionFacts);
        })
        .map((e) => e.foodRecord)
        .whereType<FoodRecord>()
        .toList();

    final customFoodRecords =
        unsavedCustomFoodRecordsUpdated + savedFoodRecords;

    final selectedDateTime = _viewModel.dateTime;
    final selectedMealLabel = _viewModel.mealLabel;
    for (var element in customFoodRecords) {
      element.refCode =
          element.resultType == PassioFoodResultType.nutritionFacts
              ? '${FoodRecord.userFoodPrefix}${element.id}'
              : '';
      element.logMeal(dateTime: selectedDateTime);
      element.mealLabel = selectedMealLabel;
    }
    await addFoodLogsUseCase.call(customFoodRecords);

    _viewModel.isLogLoading = false;
    emit(UpdateActionButtonsState(
        viewModel: _viewModel,
        timestamp: DateTime.now().millisecondsSinceEpoch));
    emit(FoodLogSuccessState(
        foodLogCount: customFoodRecords.length,
        customFoodCount: unsavedCustomFoodRecords.length));
  }

  Future<List<({FoodRecord foodRecord, Uint8List? image})>>
      getUnsavedCustomFoodRecords(
          List<({FoodRecord foodRecord, Uint8List? image})>
              unsavedFoodRecords) async {
    final futures = unsavedFoodRecords
        .where((e) =>
            e.foodRecord.resultType == PassioFoodResultType.nutritionFacts)
        .map((item) async {
      final record = item.foodRecord;
      final image = item.image;

      final ingredient = await createCustomFoodIngredientUseCase.call(
        ingredient: record.ingredients.firstOrNull,
        id: record.id,
        name: record.name,
        iconId: image == null ? record.iconId : null,
        selectedQuantity: record.getSelectedQuantity(),
        selectedUnit: record.getSelectedUnit(),
        servingWeight: record.computedWeight.value,
        barcode: record.barcode,
      );

      return (
        foodRecord: FoodRecord.fromFoodRecordIngredient(ingredient),
        image: image,
      );
    });

    return Future.wait(futures);
  }

  List<({FoodRecord foodRecord, Uint8List? image})> getUnsavedFoodRecords() {
    return _viewModel.foodRecords
        .where((element) => element.isSelected && !element.isSaved)
        .map((e) {
          if (e.foodRecord == null) {
            return null;
          }
          e.foodRecord?.removeMeal();
          return (foodRecord: e.foodRecord, image: e.image);
        })
        .whereType<({FoodRecord foodRecord, Uint8List? image})>()
        .toList();
  }

  Future<void> _handleUpdateNotRecognizedFoodEvent(
      UpdateNotRecognizedFoodEvent event,
      Emitter<TakePhotoResultState> emit) async {
    final index = event.index;
    FoodRecord? foodRecord = event.foodRecord;
    final foodDataInfo = event.foodDataInfo;

    if (foodRecord == null && foodDataInfo == null) {
      return;
    }
    if (foodDataInfo != null) {
      final data =
          await nutritionAIRepository.fetchFoodItemForDataInfo(foodDataInfo);
      if (data == null) {
        return;
      }
      foodRecord = FoodRecord.fromPassioFoodItem(data);
    }
    FoodRecordViewModel foodRecordViewModel =
        _viewModel.foodRecords.elementAt(index);

    final updatedFoodRecordViewModel = FoodRecordViewModel(
      foodRecord: foodRecord,
      image: foodRecord?.resultType != PassioFoodResultType.foodItem
          ? foodRecordViewModel.image
          : null,
    );
    _viewModel =
        _viewModel.updateFoodRecordViewModel(index, updatedFoodRecordViewModel);
    add(UpdateMacroNutrientEvent());
    add(UpdateActionButtonsEvent());
    emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
  }
}
