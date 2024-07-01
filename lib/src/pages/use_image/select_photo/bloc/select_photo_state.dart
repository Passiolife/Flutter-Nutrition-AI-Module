part of 'select_photo_bloc.dart';

sealed class SelectPhotoState extends Equatable {
  const SelectPhotoState();
}

final class SelectPhotoInitial extends SelectPhotoState {
  const SelectPhotoInitial();

  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends SelectPhotoState {
  const ListenerState();
}

final class PhotoPickerSuccessListenerState extends ListenerState {
  const PhotoPickerSuccessListenerState({required this.images});

  final List<XFile> images;

  @override
  List<Object?> get props => [images];
}

final class PhotoPickerFailureListenerState extends ListenerState {
  const PhotoPickerFailureListenerState();

  @override
  List<Object?> get props => [];
}

final class RecognizeImageSuccessListenerState extends ListenerState {
  const RecognizeImageSuccessListenerState({required this.data});

  final List<AdvisorFoodInfoLog>? data;

  @override
  List<Object?> get props => [data];
}

final class RecognizeImageFailureListenerState extends ListenerState {
  const RecognizeImageFailureListenerState();

  @override
  List<Object?> get props => [];
}

// Food Log States
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

// Builders
sealed class BuilderState extends SelectPhotoState {
  const BuilderState();
}

final class PhotoPickerSuccessBuilderState extends BuilderState {
  const PhotoPickerSuccessBuilderState();

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
