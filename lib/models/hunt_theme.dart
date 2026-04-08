import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hunt_theme.g.dart';

@HiveType(typeId: 0)
enum HuntThemeType {
  @HiveField(0)
  pirate,
  @HiveField(1)
  space,
  @HiveField(2)
  jungle,
  @HiveField(3)
  birthday,
  @HiveField(4)
  halloween,
  @HiveField(5)
  christmas,
  @HiveField(6)
  custom,
}

class HuntThemeData {
  final String name;
  final String emoji;
  final Color backgroundColor;
  final Color accentColor;
  final Color cardColor;
  final HuntThemeType type;

  const HuntThemeData({
    required this.name,
    required this.emoji,
    required this.backgroundColor,
    required this.accentColor,
    required this.cardColor,
    required this.type,
  });

  static const List<HuntThemeData> all = [
    HuntThemeData(
      name: 'Pirate Treasure',
      emoji: '🏴‍☠️',
      backgroundColor: Color(0xFF1E3A5F),
      accentColor: Color(0xFFE8A817),
      cardColor: Color(0xFF2A4D72),
      type: HuntThemeType.pirate,
    ),
    HuntThemeData(
      name: 'Space Mission',
      emoji: '🚀',
      backgroundColor: Color(0xFF1A1F3A),
      accentColor: Color(0xFF82E0D6),
      cardColor: Color(0xFF2A2F50),
      type: HuntThemeType.space,
    ),
    HuntThemeData(
      name: 'Jungle Explorer',
      emoji: '🌿',
      backgroundColor: Color(0xFF1A4D2E),
      accentColor: Color(0xFFA5D6A7),
      cardColor: Color(0xFF2A6040),
      type: HuntThemeType.jungle,
    ),
    HuntThemeData(
      name: 'Birthday',
      emoji: '🎂',
      backgroundColor: Color(0xFF6A1B4D),
      accentColor: Color(0xFFFFD180),
      cardColor: Color(0xFF822860),
      type: HuntThemeType.birthday,
    ),
    HuntThemeData(
      name: 'Halloween',
      emoji: '🎃',
      backgroundColor: Color(0xFF2D1B0E),
      accentColor: Color(0xFFFFAB40),
      cardColor: Color(0xFF3D2818),
      type: HuntThemeType.halloween,
    ),
    HuntThemeData(
      name: 'Christmas',
      emoji: '🎄',
      backgroundColor: Color(0xFF5C2020),
      accentColor: Color(0xFFA5D6A7),
      cardColor: Color(0xFF722828),
      type: HuntThemeType.christmas,
    ),
    HuntThemeData(
      name: 'Create Your Own',
      emoji: '🎨',
      backgroundColor: Color(0xFF3E2E20),
      accentColor: Color(0xFFD4A04A),
      cardColor: Color(0xFF5C3317),
      type: HuntThemeType.custom,
    ),
  ];

  static HuntThemeData fromType(HuntThemeType type) {
    return all.firstWhere((t) => t.type == type);
  }
}
