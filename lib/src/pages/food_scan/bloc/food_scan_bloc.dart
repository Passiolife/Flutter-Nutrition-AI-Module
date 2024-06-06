import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<ScanningEvent>(_handleScanningEvent);
    on<ScanningAnimationEvent>(_handleScanningAnimationEvent);
    on<StartScanningEvent>(_handleStartScanningEvent);
    on<StartFoodDetectionEvent>(_handleStartFoodDetectionEvent);
    on<StopFoodDetectionEvent>(_handleStopFoodDetectionEvent);
    on<DetectedEvent>(_handleDetectedEvent);

    // Scan dialog event
    on<ScanResultDragEvent>(_handleScanResultDragEvent);
    on<BarcodeNotRecognizedEvent>(_handleBarcodeNotRecognizedEvent);
    on<PackagedFoodNotRecognizedEvent>(_handlePackagedFoodNotRecognizedEvent);

    // Do log event
    on<DoConversionEvent>(_handleDoConversionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
    on<AddedToDiaryVisibilityEvent>(_handleAddedToDiaryVisibilityEvent);

    // Barcode Not Recognized Events
    on<ScanNutritionFactsEvent>(_handleScanNutritionFactsEvent);
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
  }

  FutureOr<void> _handleStartFoodDetectionEvent(
      StartFoodDetectionEvent event, Emitter<FoodScanState> emit) async {
    const detectionConfig = FoodDetectionConfiguration(
      detectVisual: true,
      detectBarcodes: true,
      detectPackagedFood: true,
    );
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  FutureOr<void> _handleStopFoodDetectionEvent(
      StopFoodDetectionEvent event, Emitter<FoodScanState> emit) async {
    NutritionAI.instance.stopFoodDetection();
  }

  FutureOr<void> _handleDetectedEvent(
      DetectedEvent event, Emitter<FoodScanState> emit) async {
    var barcodeCandidates = event.barcodeCandidates;
    var packagedFoodCandidates = event.packagedFoodCandidates;
    var detectedCandidates = event.detectedCandidates;

    PassioFoodItem? foodItem;
    if ((barcodeCandidates?.isEmpty ?? false) &&
        (packagedFoodCandidates?.isEmpty ?? false) &&
        (detectedCandidates?.isEmpty ?? false)) {
      emit(const ScanLoadingState());
    } else {
      DetectedCandidate? detectedCandidate;
      List<DetectedCandidate> alternatives = [];

      if (barcodeCandidates?.firstOrNull != null) {
        foodItem = await NutritionAI.instance
            .fetchFoodItemForProductCode(barcodeCandidates!.first.value);
        if (foodItem == null) {
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

  FutureOr<void> _handleBarcodeNotRecognizedEvent(
      BarcodeNotRecognizedEvent event, Emitter<FoodScanState> emit) async {
    if (event.shouldVisible) {
      add(const StopFoodDetectionEvent());
    } else {
      add(const StartScanningEvent());
    }
    emit(BarcodeNotRecognizedState(shouldVisible: event.shouldVisible));
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

  FutureOr<void> _handleScanningEvent(
      ScanningEvent event, Emitter<FoodScanState> emit) {
    emit(const ScanningState());
  }

  Future<FutureOr<void>> _handleDoConversionEvent(
      DoConversionEvent event, Emitter<FoodScanState> emit) async {
    if (event.detectedCandidate != null) {}
  }
}
