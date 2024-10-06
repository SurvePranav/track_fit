import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileOperationMethods {
  static Future<bool> requestStoragePermission() async {
    return await Permission.storage.request().isGranted;
  }

  static Future<void> saveFileToDownloads(File file) async {
    try {
      requestStoragePermission();
      // Get the Downloads directory path
      Directory? downloadsDirectory;

      // For Android
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        // For iOS, use the Documents directory
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (downloadsDirectory != null) {
        // Create the new file path
        String newPath = '${downloadsDirectory.path}/editor_state_history.json';

        // Move the file
        final newFile = await file.copy(newPath);

        log('File saved to: ${newFile.path}');
      } else {
        log('Could not access the Downloads directory.');
      }
    } catch (e) {
      log('Error saving file: $e');
    }
  }

  static Future<String> saveImageToDocuments({
    required Uint8List imageBytes,
    required String fileName,
    required String path,
  }) async {
    // Convert Uint8List to ui.Image
    ui.Image image = await decodeImageFromList(imageBytes);

    // Convert ui.Image to PNG format
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Get the app's documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String imagesDirectoryPath = '${documentsDirectory.path}/$path';

    // Create the directory if it doesn't exist
    Directory imagesDirectory = Directory(imagesDirectoryPath);
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    // Save PNG bytes to file
    String filePath = '$imagesDirectoryPath/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return filePath;
  }

  static Future<bool> deleteFileFromDocuments({
    required String filePath,
  }) async {
    try {
      log(filePath);
      // Create a File instance for the given path
      File file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        // Delete the file
        await file.delete();
        log('file deleted successfully');
        return true;
      } else {
        // File does not exist
        log('File does not exist');
        return false;
      }
    } catch (e) {
      // Handle any errors
      log('Error deleting file: $e');
      return false;
    }
  }

  static Future<String> copyImageToDocumentDirectory(
      String path, String fileName) async {
    try {
      final File imageFile = File(path);

      // Get the document directory
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String newPath =
          '${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Copy the image to the new path
      final File newImageFile = await imageFile.copy(newPath);
      // Return the path of the copied image
      return newImageFile.path;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  static Future<String?> captureAndSaveImage(GlobalKey globalKey) async {
    try {
      final boundary = globalKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;

      // Increase the pixel ratio for better quality (e.g., 2.0 for double the resolution)
      final image = await boundary.toImage(pixelRatio: 3.0);

      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final file = await File(
              '${dir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png')
          .create();
      await file.writeAsBytes(pngBytes);
      log(file.path);
      return file.path;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
