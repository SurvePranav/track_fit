import 'package:hive/hive.dart';

part 'photos_adapter.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Use a unique typeId for each class
class PhotosModel {
  PhotosModel({
    required this.id,
    required this.date,
    required this.frontPic,
    required this.sidePic,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String frontPic;

  @HiveField(3)
  String sidePic;
  PhotosModel copyWith({
    String? id,
    String? date,
    String? frontPic,
    String? sidePic,
  }) {
    return PhotosModel(
      id: id ?? this.id,
      date: date ?? this.date,
      frontPic: frontPic ?? this.date,
      sidePic: sidePic ?? this.sidePic,
    );
  }
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
