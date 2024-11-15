import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Future<void> _onPhotoAddedEvent(
  //     PhotoAddedEvent event, Emitter<PhotosState> emit) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //     // Check shared preferences for today's saved photo info
  //     final bool hasFrontPic = prefs.getBool('frontPic_$today') ?? false;
  //     final bool hasSidePic = prefs.getBool('sidePic_$today') ?? false;

  //     // Validate based on photo type
  //     if (event.photoType == 'front' && hasFrontPic) {
  //       log('Front-facing photo already exists for today.');
  //       return; // Or show a message to the user
  //     } else if (event.photoType == 'side' && hasSidePic) {
  //       log('Side-facing photo already exists for today.');
  //       return; // Or show a message to the user
  //     }

  //     // Try to save in gallery
  //     final path = await photosRepo.takeAndSavePhoto(
  //       event.source,
  //       event.photoType == 'front' ? 'Front Face' : 'Side Face',
  //     );

  //     if (path != null) {
  //       final int id;
  //       if (state.photos.isNotEmpty) {
  //         id = int.parse(state.photos.last.id) + 1;
  //       } else {
  //         id = 0;
  //       }

  //       // Create or update the photo model for today
  //       final PhotosModel photoModel = state.photos
  //               .any((photo) => photo.date == today)
  //           ? state.photos.firstWhere((photo) => photo.date == today).copyWith(
  //                 frontPic: event.photoType == 'front'
  //                     ? path
  //                     : state.photos
  //                         .firstWhere((photo) => photo.date == today)
  //                         .frontPic,
  //                 sidePic: event.photoType == 'side'
  //                     ? path
  //                     : state.photos
  //                         .firstWhere((photo) => photo.date == today)
  //                         .sidePic,
  //               )
  //           : PhotosModel(
  //               id: id.toString(),
  //               date: today,
  //               frontPic: event.photoType == 'front' ? path : '',
  //               sidePic: event.photoType == 'side' ? path : '',
  //             );

  //       // Save to Hive
  //       photosModelBox.put(id, photoModel);

  //       // Update shared preferences
  //       if (event.photoType == 'front') {
  //         await prefs.setBool('frontPic_$today', true);
  //       } else if (event.photoType == 'side') {
  //         await prefs.setBool('sidePic_$today', true);
  //       }

  //       // Update state
  //       add(const PhotosRequestedEvent());
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
}
