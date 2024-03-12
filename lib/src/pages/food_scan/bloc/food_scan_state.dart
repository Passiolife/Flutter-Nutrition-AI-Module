part of 'food_scan_bloc.dart';

abstract class FoodScanState extends Equatable {
  const FoodScanState();
}

class FoodScanInitial extends FoodScanState {
  @override
  List<Object> get props => [];
}

// Define a state class to manage the visibility of the intro screen
class IntroVisibilityState extends FoodScanState {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const IntroVisibilityState({required this.shouldVisible});

  @override
  List<Object?> get props => [shouldVisible];
}

class ScanningState extends FoodScanState {
  @override
  List<Object?> get props => [];
}

class ScanResultVisibilityState extends FoodScanState {
  final PassioID passioID;
  final String foodName;
  final String iconId;
  final List<DetectedCandidate> alternatives;

  const ScanResultVisibilityState({
    required this.passioID,
    required this.foodName,
    required this.iconId,
    required this.alternatives,
  });

  @override
  List<Object?> get props => [passioID, foodName, iconId, alternatives];
}

class AddedToDiaryVisibilityState extends FoodScanState {
  const AddedToDiaryVisibilityState({required this.shouldVisible});

  // Indicates whether it should be visible or not
  final bool shouldVisible;

  @override
  List<Object?> get props => [shouldVisible];
}

// State representing the visibility of the barcode not recognized UI
class BarcodeNotRecognizedState extends FoodScanState {
  // Indicates whether it should be visible or not
  final bool shouldVisible;

  const BarcodeNotRecognizedState({required this.shouldVisible});

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
