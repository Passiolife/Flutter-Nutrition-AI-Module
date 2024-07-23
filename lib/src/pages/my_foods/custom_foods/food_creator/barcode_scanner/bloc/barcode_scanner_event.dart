part of 'barcode_scanner_bloc.dart';

sealed class BarcodeScannerEvent extends Equatable {
  const BarcodeScannerEvent();
}

class StopFoodDetectionEvent extends BarcodeScannerEvent {
  const StopFoodDetectionEvent();

  @override
  List<Object?> get props => [];
}

class ScanningAnimationEvent extends BarcodeScannerEvent {
  final bool shouldAnimate;

  const ScanningAnimationEvent({required this.shouldAnimate});

  @override
  List<Object?> get props => [shouldAnimate];
}

class StartScanningEvent extends BarcodeScannerEvent {
  const StartScanningEvent();

  @override
  List<Object?> get props => [];
}

class ScanningEvent extends BarcodeScannerEvent {
  const ScanningEvent();

  @override
  List<Object?> get props => [];
}

// Define an event class to trigger the start of food detection
class StartFoodDetectionEvent extends BarcodeScannerEvent {
  const StartFoodDetectionEvent();

  @override
  List<Object?> get props => [];
}

final class CustomUserFoodRecordFoundEvent extends BarcodeScannerEvent {
  const CustomUserFoodRecordFoundEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class SystemFoodRecordFoundEvent extends BarcodeScannerEvent {
  const SystemFoodRecordFoundEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class UnknownBarcodeFoundEvent extends BarcodeScannerEvent {
  const UnknownBarcodeFoundEvent({required this.barcode});

  final String barcode;

  @override
  List<Object?> get props => [barcode];
}
