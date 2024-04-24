// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'racetime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RaceTimeAdapter extends TypeAdapter<RaceTime> {
  @override
  final int typeId = 2;

  @override
  RaceTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RaceTime(
      raceDate: fields[0] as DateTime,
      time: fields[1] as double,
      country: fields[2] as String,
      track: fields[3] as String,
      carName: fields[4] as String,
      isAutomatic: fields[5] as bool,
      steeringWheel: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RaceTime obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.raceDate)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.track)
      ..writeByte(4)
      ..write(obj.carName)
      ..writeByte(5)
      ..write(obj.isAutomatic)
      ..writeByte(6)
      ..write(obj.steeringWheel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RaceTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
