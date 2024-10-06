import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
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
    emit(
      state.copyWith(
        photos: List.generate(
            photosModelBox.length, (index) => photosModelBox.getAt(index)!),
        photosState: Status.success(),
      ),
    );
  }

  Future<void> _onPhotoAddedEvent(
      PhotoAddedEvent event, Emitter<PhotosState> emit) async {
    try {
      // try to save in gallary
      final path = await photosRepo.takeAndSavePhoto(
        event.source,
        event.photoType == 'front' ? 'Front Face' : 'Side Face',
      );

      if (path != null) {
        // saving in hive
        final int id;
        if (state.photos.isNotEmpty) {
          id = int.parse(state.photos.last.id) + 1;
        } else {
          id = 0;
        }
        final photoModel = PhotosModel(
          id: id.toString(),
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          frontPic: event.photoType == 'front' ? path : '',
          sidePic: event.photoType == 'front' ? '' : path,
        );

        photosModelBox.put(id, photoModel);

        // changing state
        add(const PhotosRequestedEvent());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
