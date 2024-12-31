import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/extension/passio_nutrition_facts_extension.dart';
import '../../../common/models/settings/settings.dart';

part 'food_scan_event.dart';
part 'food_scan_state.dart';

class FoodScanBloc extends Bloc<FoodScanEvent, FoodScanState>
    implements FoodRecognitionListener, NutritionFactsRecognitionListener {
  /// [_connector] is use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  bool? _previousResultForDrag;

  int? _currentMode;

  PassioNutritionFacts? _nutritionFacts;

  // Camera Zoom Members
  double _currentZoom = 1;
  double _minZoom = 1;
  double _maxZoom = 1;

  @override
  void onNutritionFactsRecognized(
      PassioNutritionFacts? nutritionFacts, String? text) {
    // Adding a VisualDetectedEvent to the bloc
    add(NutritionFactsDetectedEvent(nutritionFacts: nutritionFacts));
  }

  @override
  void recognitionResults(
      FoodCandidates? foodCandidates, PlatformImage? image) {
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

  FoodScanBloc() : super(const FoodScanInitial()) {
    // Intro Dialog events
    on<IntroScreenEvent>(_handleIntroScreenEvent);
    on<IntroScreenCompleteEvent>(_handleIntroScreenCompleteEvent);

    // Scanning Events
    on<DoModeChangeEvent>(_handleDoModeChangeEvent);
    on<ScanningEvent>(_handleScanningEvent);
    on<ScanningAnimationEvent>(_handleScanningAnimationEvent);
    on<StartScanningEvent>(_handleStartScanningEvent);
    on<StartFoodDetectionEvent>(_handleStartFoodDetectionEvent);
    on<StopFoodDetectionEvent>(_handleStopFoodDetectionEvent);
    on<DetectedEvent>(_handleDetectedEvent);

    // Camera Zoom Events
    on<GetCameraZoomLevelEvent>(_handleGetCameraZoomLevelEvent);
    on<DoUpdateCameraZoomLevelEvent>(_handleDoUpdateCameraZoomLevelEvent);

    // Scan dialog event
    on<ScanResultDragEvent>(_handleScanResultDragEvent);
    on<BarcodeNotRecognizedEvent>(_handleBarcodeNotRecognizedEvent);
    on<BarcodeNotRecognizedEventNew>(_handleBarcodeNotRecognizedEventNew);
    on<PackagedFoodNotRecognizedEvent>(_handlePackagedFoodNotRecognizedEvent);

    // Do log event
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
    on<AddedToDiaryVisibilityEvent>(_handleAddedToDiaryVisibilityEvent);

    // Barcode Not Recognized Events
    on<ScanNutritionFactsEvent>(_handleScanNutritionFactsEvent);

    // Nutrition Facts Events
    on<NutritionFactsDetectedEvent>(_handleNutritionFactsDetectedEvent);
    on<DoNextNutritionFactsEvent>(_handleDoNextNutritionFactsEvent);
    on<ClearNutritionFactsEvent>(_handleClearNutritionFactsEvent);
  }

  FutureOr<void> _handleIntroScreenEvent(
      IntroScreenEvent event, Emitter<FoodScanState> emit) async {
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
    emit(IntroScreenVisibilityState(shouldVisible: shouldVisible));
  }

  FutureOr<void> _handleIntroScreenCompleteEvent(
      IntroScreenCompleteEvent event, Emitter<FoodScanState> emit) {
    // Mark the intro screen as seen
    Settings.instance.setScanIntroSeen(true);
  }

  FutureOr<void> _handleStartScanningEvent(
      StartScanningEvent event, Emitter<FoodScanState> emit) async {
    add(const ScanningEvent());
    add(const StartFoodDetectionEvent());
    add(const GetCameraZoomLevelEvent());
  }

  FutureOr<void> _handleStartFoodDetectionEvent(
      StartFoodDetectionEvent event, Emitter<FoodScanState> emit) async {
    // if (_currentMode == 2) {
    //   NutritionAI.instance.startNutritionFactsDetection(this);
    //   return;
    // }
    final detectionConfig = FoodDetectionConfiguration(
      detectVisual: false,
      detectBarcodes: true,
      detectPackagedFood: false,
    );
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  FutureOr<void> _handleStopFoodDetectionEvent(
      StopFoodDetectionEvent event, Emitter<FoodScanState> emit) async {
    NutritionAI.instance.stopFoodDetection();
    NutritionAI.instance.stopNutritionFactsDetection();
  }

  FutureOr<void> _handleDetectedEvent(
      DetectedEvent event, Emitter<FoodScanState> emit) async {
    var barcodeCandidates = event.barcodeCandidates;
    var packagedFoodCandidates = event.packagedFoodCandidates;
    var detectedCandidates = event.detectedCandidates;

    PassioFoodItem? foodItem;
    if ((barcodeCandidates?.isEmpty ?? true) &&
        (packagedFoodCandidates?.isEmpty ?? true) &&
        (detectedCandidates?.isEmpty ?? true)) {
      emit(const ScanLoadingState());
    } else {
      DetectedCandidate? detectedCandidate;
      List<DetectedCandidate> alternatives = [];

      if (barcodeCandidates?.firstOrNull != null) {
        foodItem = await NutritionAI.instance
            .fetchFoodItemForProductCode(barcodeCandidates!.first.value);
        if (foodItem == null) {
          add(StopFoodDetectionEvent());
          add(const BarcodeNotRecognizedEvent(shouldVisible: true));
          return;
        }
      } else if (packagedFoodCandidates?.firstOrNull != null) {
        foodItem = await NutritionAI.instance.fetchFoodItemForProductCode(
            packagedFoodCandidates!.first.packagedFoodCode);
        if (foodItem == null) {
          add(const PackagedFoodNotRecognizedEvent(shouldVisible: true));
          return;
        }
      } else if (detectedCandidates?.isNotEmpty ?? false) {
        detectedCandidate = event.detectedCandidates?.firstOrNull;
        if (detectedCandidate == null) return;
        alternatives.addAll(detectedCandidate.alternatives);
        alternatives.addAll(event.detectedCandidates?.skip(1) ?? []);
      }
      emit(ScanResultState(
        foodItem: foodItem,
        detectedCandidate: detectedCandidate,
        alternatives: alternatives,
      ));
    }
  }

  Future<void> _handleNutritionFactsDetectedEvent(
      NutritionFactsDetectedEvent event, Emitter<FoodScanState> emit) async {
    if (event.nutritionFacts == null) {
      if (_nutritionFacts == null) {
        emit(const ScanLoadingState());
        return;
      }
    } else {
      _nutritionFacts = event.nutritionFacts;
    }
    emit(NutritionFactsResultState(nutritionFacts: _nutritionFacts));
  }

  FutureOr<void> _handleBarcodeNotRecognizedEvent(
      BarcodeNotRecognizedEvent event, Emitter<FoodScanState> emit) async {
    if (event.shouldVisible) {
      add(const StopFoodDetectionEvent());
    } else {
      add(const StartScanningEvent());
    }
    emit(const BarcodeNotRecognizedStateNew());
  }

  FutureOr<void> _handleBarcodeNotRecognizedEventNew(
      BarcodeNotRecognizedEventNew event, Emitter<FoodScanState> emit) async {
    emit(const BarcodeNotRecognizedStateNew());
  }

  FutureOr<void> _handlePackagedFoodNotRecognizedEvent(
      PackagedFoodNotRecognizedEvent event, Emitter<FoodScanState> emit) async {
    if (event.shouldVisible) {
      add(const StopFoodDetectionEvent());
    } else {
      add(const StartScanningEvent());
    }
    emit(PackagedFoodNotRecognizedState(shouldVisible: event.shouldVisible));
  }

  FutureOr<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<FoodScanState> emit) async {
    add(const StopFoodDetectionEvent());
    add(const ScanningAnimationEvent(shouldAnimate: false));
    FoodRecord? foodRecord;
    if (event.foodItem != null) {
      foodRecord = FoodRecord.fromPassioFoodItem(event.foodItem!);
    } else if (event.detectedCandidate != null) {
      final foodItem = await NutritionAI.instance
          .fetchFoodItemForPassioID(event.detectedCandidate!.passioID);
      if (foodItem != null) {
        foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      }
    }
    if (foodRecord != null) {
      _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      add(const AddedToDiaryVisibilityEvent(true));
    }
  }

  FutureOr<void> _handleAddedToDiaryVisibilityEvent(
      AddedToDiaryVisibilityEvent event, Emitter<FoodScanState> emit) {
    emit(const AddedToDiaryVisibilityState());
  }

  FutureOr<void> _handleScanNutritionFactsEvent(
      ScanNutritionFactsEvent event, Emitter<FoodScanState> emit) async {
    emit(const ShowNutritionFactsDialogState());
  }

  FutureOr<void> _handleScanResultDragEvent(
      ScanResultDragEvent event, Emitter<FoodScanState> emit) async {
    if (_previousResultForDrag != event.isCollapsed) {
      if (!event.isCollapsed && !Settings.instance.getDragIntroSeen()) {
        Settings.instance.setDragIntroSeen(true);
      }
      _previousResultForDrag = event.isCollapsed;
      add(event.isCollapsed
          ? const StartFoodDetectionEvent()
          : const StopFoodDetectionEvent());
      if (event.isCollapsed) {
        add(const ScanningAnimationEvent(shouldAnimate: true));
      }
    }
  }

  FutureOr<void> _handleScanningAnimationEvent(
      ScanningAnimationEvent event, Emitter<FoodScanState> emit) async {
    emit(ScanningAnimationState(shouldAnimate: event.shouldAnimate));
  }

  Future<void> _handleDoModeChangeEvent(
      DoModeChangeEvent event, Emitter<FoodScanState> emit) async {
    _currentMode = event.mode;
    if (_currentMode == 1) {
      add(const DoUpdateCameraZoomLevelEvent(zoomLevel: 1.5));
    } else {
      add(const DoUpdateCameraZoomLevelEvent(zoomLevel: 1));
    }
    add(const StopFoodDetectionEvent());
    add(const StartFoodDetectionEvent());
  }

  FutureOr<void> _handleScanningEvent(
      ScanningEvent event, Emitter<FoodScanState> emit) {
    emit(const ScanningState());
  }

  FutureOr<void> _handleDoUpdateCameraZoomLevelEvent(
      DoUpdateCameraZoomLevelEvent event, Emitter<FoodScanState> emit) {
    _currentZoom = event.zoomLevel;
    NutritionAI.instance.setCameraZoomLevel(zoomLevel: _currentZoom);
    emit(UpdatedCameraZoomStateNew(currentZoom: _currentZoom, minZoom: _minZoom, maxZoom: _maxZoom));
  }

  Future<void> _handleGetCameraZoomLevelEvent(
      GetCameraZoomLevelEvent event, Emitter<FoodScanState> emit) async {
    final cameraZoomLevel =
        await NutritionAI.instance.getMinMaxCameraZoomLevel();
    _minZoom = cameraZoomLevel.minZoomLevel ?? 1;
    _maxZoom = cameraZoomLevel.maxZoomLevel ?? 1;
    emit(UpdatedCameraZoomStateNew(currentZoom: _currentZoom, minZoom: _minZoom, maxZoom: _maxZoom));
  }

  FutureOr<void> _handleDoNextNutritionFactsEvent(
      DoNextNutritionFactsEvent event, Emitter<FoodScanState> emit) async {

    final nutritionFacts = event.nutritionFacts;
    if (nutritionFacts == null) {
      return;
    }

    emit(const NutritionFactsLoadingNextState());

    PassioFoodItem foodItem = nutritionFacts.toPassioFoodItem();

    final foodRecord =
        FoodRecord.fromPassioFoodItem(foodItem);

    emit(NutritionFactsSuccessState(foodRecord: foodRecord));
  }

  FutureOr<void> _handleClearNutritionFactsEvent(ClearNutritionFactsEvent event, Emitter<FoodScanState> emit) {
    _nutritionFacts = null;
    emit(ScanLoadingState());
  }
}
