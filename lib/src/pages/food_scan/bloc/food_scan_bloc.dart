import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/settings/settings.dart';

part 'food_scan_event.dart';

part 'food_scan_state.dart';

class FoodScanBloc extends Bloc<FoodScanEvent, FoodScanState>
    implements FoodRecognitionListener {
  /// [_connector] is use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  bool? _previousResultForDrag;

  @override
  void recognitionResults(FoodCandidates? foodCandidates,
      PlatformImage? image) {
    if (foodCandidates == null) {
      return;
    }

    // Adding a VisualDetectedEvent to the bloc
    add(DetectedEvent(
      barcodeCandidates: foodCandidates.barcodeCandidates,
      packagedFoodCandidates: foodCandidates.packagedFoodCandidates,
      detectedCandidates: foodCandidates.detectedCandidates,
    ));
  }

  FoodScanBloc() : super(FoodScanInitial()) {
    // Intro Dialog events
    on<IntroScreenEvent>(_handleIntroScreenEvent);
    on<IntroScreenCompleteEvent>(_handleIntroScreenCompleteEvent);

    // Scanning Events
    on<ScanningAnimationEvent>(_handleScanningAnimationEvent);
    on<StartScanningEvent>(_handleStartScanningEvent);
    on<StartFoodDetectionEvent>(_handleStartFoodDetectionEvent);
    on<StopFoodDetectionEvent>(_handleStopFoodDetectionEvent);
    on<DetectedEvent>(_handleDetectedEvent);

    // Scan dialog event
    on<BarcodeNotRecognizedEvent>(_handleBarcodeNotRecognizedEvent);
    on<ScanResultDragEvent>(_handleScanResultDragEvent);

    // Do log event
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
    on<AddedToDiaryVisibilityEvent>(_handleAddedToDiaryVisibilityEvent);

    // Barcode Not Recognized Events
    on<CancelBarcodeNotRecognizedEvent>(_handleCancelBarcodeNotRecognizedEvent);
    on<ScanNutritionFactsEvent>(_handleScanNutritionFactsEvent);
  }

  FutureOr<void> _handleIntroScreenEvent(IntroScreenEvent event,
      Emitter<FoodScanState> emit) async {
    bool shouldVisible;
    if (event.shouldVisible != null) {
      shouldVisible = event.shouldVisible ?? false;
      if (shouldVisible) {
        add(const StopFoodDetectionEvent());
        add(const ScanningAnimationEvent(shouldAnimate: false));
      }
    } else {
      shouldVisible = !Settings.instance.getScanIntroSeen();
    }
    // Check if the intro screen has been seen
    // Emit the state indicating whether the intro screen should be visible
    emit(IntroVisibilityState(shouldVisible: shouldVisible));
  }

  FutureOr<void> _handleIntroScreenCompleteEvent(IntroScreenCompleteEvent event,
      Emitter<FoodScanState> emit) {
    // Mark the intro screen as seen
    Settings.instance.setScanIntroSeen(true);
  }

  FutureOr<void> _handleStartScanningEvent(StartScanningEvent event,
      Emitter<FoodScanState> emit) async {
    emit(ScanningState());
    add(const StartFoodDetectionEvent());
  }

  FutureOr<void> _handleStartFoodDetectionEvent(StartFoodDetectionEvent event,
      Emitter<FoodScanState> emit) async {
    const detectionConfig = FoodDetectionConfiguration(
      detectVisual: true,
      detectBarcodes: true,
      detectPackagedFood: true,
      detectNutritionFacts: true,
    );
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  FutureOr<void> _handleStopFoodDetectionEvent(StopFoodDetectionEvent event,
      Emitter<FoodScanState> emit) async {
    NutritionAI.instance.stopFoodDetection();
  }

  FutureOr<void> _handleDetectedEvent(DetectedEvent event,
      Emitter<FoodScanState> emit) async {
    var barcodeCandidates = event.barcodeCandidates;
    var packagedFoodCandidates = event.packagedFoodCandidates;
    var detectedCandidates = event.detectedCandidates;

    PassioFoodItem? foodItem;
    if (barcodeCandidates == null &&
        packagedFoodCandidates == null &&
        detectedCandidates.isEmpty) {
      emit(ScanningState());
    } else {
      PassioID? passioID;
      String? foodName;
      String? iconId;
      List<DetectedCandidate> alternatives = [];

      if (barcodeCandidates?.firstOrNull != null) {
        foodItem = await NutritionAI.instance.fetchFoodItemForProductCode(barcodeCandidates!.first.value);
        if (foodItem == null) {
          add(const BarcodeNotRecognizedEvent(shouldVisible: true));
          return;
        }
        passioID = foodItem.id;
        foodName = foodItem.name;
        iconId = foodItem.iconId;
      } else if (packagedFoodCandidates?.firstOrNull != null) {
        foodItem = await NutritionAI.instance.fetchFoodItemForProductCode(
            packagedFoodCandidates!.first.packagedFoodCode);
        if (foodItem == null) {
          return;
        }
        passioID = foodItem.id;
        foodName = foodItem.name;
        iconId = foodItem.iconId;
      } else if (detectedCandidates.isNotEmpty) {
        final detectedCandidate = event.detectedCandidates.first;
        passioID = detectedCandidate.passioID;
        foodName = detectedCandidate.foodName;
        iconId = detectedCandidate.passioID;
        alternatives.addAll(detectedCandidate.alternatives);
        alternatives.addAll(event.detectedCandidates.skip(1));
      }
      if (passioID != null && foodName != null && iconId != null) {
        emit(ScanResultVisibilityState(
          passioID: passioID,
          foodName: foodName,
          iconId: iconId,
          alternatives: alternatives,
        ));
      }
    }
  }

  FutureOr<void> _handleBarcodeNotRecognizedEvent(
      BarcodeNotRecognizedEvent event, Emitter<FoodScanState> emit) async {
    if (event.shouldVisible) {
      add(const StopFoodDetectionEvent());
    } else {
      add(const StartScanningEvent());
    }
    emit(BarcodeNotRecognizedState(shouldVisible: event.shouldVisible));
  }

  FutureOr<void> _handleDoFoodLogEvent(DoFoodLogEvent event,
      Emitter<FoodScanState> emit) async {
/*    _connector.updateRecord(
      foodRecord: FoodRecord.from(
        passioIDAttributes: event.attributes,
        dateTime: event.dateTime,
      ),
      isNew: true,
    );
    add(const AddedToDiaryVisibilityEvent(true));*/
  }

  FutureOr<void> _handleAddedToDiaryVisibilityEvent(
      AddedToDiaryVisibilityEvent event, Emitter<FoodScanState> emit) {
    emit(AddedToDiaryVisibilityState(shouldVisible: event.shouldVisible));
  }

  FutureOr<void> _handleCancelBarcodeNotRecognizedEvent(
      CancelBarcodeNotRecognizedEvent event,
      Emitter<FoodScanState> emit) async {
    add(const StartFoodDetectionEvent());
    emit(const BarcodeNotRecognizedState(shouldVisible: false));
  }

  FutureOr<void> _handleScanNutritionFactsEvent(ScanNutritionFactsEvent event,
      Emitter<FoodScanState> emit) async {
    emit(const ShowNutritionFactsDialogState());
  }


  FutureOr<void> _handleScanResultDragEvent(ScanResultDragEvent event,
      Emitter<FoodScanState> emit) async {
    if (_previousResultForDrag != event.isCollapsed) {
      _previousResultForDrag = event.isCollapsed;
      print(event.isCollapsed);
      add(event.isCollapsed
          ? const StartFoodDetectionEvent()
          : const StopFoodDetectionEvent());
      add(ScanningAnimationEvent(shouldAnimate: event.isCollapsed));
    }

    /*if (_previousResultForShouldDetectionRun != event.isCollapsed) {
      if (!shouldDetectionRun && !Settings.instance.getDragIntroSeen()) {
        Settings.instance.setDragIntroSeen(true);
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        add(shouldDetectionRun
            ? const StartFoodDetectionEvent()
            : const StopFoodDetectionEvent());
        add(ScanningAnimationEvent(shouldAnimate: shouldDetectionRun));
      });
      _previousResultForShouldDetectionRun = shouldDetectionRun;
    }*/
  }

  FutureOr<void> _handleScanningAnimationEvent(ScanningAnimationEvent event,
      Emitter<FoodScanState> emit) async {
    emit(ScanningAnimationState(shouldAnimate: event.shouldAnimate));
  }
}
