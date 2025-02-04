part of 'photo_preview_bloc.dart';

sealed class PhotoPreviewEvent extends Equatable {
  const PhotoPreviewEvent();
}

final class DoProcessEvent extends PhotoPreviewEvent {
  const DoProcessEvent({required this.file});
  final File file;

  @override
  List<Object?> get props => [file];
}

final class SaveEvent extends PhotoPreviewEvent {
  const SaveEvent({required this.foodRecord, this.imageBytes});
  final FoodRecord foodRecord;
  final Uint8List? imageBytes;

  @override
  List<Object?> get props => [foodRecord, imageBytes];
}