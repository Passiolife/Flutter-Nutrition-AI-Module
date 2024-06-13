import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/models/voice_log/voice_log.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/speech_to_text_util.dart';
import '../../../common/util/string_extensions.dart';

part 'voice_logging_event.dart';
part 'voice_logging_state.dart';

class VoiceLoggingBloc extends Bloc<VoiceLoggingEvent, VoiceLoggingState> {
  bool? _isInitialized;
  String? _errorMessage;

  List<VoiceLog>? _voiceLogs;

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  VoiceLoggingBloc() : super(const VoiceLoggingInitial()) {
    on<StartListeningEvent>(_handleStartListeningEvent);
    on<ErrorEvent>(_handleErrorEvent);
    on<RecognizeEvent>(_handleRecognizeEvent);
    on<StopListeningEvent>(_handleStopListeningEvent);
    on<RecognizeSpeechRemoteEvent>(_handleRecognizeSpeechRemoteEvent);
    on<UpdateSelectionEvent>(_handleUpdateSelectionEvent);
    on<ClearSelectionEvent>(_handleClearSelectionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
    on<DoCancelEvent>(_handleDoDisposeEvent);
  }

  FutureOr<void> _handleStartListeningEvent(
      StartListeningEvent event, Emitter<VoiceLoggingState> emit) async {
    _isInitialized ??= await SpeechToTextUtil.instance.initialize(
      statusListener: _statusListener,
      errorListener: _errorListener,
    );
    if (_isInitialized ?? false) {
      _voiceLogs = null;
      SpeechToTextUtil.instance.startListening(
        recognizedWords: _recognizeWords,
        finalResult: false,
      );
      emit(const ListenerStateStarted());
    } else {
      add(const ErrorEvent());
    }
  }

  FutureOr<void> _handleStopListeningEvent(
      StopListeningEvent event, Emitter<VoiceLoggingState> emit) async {
    SpeechToTextUtil.instance.stopListening();

    emit(const ListenerStateStopped());
    emit(const ListenerStateStoppedBuilder());
  }

  FutureOr<void> _handleErrorEvent(
      ErrorEvent event, Emitter<VoiceLoggingState> emit) async {
    emit(ErrorListenerState(_errorMessage ?? ''));
  }

  void _errorListener(String? error) {
    if (error == 'error_no_match' || error == 'error_speech_timeout') {
      return;
    }
    _errorMessage = error;
    add(const ErrorEvent());
  }

  void _statusListener(String status) {
    if (status == 'done' && Platform.isAndroid) {
      add(const StopListeningEvent());
    }
  }

  void _recognizeWords(String recognizeWords) {
    add(RecognizeEvent(recognizeWords));
  }

  FutureOr<void> _handleRecognizeEvent(
      RecognizeEvent event, Emitter<VoiceLoggingState> emit) {
    emit(RecognizeListenerState(event.words));
    emit(const RecognizeBuilderState());
  }

  FutureOr<void> _handleRecognizeSpeechRemoteEvent(
      RecognizeSpeechRemoteEvent event, Emitter<VoiceLoggingState> emit) async {
    try {
      final result =
          await NutritionAI.instance.recognizeSpeechRemote(event.text);
      _voiceLogs = result.toVoiceLogList();
      _updateVoiceLogsAndEmit(emit);
    } on Exception catch (e) {
      log('Exception: $e');
    }
  }

  FutureOr<void> _handleUpdateSelectionEvent(
      UpdateSelectionEvent event, Emitter<VoiceLoggingState> emit) async {
    _voiceLogs = _voiceLogs?.toggleSelectionFor(event.index);
    _updateVoiceLogsAndEmit(emit);
  }

  FutureOr<void> _handleClearSelectionEvent(
      ClearSelectionEvent event, Emitter<VoiceLoggingState> emit) {
    _voiceLogs = _voiceLogs?.clearSelection();
    _updateVoiceLogsAndEmit(emit);
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<VoiceLoggingState> emit) async {
    emit(const FoodLogLoadingListenerState());
    emit(const FoodLogLoadingBuilderState());

    final selectedLogs = _voiceLogs?.where((e) => e.isSelected).toList();

    if (selectedLogs == null || selectedLogs.isEmpty) {
      emit(const FoodLogSuccessListenerState());
      return;
    }

    List<FoodRecord> foodRecords = [];

    for (var element in selectedLogs) {
      final foodDataInfo = element.recognitionModel?.advisorInfo.foodDataInfo;
      if (foodDataInfo == null) continue;

      try {
        final foodItem =
            await NutritionAI.instance.fetchFoodItemForDataInfo(foodDataInfo);
        if (foodItem == null) continue;

        final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

        ({double? number, String? string})? unitAndQuantity = element
            .recognitionModel?.advisorInfo.portionSize
            .extractNumberAndString();
        bool hasUnit = false;
        if (unitAndQuantity != null && unitAndQuantity.string != null) {
          hasUnit = foodRecord.setSelectedUnit(unitAndQuantity.string!);
        }
        if (!hasUnit) {
          foodRecord.setSelectedUnit('gram');
        }

        double quantity = hasUnit
            ? unitAndQuantity?.number ?? 1
            : element.recognitionModel?.advisorInfo.weightGrams ?? 1;
        foodRecord.setSelectedQuantity(quantity);

        if (element.recognitionModel?.date.isNotEmpty ?? false) {
          final dateTime =
              element.recognitionModel?.date.formatToDateTime(format2);
          foodRecord.logMeal(dateTime: dateTime);
        }
        if (element.recognitionModel?.mealTime != null) {
          final mealTime =
              element.recognitionModel?.mealTime?.name.toUpperCaseWord ?? '';
          foodRecord.mealLabel = MealLabel.stringToMealLabel(mealTime);
        }

        foodRecords.add(foodRecord);
      } catch (e) {
        emit(const FoodLogFailureListenerState());
      }
    }

    for (var foodRecord in foodRecords) {
      try {
        await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      } catch (e) {
        emit(const FoodLogFailureListenerState());
      }
    }

    emit(const FoodLogSuccessListenerState());
  }

  FutureOr<void> _handleDoDisposeEvent(
      DoCancelEvent event, Emitter<VoiceLoggingState> emit) {
    SpeechToTextUtil.instance.cancel();
  }

  void _updateVoiceLogsAndEmit(Emitter<VoiceLoggingState> emit) {
    if (_voiceLogs?.isEmpty ?? true) {
      emit(const VoiceLogsRecognitionErrorListenerState());
      return;
    }
    emit(VoiceLogsRecognitionSuccessListenerState(data: _voiceLogs));
    emit(const RecognizeVoiceLogsBuilderState());
  }
}
