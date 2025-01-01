part of 'take_photo_bloc.dart';

sealed class TakePhotoState extends Equatable {
  const TakePhotoState();
}

// Listeners
sealed class ListenerState extends TakePhotoState {
  const ListenerState();
}

final class TakePhotoInitialListenerState extends ListenerState {
  const TakePhotoInitialListenerState();

  @override
  List<Object> get props => [];
}

final class TakePhotoSuccessListenerState extends ListenerState {
  const TakePhotoSuccessListenerState({
    required this.images,
    required this.resizedImages,
  });

  final List<Uint8List> images;
  final List<Uint8List> resizedImages;

  @override
  List<Object?> get props => [images, resizedImages];
}

final class RemovePhotoListenerState extends ListenerState {
  const RemovePhotoListenerState({
    required this.images,
    required this.resizedImages,
  });

  final List<Uint8List> images;
  final List<Uint8List> resizedImages;

  @override
  List<Object?> get props => [images, resizedImages];
}

final class RecognizeImageLoadingListenerState extends ListenerState {
  const RecognizeImageLoadingListenerState();

  @override
  List<Object?> get props => [];
}

final class RecognizeImageSuccessListenerState extends ListenerState {
  const RecognizeImageSuccessListenerState({required this.data});

  final List<AdvisorFoodInfoLog>? data;

  @override
  List<Object?> get props => [data];
}

final class FoodLogLoadingListenerState extends ListenerState {
  const FoodLogLoadingListenerState();

  @override
  List<Object?> get props => [];
}

final class FoodLogSuccessListenerState extends ListenerState {
  const FoodLogSuccessListenerState();

  @override
  List<Object?> get props => [];
}

final class FoodLogFailureListenerState extends ListenerState {
  const FoodLogFailureListenerState();

  @override
  List<Object?> get props => [];
}

final class ShowIntroDialogListenerState extends ListenerState {
  const ShowIntroDialogListenerState();

  @override
  List<Object?> get props => [];
}


// Builders
sealed class BuilderState extends TakePhotoState {
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

final class IntroDialogSeenBuilderState extends BuilderState {
  const IntroDialogSeenBuilderState();

  @override
  List<Object?> get props => [];
}
