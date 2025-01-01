import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/data/repository/food_recpository.dart';
import '../../../../../common/models/food_item_model.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/models/food_record/meal_label.dart';

part 'take_photo_result_event.dart';
part 'take_photo_result_state.dart';

class TakePhotoResultBloc
    extends Bloc<TakePhotoResultEvent, TakePhotoResultState> {
  // Views Properties
  List<FoodRecord> _foodRecords = [];
  List<FoodItemModel> _foodItems = [];
  MealLabel? _mealLabel;
  DateTime? _timeStamp;

  final FoodRepository foodRepository;

  TakePhotoResultBloc({required this.foodRepository})
      : super(const TakePhotoResultInitial()) {
    on<InitializeEvent>(_handleInitializeEvent);
    on<SetDefaultHeaderEvent>(_handleSetDefaultMealLabelEvent);
    on<UpdateMealLabelEvent>(_handleUpdateMealLabelEvent);
    on<UpdateTimeStampEvent>(_handleUpdateTimeStampEvent);
    on<DoProcessEvent>(_handleDoProcessEvent);
  }

  Future<void> _handleInitializeEvent(
      InitializeEvent event, Emitter<TakePhotoResultState> emit) async {
    _foodRecords = [];
    emit(const TakePhotoResultInitial());
  }

  Future<void> _handleSetDefaultMealLabelEvent(SetDefaultHeaderEvent event,
      Emitter<TakePhotoResultState> emit) async {
    _timeStamp = DateTime.now().toUtc();
    _mealLabel = MealLabel.dateToMealLabel(_timeStamp!);
    if (_mealLabel == null) return;

    emit(UpdateHeaderState(mealLabel: _mealLabel!, timeStamp: _timeStamp!));
  }

  Future<void> _handleUpdateMealLabelEvent(UpdateMealLabelEvent event,
      Emitter<TakePhotoResultState> emit) async {
    _mealLabel = event.mealLabel;
  }


  Future<void> _handleUpdateTimeStampEvent(UpdateTimeStampEvent event,
      Emitter<TakePhotoResultState> emit) async {
    _timeStamp = event.timeStamp;
  }

  Future<void> _handleDoProcessEvent(
      DoProcessEvent event, Emitter<TakePhotoResultState> emit) async {
    add(SetDefaultHeaderEvent());
    final capturedImages = event.images;
    if (capturedImages != null) {
      _foodRecords = (await foodRepository
              .getFoodRecordsByImageRecognition(capturedImages))
          .whereType<FoodRecord>()
          .toList();
      _foodItems = _foodRecords
          .expand<FoodItemModel>((e) => [FoodItemModel.fromFoodRecord(e)])
          .toList();

      emit(const FinishGeneratingResultsState());

      await Future.delayed(const Duration(milliseconds: 700));

      emit(ResultsSuccessState(foodItems: _foodItems));
      return;
    }

    // emit(TakePhotoResultProcessing(images: event.images));
  }
}
