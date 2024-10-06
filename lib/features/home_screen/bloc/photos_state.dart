part of 'photos_bloc.dart';

class PhotosState {
  const PhotosState({
    this.photos = const [],
    this.photosState = const StatusInitial(),
  });
  final List<PhotosModel> photos;
  final Status photosState;

  PhotosState copyWith({
    List<PhotosModel>? photos,
    Status? photosState,
  }) {
    return PhotosState(
      photos: photos ?? this.photos,
      photosState: photosState ?? this.photosState,
    );
  }
}
