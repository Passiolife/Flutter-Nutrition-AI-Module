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
  final PassioNutritionFacts? nutritionFacts;

  const DetectedEvent({
    this.detectedCandidates,
    this.barcodeCandidates,
    this.packagedFoodCandidates,
    this.nutritionFacts,
  });

  @override
  List<Object?> get props => [
        detectedCandidates,
        packagedFoodCandidates,
        barcodeCandidates,
      ];
}

class NutritionFactsDetectedEvent extends FoodScanEvent {
  final PassioNutritionFacts? nutritionFacts;

  const NutritionFactsDetectedEvent({this.nutritionFacts});

  @override
  List<Object?> get props => [nutritionFacts];
}

final class ClearNutritionFactsEvent extends FoodScanEvent {
  const ClearNutritionFactsEvent();

  @override
  List<Object?> get props => [];

}

class ScanResultDragEvent extends FoodScanEvent {
  final bool isCollapsed;

  const ScanResultDragEvent({required this.isCollapsed});

  @override
  List<Object?> get props => [isCollapsed];
}

class BarcodeNotRecognizedEvent extends FoodScanEvent {
  const BarcodeNotRecognizedEvent();

  @override
  List<Object?> get props => [];
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

class DoModeChangeEvent extends FoodScanEvent {
  const DoModeChangeEvent({required this.mode});

  final int mode;

  @override
  List<Object?> get props => [mode];
}

class GetCameraZoomLevelEvent extends FoodScanEvent {
  const GetCameraZoomLevelEvent();

  @override
  List<Object?> get props => [];
}

class DoUpdateCameraZoomLevelEvent extends FoodScanEvent {
  const DoUpdateCameraZoomLevelEvent({required this.zoomLevel});

  final double zoomLevel;

  @override
  List<Object?> get props => [zoomLevel];
}

final class DoNextNutritionFactsEvent extends FoodScanEvent {
  const DoNextNutritionFactsEvent({this.nutritionFacts});

  final PassioNutritionFacts? nutritionFacts;

  @override
  List<Object?> get props => [nutritionFacts];
}