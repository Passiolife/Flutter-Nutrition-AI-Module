part of 'nutrition_facts_bloc.dart';

sealed class NutritionFactsState extends Equatable {
  const NutritionFactsState();
}



// Builders
sealed class BuilderState extends NutritionFactsState {
  const BuilderState();
}

final class TakePhotoInitialBuilderState extends BuilderState {
  const TakePhotoInitialBuilderState();

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

final class RecognizeImageSuccessBuilderState extends BuilderState {
  const RecognizeImageSuccessBuilderState();

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
