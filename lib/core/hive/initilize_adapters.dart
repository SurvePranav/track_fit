import 'package:hive_flutter/hive_flutter.dart';
import 'package:track_fit/core/hive/adapters/photos_adapter.dart';
import 'package:track_fit/core/hive/boxes.dart';

Future<void> initilizeHiveAdapters() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PhotosModelAdapter());

  photosModelBox = await Hive.openBox<PhotosModel>('ZineModelAdapterBox');
}
