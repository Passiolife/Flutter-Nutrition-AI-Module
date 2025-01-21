part of 'photo_preview_bloc.dart';

sealed class PhotoPreviewState extends Equatable {
  const PhotoPreviewState();
}

final class PhotoPreviewInitial extends PhotoPreviewState {
  @override
  List<Object> get props => [];
}

final class AnalyzeCompletedState extends PhotoPreviewState {
  const AnalyzeCompletedState({required this.timestamp});

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class NutritionFactsFoundState extends PhotoPreviewState {
  const NutritionFactsFoundState({
    required this.timestamp,
    required this.foodRecord,
    required this.imageBytes,
  });

  final int timestamp;
  final FoodRecord foodRecord;
  final Uint8List imageBytes;

  @override
  List<Object?> get props => [timestamp, foodRecord, imageBytes];
}

final class BothNotFoundState extends PhotoPreviewState {
  const BothNotFoundState({required this.timestamp});

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class NutritionFactsNotFoundState extends PhotoPreviewState {
  const NutritionFactsNotFoundState({required this.timestamp, required this.imageBytes,});

  final int timestamp;
  final Uint8List imageBytes;

  @override
  List<Object?> get props => [timestamp, imageBytes];
}

final class IngredientsNotFoundState extends PhotoPreviewState {
  const IngredientsNotFoundState({required this.timestamp});

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class FailedToAnalyzedState extends PhotoPreviewState {
  const FailedToAnalyzedState({required this.timestamp});

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}
