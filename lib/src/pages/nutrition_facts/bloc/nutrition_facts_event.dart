part of 'nutrition_facts_bloc.dart';

sealed class TakePhotoEvent extends Equatable {
  const TakePhotoEvent();
}

final class InitialEvent extends TakePhotoEvent {
  const InitialEvent();

  @override
  List<Object?> get props => [];
}

final class DoTakeImageEvent extends TakePhotoEvent {
  const DoTakeImageEvent({this.file});

  final XFile? file;

  @override
  List<Object?> get props => [file];
}

final class DoRecognizeImageEvent extends TakePhotoEvent {
  const DoRecognizeImageEvent({required this.image});

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}

final class UpdateSectionEvent extends TakePhotoEvent {
  const UpdateSectionEvent({required this.section});
  final int section;

  @override
  List<Object?> get props => [section];
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
