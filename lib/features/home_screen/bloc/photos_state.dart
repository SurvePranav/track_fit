part of 'photos_bloc.dart';

class PhotosState {
  const PhotosState({
    this.photos = const [],
    this.photosState = const StatusInitial(),
    this.todayPhoto = PhotosModel.empty,
  });
  final List<PhotosModel> photos;
  final Status photosState;
  final PhotosModel todayPhoto;

  PhotosState copyWith({
    List<PhotosModel>? photos,
    Status? photosState,
    PhotosModel? todayPhoto,
  }) {
    return PhotosState(
      photos: photos ?? this.photos,
      photosState: photosState ?? this.photosState,
      todayPhoto: todayPhoto ?? this.todayPhoto,
    );
  }
}
