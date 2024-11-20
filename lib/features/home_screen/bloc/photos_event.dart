part of 'photos_bloc.dart';

sealed class PhotosEvent {
  const PhotosEvent();
}

final class PhotosRequestedEvent extends PhotosEvent {
  const PhotosRequestedEvent({
    this.todayPhoto,
  });
  final PhotosModel? todayPhoto;
}

final class PhotoAddedEvent extends PhotosEvent {
  const PhotoAddedEvent({
    required this.source,
    required this.photoType,
  });
  final String photoType;
  final String source;
}
