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
      backgroundColor: Color(0xFF162030),
      accentColor: Color(0xFFE8A817),
      cardColor: Color(0xFF1E3050),
      type: HuntThemeType.pirate,
    ),
    HuntThemeData(
      name: 'Space Mission',
      emoji: '🚀',
      backgroundColor: Color(0xFF1A1040),
      accentColor: Color(0xFF64FFDA),
      cardColor: Color(0xFF2A1860),
      type: HuntThemeType.space,
    ),
    HuntThemeData(
      name: 'Jungle Explorer',
      emoji: '🌿',
      backgroundColor: Color(0xFF0D3B1E),
      accentColor: Color(0xFF8BC34A),
      cardColor: Color(0xFF1A5C30),
      type: HuntThemeType.jungle,
    ),
    HuntThemeData(
      name: 'Birthday',
      emoji: '🎂',
      backgroundColor: Color(0xFF880E4F),
      accentColor: Color(0xFFFFD54F),
      cardColor: Color(0xFFA01560),
      type: HuntThemeType.birthday,
    ),
    HuntThemeData(
      name: 'Halloween',
      emoji: '🎃',
      backgroundColor: Color(0xFF1A1005),
      accentColor: Color(0xFFFF8F00),
      cardColor: Color(0xFF2D1A08),
      type: HuntThemeType.halloween,
    ),
    HuntThemeData(
      name: 'Christmas',
      emoji: '🎄',
      backgroundColor: Color(0xFF7B1818),
      accentColor: Color(0xFF81C784),
      cardColor: Color(0xFF9B2020),
      type: HuntThemeType.christmas,
    ),
    HuntThemeData(
      name: 'Create Your Own',
      emoji: '🎨',
      backgroundColor: Color(0xFF3E2723),
      accentColor: Color(0xFFE8A817),
      cardColor: Color(0xFF5C3317),
      type: HuntThemeType.custom,
    ),
  ];

  static HuntThemeData fromType(HuntThemeType type) {
    return all.firstWhere((t) => t.type == type);
  }
}
