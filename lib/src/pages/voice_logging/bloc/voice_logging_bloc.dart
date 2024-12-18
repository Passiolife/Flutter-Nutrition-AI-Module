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

  List<VoiceLog>? _recognitionLogs;

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  bool _isListening = false;
  bool _isProcessing = false;
  String _recognizedWords = '';
  bool _visibleLoadingForLog = false;

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
    on<TryAgainEvent>(_handleTryAgainEvent);
  }

  FutureOr<void> _handleStartListeningEvent(
      StartListeningEvent event, Emitter<VoiceLoggingState> emit) async {
    _isInitialized ??= await SpeechToTextUtil.instance.initialize(
      statusListener: _statusListener,
      errorListener: _errorListener,
    );
    if (_isInitialized ?? false) {
      _recognitionLogs = null;
      SpeechToTextUtil.instance.startListening(
        recognizedWords: _recognizeWords,
        finalResult: false,
      );
      _recognizedWords = '';
      _isListening = true;
      emit(ListeningUpdateBuilderState(isListening: _isListening));

    } else {
      add(const ErrorEvent());
    }
  }

  FutureOr<void> _handleStopListeningEvent(
      StopListeningEvent event, Emitter<VoiceLoggingState> emit) async {
    SpeechToTextUtil.instance.stopListening();

    _isListening = false;
    emit(ListeningUpdateBuilderState(isListening: _isListening));
    add(RecognizeSpeechRemoteEvent(text: _recognizedWords));
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
    _recognizedWords = event.words;
    emit(RecognizeBuilderState(recognizeWords: _recognizedWords));
  }

  FutureOr<void> _handleRecognizeSpeechRemoteEvent(
      RecognizeSpeechRemoteEvent event, Emitter<VoiceLoggingState> emit) async {
    try {
      _isProcessing = true;
      emit(ProcessingUpdateBuilderState(isProcessing: _isProcessing));

      final result =
          await NutritionAI.instance.recognizeSpeechRemote(event.text);
      _recognitionLogs = result.toVoiceLogList();

      _isProcessing = false;
      emit(ProcessingUpdateBuilderState(isProcessing: _isProcessing));

      if (_recognitionLogs?.isEmpty ?? true) {
        emit(const VoiceLogsRecognitionErrorListenerState());
        return;
      }

      emit(RecognizeVoiceLogsSuccessState(data: _recognitionLogs));

    } on Exception catch (e) {
      log('Exception: $e');
    }
  }

  FutureOr<void> _handleUpdateSelectionEvent(
      UpdateSelectionEvent event, Emitter<VoiceLoggingState> emit) async {
    _recognitionLogs = _recognitionLogs?.toggleSelectionFor(event.index);
    emit(UpdateRecognizeVoiceLogsState(data: _recognitionLogs, timeStamp: DateTime.now().millisecondsSinceEpoch));
    // _updateVoiceLogsAndEmit(emit);
  }

  FutureOr<void> _handleClearSelectionEvent(
      ClearSelectionEvent event, Emitter<VoiceLoggingState> emit) {
    _recognitionLogs = _recognitionLogs?.clearSelection();
    emit(UpdateRecognizeVoiceLogsState(data: _recognitionLogs, timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<VoiceLoggingState> emit) async {
    _visibleLoadingForLog = true;
    emit(FoodLogLoadingBuilderState(isLogLoading: _visibleLoadingForLog, data: _recognitionLogs));

    final selectedLogs = _recognitionLogs?.where((e) => e.isSelected).toList();

    if (selectedLogs == null || selectedLogs.isEmpty) {
      emit(const FoodLogSuccessListenerState());
      return;
    }

    List<FoodRecord> foodRecords = [];

    for (var element in selectedLogs) {
      final foodDataInfo = element.recognitionModel?.advisorInfo.foodDataInfo;
      if (foodDataInfo == null) continue;

      try {
        final nutritionPreview = foodDataInfo.nutritionPreview;
        final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
          foodDataInfo,
          servingQuantity: nutritionPreview.servingQuantity,
          servingUnit: nutritionPreview.servingUnit,
        );
        if (foodItem == null) continue;

        final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

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

    _visibleLoadingForLog = false;
    emit(const FoodLogSuccessListenerState());
  }

  FutureOr<void> _handleDoDisposeEvent(
      DoCancelEvent event, Emitter<VoiceLoggingState> emit) {
    SpeechToTextUtil.instance.cancel();
  }


  FutureOr<void> _handleTryAgainEvent(TryAgainEvent event, Emitter<VoiceLoggingState> emit) {
    _reset();
    emit(VoiceLoggingInitial());
  }

  void _reset() {
    _isListening = false;
    _isProcessing = false;
    _recognizedWords = '';
    _recognitionLogs = null;
  }
}
