part of 'take_photo_bloc.dart';

sealed class TakePhotoEvent extends Equatable {
  const TakePhotoEvent();
}

final class InitialEvent extends TakePhotoEvent {
  const InitialEvent();

  @override
  List<Object?> get props => [];
}

final class DoNextEvent extends TakePhotoEvent {
  const DoNextEvent({required this.images});

  final List<Uint8List> images;

  @override
  List<Object?> get props => [images];
}

final class DoTakeImageEvent extends TakePhotoEvent {
  const DoTakeImageEvent({this.file});

  final XFile? file;

  @override
  List<Object?> get props => [file];
}

final class DoRemoveImageEvent extends TakePhotoEvent {
  const DoRemoveImageEvent({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class DoRecognizeImageEvent extends TakePhotoEvent {
  const DoRecognizeImageEvent({required this.images});

  final List<Uint8List> images;

  @override
  List<Object?> get props => [images];
}

final class UpdateSelectionEvent extends TakePhotoEvent {
  final List<AdvisorFoodInfoLog>? data;
  final int index;

  const UpdateSelectionEvent({required this.data, required this.index});

  @override
  List<Object?> get props => [data, index];
}

final class ClearSelectionEvent extends TakePhotoEvent {
  final List<AdvisorFoodInfoLog>? data;

  const ClearSelectionEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

final class DoFoodLogEvent extends TakePhotoEvent {
  final List<AdvisorFoodInfoLog>? data;

  const DoFoodLogEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

final class ShowIntroScreenEvent extends TakePhotoEvent {
  const ShowIntroScreenEvent();

  @override
  List<Object?> get props => [];
}

final class DoCheckIntroScreenEvent extends TakePhotoEvent {
  const DoCheckIntroScreenEvent();

  @override
  List<Object?> get props => [];
}

final class DoIntroScreenCompletedEvent extends TakePhotoEvent {
  const DoIntroScreenCompletedEvent({this.fromDialog = false});
  final bool fromDialog;

  @override
  List<Object?> get props => [fromDialog];
}
