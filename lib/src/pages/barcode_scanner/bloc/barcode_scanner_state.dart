part of 'barcode_scanner_bloc.dart';

sealed class BarcodeScannerState extends Equatable {
  const BarcodeScannerState();
}

final class BarcodeScannerInitial extends BarcodeScannerState {
  const BarcodeScannerInitial();

  @override
  List<Object> get props => [];
}

sealed class ListenerState extends BarcodeScannerState {
  const ListenerState();
}

final class CustomFoodRecordFoundListenerState extends ListenerState {
  const CustomFoodRecordFoundListenerState({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class SystemFoodRecordFoundListenerState extends ListenerState {
  const SystemFoodRecordFoundListenerState({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class UnknownBarcodeFoundListenerState extends ListenerState {
  const UnknownBarcodeFoundListenerState({required this.barcode});

  final String barcode;

  @override
  List<Object?> get props => [barcode];
}

// final class ScanningAnimationBuilderListenerState extends ListenerState {
//   final bool shouldAnimate;
//
//   const ScanningAnimationBuilderListenerState({required this.shouldAnimate});
//
//   @override
//   List<Object?> get props => [shouldAnimate];
// }

sealed class BuilderState extends BarcodeScannerState {
  const BuilderState();
}

final class ScanningBuilderState extends BuilderState {
  const ScanningBuilderState();

  @override
  List<Object?> get props => [];
}

final class ScanningAnimationBuilderState extends BuilderState {
  const ScanningAnimationBuilderState();

  @override
  List<Object?> get props => [];
}
