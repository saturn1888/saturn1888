// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunt_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HuntThemeTypeAdapter extends TypeAdapter<HuntThemeType> {
  @override
  final int typeId = 0;

  @override
  HuntThemeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HuntThemeType.pirate;
      case 1:
        return HuntThemeType.space;
      case 2:
        return HuntThemeType.jungle;
      case 3:
        return HuntThemeType.birthday;
      case 4:
        return HuntThemeType.halloween;
      case 5:
        return HuntThemeType.christmas;
      case 6:
        return HuntThemeType.custom;
      case 7:
        return HuntThemeType.outdoor;
      default:
        return HuntThemeType.pirate;
    }
  }

  @override
  void write(BinaryWriter writer, HuntThemeType obj) {
    switch (obj) {
      case HuntThemeType.pirate:
        writer.writeByte(0);
        break;
      case HuntThemeType.space:
        writer.writeByte(1);
        break;
      case HuntThemeType.jungle:
        writer.writeByte(2);
        break;
      case HuntThemeType.birthday:
        writer.writeByte(3);
        break;
      case HuntThemeType.halloween:
        writer.writeByte(4);
        break;
      case HuntThemeType.christmas:
        writer.writeByte(5);
        break;
      case HuntThemeType.custom:
        writer.writeByte(6);
        break;
      case HuntThemeType.outdoor:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HuntThemeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
