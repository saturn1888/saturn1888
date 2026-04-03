// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trophy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrophyAdapter extends TypeAdapter<Trophy> {
  @override
  final int typeId = 3;

  @override
  Trophy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trophy(
      huntName: fields[0] as String,
      themeType: fields[1] as HuntThemeType,
      completedAt: fields[2] as DateTime,
      timeTakenSeconds: fields[3] as int,
      clueCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Trophy obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.huntName)
      ..writeByte(1)
      ..write(obj.themeType)
      ..writeByte(2)
      ..write(obj.completedAt)
      ..writeByte(3)
      ..write(obj.timeTakenSeconds)
      ..writeByte(4)
      ..write(obj.clueCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrophyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
