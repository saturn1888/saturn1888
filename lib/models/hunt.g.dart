// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HuntAdapter extends TypeAdapter<Hunt> {
  @override
  final int typeId = 2;

  @override
  Hunt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hunt(
      id: fields[0] as String,
      name: fields[1] as String,
      themeType: fields[2] as HuntThemeType,
      clues: (fields[3] as List).cast<Clue>(),
      timerMinutes: fields[4] as int?,
      victoryMessage: fields[5] as String,
      createdAt: fields[6] as DateTime,
      prizeDescription: fields[7] as String?,
      prizePhotoPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Hunt obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.themeType)
      ..writeByte(3)
      ..write(obj.clues)
      ..writeByte(4)
      ..write(obj.timerMinutes)
      ..writeByte(5)
      ..write(obj.victoryMessage)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.prizeDescription)
      ..writeByte(8)
      ..write(obj.prizePhotoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HuntAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
