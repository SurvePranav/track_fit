import 'dart:developer';
import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class PhotosRepo {
  // Function to get external storage directory and create a folder
  Future<Directory?> getDirectory(String folderName) async {
    // Get external storage directory
    Directory? externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory != null) {
      String photoDirPath = path.join(externalDirectory.path, folderName);

      // Create the folder if it doesn't exist
      Directory photoDirectory = Directory(photoDirPath);
      if (!await photoDirectory.exists()) {
        await photoDirectory.create(recursive: true);
      }

      return photoDirectory;
    }
    return null;
  }

  // Function to take a photo and save it in the custom folder
  Future<String?> takeAndSavePhoto(String source, String folderName) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Get the directory path for "Daily Photos"
      final photoDirectory = await getDirectory(folderName);

      if (photoDirectory != null) {
        // Save the file with a unique name (using the current timestamp)
        String fileName = "photo_${DateTime.now().millisecondsSinceEpoch}.jpg";
        String filePath = path.join(photoDirectory.path, fileName);

        // Copy the picked image to the "Daily Photos" folder
        File photoFile = File(pickedFile.path);
        await photoFile.copy(filePath);

        // Save the image in the gallery
        await GallerySaver.saveImage(filePath, albumName: folderName);
        // returning file path
        return filePath;
      }
    }

    return null;
  }

  // Function to check if there's a photo for the current date
  Future<bool> isPhotoAlreadyTakenForToday() async {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Directory appDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDir.path}/_$currentDate.jpg';

    // Check if the file exists for today's date
    return File(filePath).exists();
  }
}
