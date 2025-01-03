import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/domain/use_cases/nutrition_ai/get_food_records_by_image_recognition.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/models/food_record/meal_label.dart';
import '../../models/take_photo_result_view_model.dart';

part 'take_photo_result_event.dart';
part 'take_photo_result_state.dart';

class TakePhotoResultBloc
    extends Bloc<TakePhotoResultEvent, TakePhotoResultState> {
  // Views Properties
  TakePhotoResultViewModel _viewModel = TakePhotoResultViewModel.init();

  final GetFoodRecordsByImageRecognition foodRecordsByImageRecognition;

  TakePhotoResultBloc({required this.foodRecordsByImageRecognition})
      : super(const TakePhotoResultInitial()) {
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
      final response = await foodRecordsByImageRecognition.call(capturedImages);
      /*final foodRecords = (await foodRepository
              .getFoodRecordsByImageRecognition(capturedImages))
          .whereType<FoodRecord>()
          .toList();*/
      _viewModel = _viewModel.fromFoodRecords(response.response);

      emit(const FinishGeneratingResultsState());

      await Future.delayed(const Duration(milliseconds: 700));

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
