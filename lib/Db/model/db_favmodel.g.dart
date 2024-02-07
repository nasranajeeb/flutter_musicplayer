// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_favmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavmodelAdapter extends TypeAdapter<Favmodel> {
  @override
  final int typeId = 2;

  @override
  Favmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favmodel(
      songIds: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Favmodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.songIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
