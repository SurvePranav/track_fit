import 'package:hive/hive.dart';

part 'photos_adapter.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Use a unique typeId for each class
class PhotosModel {
  const PhotosModel({
    required this.id,
    required this.date,
    required this.frontPic,
    required this.sidePic,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String frontPic;

  @HiveField(3)
  final String sidePic;

  PhotosModel copyWith({
    String? id,
    String? date,
    String? frontPic,
    String? sidePic,
  }) {
    return PhotosModel(
      id: id ?? this.id,
      date: date ?? this.date,
      frontPic: frontPic ?? this.frontPic,
      sidePic: sidePic ?? this.sidePic,
    );
  }

  static const PhotosModel empty = PhotosModel(
    id: '',
    date: '',
    frontPic: '',
    sidePic: '',
  );
}

// @HiveType(typeId: 1) // Ensure this typeId is unique
// class ZinePage {
//   ZinePage({
//     this.sections = const [],
//   });

//   @HiveField(0)
//   List<Section> sections;

//   ZinePage copyWith({
//     List<Section>? sections,
//     int? pageNumber,
//   }) {
//     return ZinePage(
//       sections: sections ?? this.sections,
//     );
//   }
// }
