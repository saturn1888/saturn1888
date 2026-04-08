// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasure_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreasureItemAdapter extends TypeAdapter<TreasureItem> {
  @override
  final int typeId = 4;

  @override
  TreasureItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreasureItem(
      name: fields[0] as String,
      photoPath: fields[1] as String?,
      assignedClueIndex: fields[2] as int?,
      clues: fields.containsKey(3)
          ? (fields[3] as List?)?.cast<Clue>()
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, TreasureItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.photoPath)
      ..writeByte(2)
      ..write(obj.assignedClueIndex)
      ..writeByte(3)
      ..write(obj.clues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreasureItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
