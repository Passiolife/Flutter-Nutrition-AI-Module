import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/domain/use_cases/nutrition_ai/get_food_records_by_image_recognition.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/models/food_record/meal_label.dart';
import '../../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../../common/util/user_session.dart';
import '../../../../../nutrition_ai_module_configuration.dart';
import '../../models/take_photo_result_view_model.dart';

part 'take_photo_result_event.dart';
part 'take_photo_result_state.dart';

class TakePhotoResultBloc
    extends Bloc<TakePhotoResultEvent, TakePhotoResultState> {
  // Views Properties
  late TakePhotoResultViewModel _viewModel;

  final GetFoodRecordsByImageRecognition foodRecordsByImageRecognition;
  final NutritionConfiguration nutritionConfiguration;

  double caloriesTarget = 0;
  double carbsTarget = 0;
  double proteinTarget = 0;
  double fatTarget = 0;

  TakePhotoResultBloc({
    required this.nutritionConfiguration,
    required this.foodRecordsByImageRecognition,
  }) : super(const TakePhotoResultInitial()) {
    on<InitializeEvent>(_handleInitializeEvent);
    on<SetDefaultHeaderEvent>(_handleSetDefaultMealLabelEvent);
    on<UpdateMealLabelEvent>(_handleUpdateMealLabelEvent);
    on<UpdateTimeStampEvent>(_handleUpdateTimeStampEvent);
    on<SelectFoodItemEvent>(_handleSelectFoodItemEvent);
    on<UpdateMacroNutrientEvent>(_handleUpdateMacroNutrientEvent);
    on<UpdateActionButtonsEvent>(_handleUpdateActionButtonsEvent);
    on<DoProcessEvent>(_handleDoProcessEvent);
    on<UpdateServingSizeEvent>(_handleUpdateServingSizeEvent);
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
    emit(UpdateMacroNutrientState(viewModel: _viewModel));
  }

  Future<void> _handleUpdateActionButtonsEvent(UpdateActionButtonsEvent event,
      Emitter<TakePhotoResultState> emit) async {
    emit(UpdateActionButtonsState(viewModel: _viewModel));
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
      List<FoodRecord> dayRecords = await nutritionConfiguration.connector
          .fetchDayRecords(dateTime: _viewModel.dateTime);

      caloriesTarget = profileModel.caloriesTarget -
          dayRecords.fold(
              0, (previous, element) => previous + element.totalCalories);
      carbsTarget = profileModel.carbsGram -
          dayRecords.fold(
              0, (previous, element) => previous + element.totalCarbs);
      proteinTarget = profileModel.proteinGram -
          dayRecords.fold(
              0, (previous, element) => previous + element.totalProteins);
      fatTarget = profileModel.fatGram -
          dayRecords.fold(
              0, (previous, element) => previous + element.totalFat);

      _viewModel = _viewModel.updateMacroNutrientsTarget(
          caloriesTarget, carbsTarget, proteinTarget, fatTarget);

      _viewModel = _viewModel.fromFoodRecords(result.response);

      add(UpdateMacroNutrientEvent());
      add(UpdateActionButtonsEvent());
      emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
      return;
    }
  }

  Future<void> _handleUpdateServingSizeEvent(
      UpdateServingSizeEvent event, Emitter<TakePhotoResultState> emit) async {
    final index = event.index;
    final foodRecord = event.foodRecord;
    _viewModel = _viewModel.updateFoodRecord(index, foodRecord);
    add(UpdateMacroNutrientEvent());
    add(UpdateActionButtonsEvent());
    emit(ResultsSuccessState(foodRecordsViewModel: _viewModel.foodRecords));
  }
}
