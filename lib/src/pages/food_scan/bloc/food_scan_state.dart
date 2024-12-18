part of 'food_scan_bloc.dart';

abstract class FoodScanState extends Equatable {
  const FoodScanState();
}

class FoodScanInitial extends FoodScanState {
  const FoodScanInitial();

  @override
  List<Object> get props => [];
}

// Define a state class to manage the visibility of the intro screen
class IntroScreenVisibilityState extends FoodScanState {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const IntroScreenVisibilityState({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class ScanningState extends FoodScanState {
  const ScanningState();

  @override
  List<Object?> get props => [];
}

class ScanLoadingState extends FoodScanState {
  const ScanLoadingState();

  @override
  List<Object?> get props => [];
}

class ScanResultState extends FoodScanState {
  final PassioFoodItem? foodItem;
  final DetectedCandidate? detectedCandidate;
  final List<DetectedCandidate> alternatives;

  const ScanResultState({
    this.foodItem,
    this.detectedCandidate,
    this.alternatives = const [],
  });

  @override
  List<Object?> get props => [foodItem, detectedCandidate, alternatives];
}

class NutritionFactsResultState extends FoodScanState {
  final PassioNutritionFacts? nutritionFacts;

  const NutritionFactsResultState({this.nutritionFacts});

  @override
  List<Object?> get props => [nutritionFacts];

}

class AddedToDiaryVisibilityState extends FoodScanState {
  const AddedToDiaryVisibilityState();

  @override
  List<Object?> get props => [];
}

// State representing the visibility of the barcode not recognized UI
class BarcodeNotRecognizedState extends FoodScanState {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const BarcodeNotRecognizedState({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class PackagedFoodNotRecognizedState extends FoodScanState {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const PackagedFoodNotRecognizedState({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class ShowNutritionFactsDialogState extends FoodScanState {
  const ShowNutritionFactsDialogState();

  @override
  List<Object?> get props => [];
}

class ScanningAnimationState extends FoodScanState {
  final bool shouldAnimate;

  const ScanningAnimationState({required this.shouldAnimate});

  @override
  List<Object?> get props => [shouldAnimate];
}

class ConversionSuccessState extends FoodScanState {
  final PassioFoodItem? foodItem;

  const ConversionSuccessState({required this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class ConversionFailureState extends FoodScanState {
  const ConversionFailureState();

  @override
  List<Object?> get props => [];
}

class UpdatedCameraZoomState extends FoodScanState {
  const UpdatedCameraZoomState({required this.zoomLevel});

  final double zoomLevel;

  @override
  List<Object?> get props => [zoomLevel];
}

class CameraZoomStateLoaded extends FoodScanState {
  const CameraZoomStateLoaded({required this.cameraZoomLevel});

  final PassioCameraZoomLevel cameraZoomLevel;

  @override
  List<Object?> get props => [cameraZoomLevel];
}

final class NutritionFactsLoadingNextState extends FoodScanState {
  const NutritionFactsLoadingNextState();

  @override
  List<Object?> get props => [];
}

final class NutritionFactsSuccessState extends FoodScanState {
  const NutritionFactsSuccessState({this.foodRecord});
  final FoodRecord? foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}