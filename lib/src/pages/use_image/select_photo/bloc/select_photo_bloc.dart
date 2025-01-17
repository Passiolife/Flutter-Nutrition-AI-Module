import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';

part 'select_photo_event.dart';
part 'select_photo_state.dart';

class SelectPhotoBloc extends Bloc<SelectPhotoEvent, SelectPhotoState> {
  final ImagePicker picker = ImagePicker();

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  SelectPhotoBloc() : super(const SelectPhotoInitial()) {
    on<DoPhotoPickerEvent>(_handleDoPhotoPickerEvent);
    on<DoRecognizeImageEvent>(_handleDoRecognizeImageEvent);
    on<UpdateSelectionEvent>(_handleUpdateSelectionEvent);
    on<ClearSelectionEvent>(_handleClearSelectionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  FutureOr<void> _handleDoPhotoPickerEvent(
      DoPhotoPickerEvent event, Emitter<SelectPhotoState> emit) async {
    List<XFile> images = event.maxLimit > 2
        ? (await picker.pickMultiImage(limit: event.maxLimit))
        : [(await picker.pickImage(source: ImageSource.gallery))]
            .whereType<XFile>()
            .toList();
    if (images.isNotEmpty) {
      if (images.length > event.maxLimit) {
        emit(const RecognizeImageFailureListenerState());
        emit(const PhotoPickerFailureListenerState());
        return;
      }
      if (!event.returnResult) {
        add(DoRecognizeImageEvent(images: images));
      }
      final futureImagesBytes = images.map((e) async => e.readAsBytes()).toList();
      final imagesBytes = await Future.wait(futureImagesBytes);

      emit(PhotoPickerSuccessListenerState(images: images, returnResult: event.returnResult, imagesBytes: imagesBytes));
      emit(const PhotoPickerSuccessBuilderState());
    } else {
      if (event.from == null) {
        emit(const PhotoPickerFailureListenerState());
      }
    }
  }

  FutureOr<void> _handleDoRecognizeImageEvent(
      DoRecognizeImageEvent event, Emitter<SelectPhotoState> emit) async {
    final result = await Future.wait(event.images.map((e) async =>
        NutritionAI.instance.recognizeImageRemote(await e.readAsBytes())));
    final advisorFoodInfoList = result.expand((e) => e).toList();
    final advisorFoodInfoLogList =
        advisorFoodInfoList.toAdvisorFoodInfoLogList();
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  FutureOr<void> _handleUpdateSelectionEvent(
      UpdateSelectionEvent event, Emitter<SelectPhotoState> emit) async {
    final advisorFoodInfoLogList = event.data?.toggleSelectionFor(event.index);
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  void _updateVoiceLogsAndEmit(
      List<AdvisorFoodInfoLog>? data, Emitter<SelectPhotoState> emit) {
    emit(RecognizeImageSuccessListenerState(data: data));
    emit(const RecognizeImageSuccessBuilderState());
  }

  FutureOr<void> _handleClearSelectionEvent(
      ClearSelectionEvent event, Emitter<SelectPhotoState> emit) async {
    final advisorFoodInfoLogList = event.data?.clearSelection();
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<SelectPhotoState> emit) async {
    emit(const FoodLogLoadingListenerState());
    emit(const FoodLogLoadingBuilderState());

    final selectedLogs = event.data?.where((e) => e.isSelected).toList();

    if (selectedLogs == null || selectedLogs.isEmpty) {
      emit(const FoodLogSuccessListenerState());
      return;
    }

    try {
      List<FoodRecord?> foodRecords =
          await Future.wait(selectedLogs.map((element) async {
        final advisorFoodInfo = element.advisorFoodInfoModel;
        final foodDataInfo = advisorFoodInfo?.foodDataInfo;
        if (foodDataInfo == null) return null;

        try {
          final nutritionPreview = foodDataInfo.nutritionPreview;
          final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
            foodDataInfo,
            servingQuantity: nutritionPreview.servingQuantity,
            servingUnit: nutritionPreview.servingUnit,
          );
          if (foodItem == null) return null;

          final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

          return foodRecord;
        } catch (e) {
          return null;
        }
      }).toList());

      // Remove any null values resulting from failed fetch operations
      foodRecords = foodRecords.where((record) => record != null).toList();

      // Update records concurrently using Future.wait
      await Future.wait(foodRecords.map((foodRecord) async {
        try {
          await _connector.updateRecord(foodRecord: foodRecord!, isNew: true);
        } catch (e) {
          emit(const FoodLogFailureListenerState());
        }
      }));

      emit(const FoodLogSuccessListenerState());
    } catch (e) {
      emit(const FoodLogFailureListenerState());
    }
  }
}
