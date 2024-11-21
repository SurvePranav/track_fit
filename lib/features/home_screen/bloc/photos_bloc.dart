import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:track_fit/core/domain/status.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/core/hive/boxes.dart';
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
      PhotosRequestedEvent event, Emitter<PhotosState> emit) {
    final photos = List.generate(
        photosModelBox.length, (index) => photosModelBox.getAt(index)!);

    // sorting photos according to date
    photos.sort((a, b) {
      DateTime dateA = DateTime.parse(a.date);
      DateTime dateB = DateTime.parse(b.date);
      // Sort in descending order (latest date first)
      return dateB.compareTo(dateA);
    });

    emit(
      state.copyWith(
        photos: photos,
        photosState: Status.success(),
        todayPhoto: event.todayPhoto ??
            photos.firstWhere(
              (e) =>
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(e.date)) ==
                  DateFormat('yyyy-MM-dd').format(
                    DateTime.now(),
                  ),
              orElse: () => PhotosModel(
                id: photos.length.toString(),
                date: DateTime.now().toString(),
                frontPic: '',
                sidePic: '',
              ),
            ),
      ),
    );
  }

  Future<void> _onPhotoAddedEvent(
      PhotoAddedEvent event, Emitter<PhotosState> emit) async {
    try {
      String? path;
      if (event.photoType == 'front') {
        // saving front image
        path = await photosRepo.takeAndSavePhoto(
          event.source,
          event.photoType,
        );

        // checking if the previously taken image is there if present deleting it
        if (state.todayPhoto.frontPic != '' && path != null) {
          await photosRepo.deleteImage(state.todayPhoto.frontPic);
        }
      } else {
        // saving side image
        path = await photosRepo.takeAndSavePhoto(
          event.source,
          event.photoType,
        );
        // checking if the previously taken image is there if present deleting it
        if (state.todayPhoto.sidePic != '' && path != null) {
          await photosRepo.deleteImage(state.todayPhoto.sidePic);
        }
      }

      if (path != null) {
        // saving in hive
        photosModelBox.put(
          // id (unique)
          state.todayPhoto.id,
          // photo
          state.todayPhoto.copyWith(
            frontPic: event.photoType == 'front' ? path : null,
            sidePic: event.photoType == 'side' ? path : null,
          ),
        );

        // changing state
        add(
          PhotosRequestedEvent(
            todayPhoto: state.todayPhoto.copyWith(
              frontPic: event.photoType == 'front' ? path : null,
              sidePic: event.photoType == 'side' ? path : null,
            ),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
