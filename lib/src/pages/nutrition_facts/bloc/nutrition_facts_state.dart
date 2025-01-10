part of 'nutrition_facts_bloc.dart';

sealed class NutritionFactsState extends Equatable {
  const NutritionFactsState();
}

// Builders
sealed class BuilderState extends NutritionFactsState {
  const BuilderState();
}

final class InitialBuilderState extends BuilderState {
  const InitialBuilderState();

  @override
  List<Object> get props => [];
}

final class TakePhotoSuccessBuilderState extends BuilderState {
  const TakePhotoSuccessBuilderState();

  @override
  List<Object?> get props => [];
}

final class RemoveImageBuilderState extends BuilderState {
  const RemoveImageBuilderState();

  @override
  List<Object?> get props => [];
}

final class RecognizeImageLoadingBuilderState extends BuilderState {
  const RecognizeImageLoadingBuilderState();

  @override
  List<Object?> get props => [];
}

final class FoodLogLoadingBuilderState extends BuilderState {
  const FoodLogLoadingBuilderState();

  @override
  List<Object?> get props => [];
}

final class ShowIntroDialogListenerState extends BuilderState {
  const ShowIntroDialogListenerState(this.timestamp);

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class IntroDialogSeenBuilderState extends BuilderState {
  const IntroDialogSeenBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateSectionBuilderState extends BuilderState {
  const UpdateSectionBuilderState({required this.section});

  final int section;

  @override
  List<Object?> get props => [section];
}

final class PreviewBuilderState extends BuilderState {
  const PreviewBuilderState({
    required this.image,
    required this.analyzedCompleted,
  });

  final Uint8List image;
  final bool analyzedCompleted;

  @override
  List<Object?> get props => [image, analyzedCompleted];
}

final class BothNotFoundState extends BuilderState {
  const BothNotFoundState({required this.timestamp});
  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class NutritionFactsNotFoundState extends BuilderState {
  const NutritionFactsNotFoundState({required this.timestamp});
  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class IngredientsNotFoundState extends BuilderState {
  const IngredientsNotFoundState({required this.timestamp});
  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class FailedToAnalyzedState extends BuilderState {
  const FailedToAnalyzedState({required this.timestamp});
  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}
