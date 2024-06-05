part of 'food_scan_bloc.dart';

abstract class FoodScanEvent extends Equatable {
  const FoodScanEvent();
}

// Define an event class to trigger the display of the intro screen
class IntroScreenEvent extends FoodScanEvent {
  // Indicates whether it should be visible or not
  final bool? shouldVisible;

  const IntroScreenEvent({this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

// Define an event class to trigger the intro screen has been completed.
class IntroScreenCompleteEvent extends FoodScanEvent {
  const IntroScreenCompleteEvent();

  @override
  List<Object?> get props => [];
}

class ScanningEvent extends FoodScanEvent {
  const ScanningEvent();

  @override
  List<Object?> get props => [];
}

class ScanningAnimationEvent extends FoodScanEvent {
  final bool shouldAnimate;

  const ScanningAnimationEvent({required this.shouldAnimate});

  @override
  List<Object?> get props => [shouldAnimate];
}

class StartScanningEvent extends FoodScanEvent {
  const StartScanningEvent();

  @override
  List<Object?> get props => [];
}

// Define an event class to trigger the start of food detection
class StartFoodDetectionEvent extends FoodScanEvent {
  const StartFoodDetectionEvent();

  @override
  List<Object?> get props => [];
}

class StopFoodDetectionEvent extends FoodScanEvent {
  const StopFoodDetectionEvent();

  @override
  List<Object?> get props => [];
}

class DetectedEvent extends FoodScanEvent {
  final List<BarcodeCandidate>? barcodeCandidates;
  final List<DetectedCandidate>? detectedCandidates;
  final List<PackagedFoodCandidate>? packagedFoodCandidates;

  const DetectedEvent({
    required this.detectedCandidates,
    this.barcodeCandidates,
    this.packagedFoodCandidates,
  });

  @override
  List<Object?> get props => [
        detectedCandidates,
        packagedFoodCandidates,
        barcodeCandidates,
      ];
}

class ScanResultDragEvent extends FoodScanEvent {
  final bool isCollapsed;

  const ScanResultDragEvent({required this.isCollapsed});

  @override
  List<Object?> get props => [isCollapsed];
}

class BarcodeNotRecognizedEvent extends FoodScanEvent {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const BarcodeNotRecognizedEvent({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class PackagedFoodNotRecognizedEvent extends FoodScanEvent {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const PackagedFoodNotRecognizedEvent({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class DoFoodLogEvent extends FoodScanEvent {
  const DoFoodLogEvent(
      {required this.dateTime, this.foodItem, this.detectedCandidate});

  final DateTime dateTime;
  final PassioFoodItem? foodItem;
  final DetectedCandidate? detectedCandidate;

  @override
  List<Object?> get props => [dateTime, foodItem, detectedCandidate];
}

class ScanNutritionFactsEvent extends FoodScanEvent {
  const ScanNutritionFactsEvent();

  @override
  List<Object?> get props => [];
}

class AddedToDiaryVisibilityEvent extends FoodScanEvent {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const AddedToDiaryVisibilityEvent(this.shouldVisible);

  @override
  List<Object?> get props => [shouldVisible];
}

class DoConversionEvent extends FoodScanEvent {
  // Indicates whether it should be visible or not
  final DetectedCandidate? detectedCandidate;

  const DoConversionEvent({this.detectedCandidate});

  @override
  List<Object?> get props => [detectedCandidate];
}
