import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../nutrition_ai_module.dart';

part 'barcode_scanner_event.dart';
part 'barcode_scanner_state.dart';

class BarcodeScannerBloc extends Bloc<BarcodeScannerEvent, BarcodeScannerState>
    implements FoodRecognitionListener {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  BarcodeScannerBloc() : super(const BarcodeScannerInitial()) {
    on<StartScanningEvent>(_handleStartScanningEvent);
    on<ScanningEvent>(_handleScanningEvent);
    on<StartFoodDetectionEvent>(_handleStartFoodDetectionEvent);
    on<StopFoodDetectionEvent>(_handleStopFoodDetectionEvent);
    on<ScanningAnimationEvent>(_handleScanningAnimationEvent);
    on<CustomUserFoodRecordFoundEvent>(_handleCustomFoodRecordFoundState);
    on<SystemFoodRecordFoundEvent>(_handleSystemFoodRecordFoundEvent);
    on<UnknownBarcodeFoundEvent>(_handleUnknownBarcodeFoundEvent);
  }

  FutureOr<void> _handleStartScanningEvent(
      StartScanningEvent event, Emitter<BarcodeScannerState> emit) async {
    add(const ScanningEvent());
    add(const StartFoodDetectionEvent());
  }

  FutureOr<void> _handleScanningEvent(
      ScanningEvent event, Emitter<BarcodeScannerState> emit) {
    emit(const ScanningListenerState());
    emit(const ScanningBuilderState());
  }

  FutureOr<void> _handleStartFoodDetectionEvent(
      StartFoodDetectionEvent event, Emitter<BarcodeScannerState> emit) async {
    const detectionConfig = FoodDetectionConfiguration(
      detectVisual: false,
      detectBarcodes: true,
      detectPackagedFood: false,
    );
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  FutureOr<void> _handleStopFoodDetectionEvent(
      StopFoodDetectionEvent event, Emitter<BarcodeScannerState> emit) async {
    NutritionAI.instance.stopFoodDetection();
  }

  FutureOr<void> _handleScanningAnimationEvent(
      ScanningAnimationEvent event, Emitter<BarcodeScannerState> emit) async {
    emit(ScanningAnimationBuilderListenerState(
        shouldAnimate: event.shouldAnimate));
    emit(const ScanningAnimationBuilderState());
  }

  @override
  Future<void> recognitionResults(
      FoodCandidates? foodCandidates, PlatformImage? image) async {
    final barcode = foodCandidates?.barcodeCandidates?.firstOrNull?.value;
    if (barcode == null) {
      return;
    }
    add(const StopFoodDetectionEvent());
    final customFoodRecord =
        await _connector.fetchUserFoodByBarcode(barcode: barcode);
    if (customFoodRecord != null) {
      add(CustomUserFoodRecordFoundEvent(foodRecord: customFoodRecord));
    } else {
      final foodItem =
          await NutritionAI.instance.fetchFoodItemForProductCode(barcode);
      if (foodItem != null) {
        final systemFoodRecord = FoodRecord.fromPassioFoodItem(foodItem);
        add(SystemFoodRecordFoundEvent(foodRecord: systemFoodRecord));
      } else {
        add(const StartFoodDetectionEvent());
        add(UnknownBarcodeFoundEvent(barcode: barcode));
      }
    }
  }

  FutureOr<void> _handleCustomFoodRecordFoundState(
      CustomUserFoodRecordFoundEvent event, Emitter<BarcodeScannerState> emit) {
    emit(CustomFoodRecordFoundListenerState(foodRecord: event.foodRecord));
  }

  FutureOr<void> _handleSystemFoodRecordFoundEvent(
      SystemFoodRecordFoundEvent event, Emitter<BarcodeScannerState> emit) {
    emit(SystemFoodRecordFoundListenerState(foodRecord: event.foodRecord));
  }

  FutureOr<void> _handleUnknownBarcodeFoundEvent(
      UnknownBarcodeFoundEvent event, Emitter<BarcodeScannerState> emit) {
    emit(UnknownBarcodeFoundListenerState(barcode: event.barcode));
  }
}
