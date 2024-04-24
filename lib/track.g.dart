// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final int typeId = 0;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      country: fields[0] as String,
      area: fields[1] as String,
      name: fields[2] as String,
      miles: fields[4] as double,
      killometers: fields[5] as double,
      isRallyCross: fields[3] as bool,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.country)
      ..writeByte(1)
      ..write(obj.area)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isRallyCross)
      ..writeByte(4)
      ..write(obj.miles)
      ..writeByte(5)
      ..write(obj.killometers)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
