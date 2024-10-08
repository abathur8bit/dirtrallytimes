// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 1;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      name: fields[0] as String,
      performanceClass: fields[1] as String,
      awd: fields[4] as bool,
      fwd: fields[2] as bool,
      rwd: fields[3] as bool,
      horsepower: fields[5] as int,
      weight: fields[6] as int,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.performanceClass)
      ..writeByte(2)
      ..write(obj.fwd)
      ..writeByte(3)
      ..write(obj.rwd)
      ..writeByte(4)
      ..write(obj.awd)
      ..writeByte(5)
      ..write(obj.horsepower)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
