// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habbit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabbitAdapter extends TypeAdapter<Habbit> {
  @override
  final int typeId = 0;

  @override
  Habbit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habbit(
      fields[0] as String,
      fields[1] as int,
      timespent: fields[2] as int,
      habbitStarted: fields[3] as bool,
      habbitCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Habbit obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.habbitName)
      ..writeByte(1)
      ..write(obj.timeGoal)
      ..writeByte(2)
      ..write(obj.timespent)
      ..writeByte(3)
      ..write(obj.habbitStarted)
      ..writeByte(4)
      ..write(obj.habbitCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabbitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
