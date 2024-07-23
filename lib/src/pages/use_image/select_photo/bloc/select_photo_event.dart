part of 'select_photo_bloc.dart';

sealed class SelectPhotoEvent extends Equatable {
  const SelectPhotoEvent();
}

final class DoPhotoPickerEvent extends SelectPhotoEvent {
  const DoPhotoPickerEvent({
    required this.returnResult,
    required this.maxLimit,
    this.from,
  });

  final String? from;
  final bool returnResult;
  final int maxLimit;

  @override
  List<Object?> get props => [from, returnResult, maxLimit];
}

final class DoRecognizeImageEvent extends SelectPhotoEvent {
  const DoRecognizeImageEvent({required this.images});

  final List<XFile> images;

  @override
  List<Object?> get props => [images];
}

final class UpdateSelectionEvent extends SelectPhotoEvent {
  final List<AdvisorFoodInfoLog>? data;
  final int index;

  const UpdateSelectionEvent({required this.data, required this.index});

  @override
  List<Object?> get props => [data, index];
}

final class ClearSelectionEvent extends SelectPhotoEvent {
  final List<AdvisorFoodInfoLog>? data;

  const ClearSelectionEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

final class DoFoodLogEvent extends SelectPhotoEvent {
  final List<AdvisorFoodInfoLog>? data;

  const DoFoodLogEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
