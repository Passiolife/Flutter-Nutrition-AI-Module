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