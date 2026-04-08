// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClueAdapter extends TypeAdapter<Clue> {
  @override
  final int typeId = 1;

  @override
  Clue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Clue(
      text: fields[0] as String,
      photoPath: fields[1] as String?,
      wrongAnswerHint: fields[2] as String?,
      order: fields[3] as int,
      answer: fields.containsKey(4) ? fields[4] as String? : null,
      voicePath: fields.containsKey(5) ? fields[5] as String? : null,
    );
  }

  @override
  void write(BinaryWriter writer, Clue obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.photoPath)
      ..writeByte(2)
      ..write(obj.wrongAnswerHint)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.answer)
      ..writeByte(5)
      ..write(obj.voicePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
