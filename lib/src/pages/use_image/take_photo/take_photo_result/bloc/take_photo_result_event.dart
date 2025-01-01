part of 'take_photo_result_bloc.dart';

sealed class TakePhotoResultEvent extends Equatable {
  const TakePhotoResultEvent();
}

final class InitializeEvent extends TakePhotoResultEvent {
  const InitializeEvent();

  @override
  List<Object?> get props => [];
}

final class SetDefaultHeaderEvent extends TakePhotoResultEvent {
  const SetDefaultHeaderEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateMealLabelEvent extends TakePhotoResultEvent {
  const UpdateMealLabelEvent({required this.mealLabel});

  final MealLabel mealLabel;

  @override
  List<Object?> get props => [mealLabel];
}

final class UpdateTimeStampEvent extends TakePhotoResultEvent {
  const UpdateTimeStampEvent({required this.timeStamp});

  final DateTime? timeStamp;

  @override
  List<Object?> get props => [timeStamp];
}

final class DoProcessEvent extends TakePhotoResultEvent {
  const DoProcessEvent({required this.images});

  final List<Uint8List>? images;

  @override
  List<Object?> get props => [images];
}
