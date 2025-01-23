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
  // final PassioFoodItem? foodItem;
  // final DetectedCandidate? detectedCandidate;
  // final List<DetectedCandidate> alternatives;
  // final String? name;
  final String? iconId;
  final String? title;
  final String? subtitle;

  const ScanResultState({
    // this.name,
    // this.foodItem,
    // this.detectedCandidate,
    // this.alternatives = const [],
    this.iconId,
    this.title,
    this.subtitle,
  });

  @override
  List<Object?> get props => [iconId, title, subtitle];
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
class BarcodeNotRecognizedStateNew extends FoodScanState {
  const BarcodeNotRecognizedStateNew({this.barcode});
  final String? barcode;

  @override
  List<Object?> get props => [barcode];
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

class UpdatedCameraZoomStateNew extends FoodScanState {
  const UpdatedCameraZoomStateNew({
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
  });

  final double currentZoom;
  final double minZoom;
  final double maxZoom;

  @override
  List<Object?> get props => [currentZoom, minZoom, maxZoom];
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


class CameraZoomStateLoaded extends FoodScanState {
  const CameraZoomStateLoaded({required this.cameraZoomLevel});

  final PassioCameraZoomLevel cameraZoomLevel;

  @override
  List<Object?> get props => [cameraZoomLevel];
}