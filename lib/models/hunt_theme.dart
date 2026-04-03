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
      backgroundColor: Color(0xFF1B2838),
      accentColor: Color(0xFFFFD700),
      cardColor: Color(0xFF2A3F5F),
      type: HuntThemeType.pirate,
    ),
    HuntThemeData(
      name: 'Space Mission',
      emoji: '🚀',
      backgroundColor: Color(0xFF2D1B69),
      accentColor: Color(0xFF00E5FF),
      cardColor: Color(0xFF3D2B79),
      type: HuntThemeType.space,
    ),
    HuntThemeData(
      name: 'Jungle Explorer',
      emoji: '🌿',
      backgroundColor: Color(0xFF1B5E20),
      accentColor: Color(0xFFCDDC39),
      cardColor: Color(0xFF2E7D32),
      type: HuntThemeType.jungle,
    ),
    HuntThemeData(
      name: 'Birthday',
      emoji: '🎂',
      backgroundColor: Color(0xFFFF1493),
      accentColor: Color(0xFFFFEB3B),
      cardColor: Color(0xFFFF69B4),
      type: HuntThemeType.birthday,
    ),
    HuntThemeData(
      name: 'Halloween',
      emoji: '🎃',
      backgroundColor: Color(0xFF1A1A1A),
      accentColor: Color(0xFFFF6D00),
      cardColor: Color(0xFF2D2D2D),
      type: HuntThemeType.halloween,
    ),
    HuntThemeData(
      name: 'Christmas',
      emoji: '🎄',
      backgroundColor: Color(0xFFC62828),
      accentColor: Color(0xFF4CAF50),
      cardColor: Color(0xFFD32F2F),
      type: HuntThemeType.christmas,
    ),
  ];

  static HuntThemeData fromType(HuntThemeType type) {
    return all.firstWhere((t) => t.type == type);
  }
}
