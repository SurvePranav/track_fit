import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:track_fit/core/domain/status.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/features/home_screen/repos/photo_repo.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepo photosRepo;
  PhotosBloc({
    required this.photosRepo,
  }) : super(const PhotosState()) {
    on<PhotosRequestedEvent>(_onPhotosRequestedEvent);
    on<PhotoAddedEvent>(_onPhotoAddedEvent);
  }

  FutureOr<void> _onPhotosRequestedEvent(
      PhotosRequestedEvent event, Emitter<PhotosState> emit) {}

  Future<void> _onPhotoAddedEvent(
      PhotoAddedEvent event, Emitter<PhotosState> emit) async {
    try {
      final path = await photosRepo.takeAndSavePhoto(
        event.source,
        event.photoType == 'front' ? 'Front Face' : 'Side Face',
      );
      if (path != null) {
        log(path);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
