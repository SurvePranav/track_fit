// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotosModelAdapter extends TypeAdapter<PhotosModel> {
  @override
  final int typeId = 0;

  @override
  PhotosModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotosModel(
      id: fields[0] as String,
      date: fields[1] as String,
      frontPic: fields[2] as String,
      sidePic: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhotosModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.frontPic)
      ..writeByte(3)
      ..write(obj.sidePic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotosModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
