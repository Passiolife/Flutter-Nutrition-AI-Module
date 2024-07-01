import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import '../../../../common/models/settings/settings.dart';
import '../../../../common/util/flutter_image_compress_util.dart';
import '../../../../common/util/string_extensions.dart';

part 'take_photo_event.dart';
part 'take_photo_state.dart';

class TakePhotoBloc extends Bloc<TakePhotoEvent, TakePhotoState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  TakePhotoBloc() : super(const TakePhotoInitialBuilderState()) {
    on<DoCheckIntroScreenEvent>(_handleDoCheckIntroScreenEvent);
    on<DoIntroScreenCompletedEvent>(_handleDoIntroScreenCompletedEvent);
    on<InitialEvent>(_handleInitialEvent);
    on<DoNextEvent>(_handleDoNextEvent);
    on<DoTakeImageEvent>(_handleDoTakeImageEvent);
    on<DoRemoveImageEvent>(_handleDoRemoveImageEvent);
    on<DoRecognizeImageEvent>(_handleDoRecognizeImageEvent);
    on<UpdateSelectionEvent>(_handleUpdateSelectionEvent);
    on<ClearSelectionEvent>(_handleClearSelectionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  FutureOr<void> _handleDoCheckIntroScreenEvent(
      DoCheckIntroScreenEvent event, Emitter<TakePhotoState> emit) {
    final seen = Settings.instance.getTakePictureIntroSeen();
    if (seen) {
      add(const DoIntroScreenCompletedEvent());
    } else {
      emit(const ShowIntroDialogListenerState());
    }
  }

  FutureOr<void> _handleDoIntroScreenCompletedEvent(
      DoIntroScreenCompletedEvent event, Emitter<TakePhotoState> emit) {
    if (event.fromDialog) {
      Settings.instance.setTakePictureIntroSeen(true);
    }
    emit(const IntroDialogSeenListenerState());
    emit(const IntroDialogSeenBuilderState());
  }

  FutureOr<void> _handleInitialEvent(
      InitialEvent event, Emitter<TakePhotoState> emit) {
    emit(const TakePhotoInitialListenerState());
    emit(const TakePhotoInitialBuilderState());
  }

  Future<void> _handleDoNextEvent(
      DoNextEvent event, Emitter<TakePhotoState> emit) async {
    add(DoRecognizeImageEvent(images: event.images));
    emit(const RecognizeImageLoadingListenerState());
    emit(const RecognizeImageSuccessBuilderState());
  }

  FutureOr<void> _handleDoTakeImageEvent(
      DoTakeImageEvent event, Emitter<TakePhotoState> emit) async {
    if (event.file != null) {
      final bytes =
          await FlutterImageCompressUtil.angleCorrect(event.file!.path);
      final resizedBytes = await FlutterImageCompressUtil.compress(
        event.file!.path,
        minWidth: 200,
        minHeight: 200,
      );
      if (bytes != null && resizedBytes != null) {
        emit(TakePhotoSuccessListenerState(
            originalBytes: bytes, compressedBytes: resizedBytes));
        emit(const TakePhotoSuccessBuilderState());
      }
    }
  }

  FutureOr<void> _handleDoRemoveImageEvent(
      DoRemoveImageEvent event, Emitter<TakePhotoState> emit) async {
    emit(RemovePhotoListenerState(index: event.index));
    emit(const RemoveImageBuilderState());
  }

  FutureOr<void> _handleDoRecognizeImageEvent(
      DoRecognizeImageEvent event, Emitter<TakePhotoState> emit) async {
    final result = await Future.wait(event.images
        .map((e) async => NutritionAI.instance.recognizeImageRemote(e)));
    final advisorFoodInfoList = result.expand((e) => e).toList();
    final advisorFoodInfoLogList =
        advisorFoodInfoList.toAdvisorFoodInfoLogList();
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  FutureOr<void> _handleUpdateSelectionEvent(
      UpdateSelectionEvent event, Emitter<TakePhotoState> emit) async {
    final advisorFoodInfoLogList = event.data?.toggleSelectionFor(event.index);
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  FutureOr<void> _handleClearSelectionEvent(
      ClearSelectionEvent event, Emitter<TakePhotoState> emit) async {
    final advisorFoodInfoLogList = event.data?.clearSelection();
    _updateVoiceLogsAndEmit(advisorFoodInfoLogList, emit);
  }

  void _updateVoiceLogsAndEmit(
      List<AdvisorFoodInfoLog>? data, Emitter<TakePhotoState> emit) {
    emit(RecognizeImageSuccessListenerState(data: data));
    emit(const RecognizeImageSuccessBuilderState());
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<TakePhotoState> emit) async {
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
          final foodItem =
              await NutritionAI.instance.fetchFoodItemForDataInfo(foodDataInfo);
          if (foodItem == null) return null;

          final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

          final unitAndQuantity =
              advisorFoodInfo?.portionSize.extractNumberAndString();
          bool hasUnit = false;
          if (unitAndQuantity != null && unitAndQuantity.string != null) {
            hasUnit = foodRecord.setSelectedUnit(unitAndQuantity.string!);
          }
          if (!hasUnit) {
            foodRecord.setSelectedUnit('gram');
          }

          double quantity = hasUnit
              ? unitAndQuantity?.number ?? 1
              : advisorFoodInfo?.weightGrams ?? 1;
          foodRecord.setSelectedQuantity(quantity);
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
