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

  // Themed content
  final String foundItText;
  final String countdownPrefix;
  final String defaultVictoryMessage;
  final String introMessage;
  final List<String> decorativeEmojis;
  final String description;

  const HuntThemeData({
    required this.name,
    required this.emoji,
    required this.backgroundColor,
    required this.accentColor,
    required this.cardColor,
    required this.type,
    this.foundItText = 'I Found It! ✅',
    this.countdownPrefix = 'Starting in',
    this.defaultVictoryMessage = 'You did it! Amazing treasure hunters! 🎉',
    this.introMessage = 'Read each clue, find the answer, and tap when you find it!',
    this.decorativeEmojis = const ['⭐', '✨', '🎉'],
    this.description = 'A classic treasure hunt',
  });

  // Custom first, then the rest
  static const List<HuntThemeData> all = [
    HuntThemeData(
      name: 'Custom Hunt',
      emoji: '🎨',
      backgroundColor: Color(0xFF3E2E20),
      accentColor: Color(0xFFD4A04A),
      cardColor: Color(0xFF5C4030),
      type: HuntThemeType.custom,
      description: 'Design your own adventure with any style',
      decorativeEmojis: ['⭐', '✨', '🎯'],
    ),
    HuntThemeData(
      name: 'Pirate Treasure',
      emoji: '🏴‍☠️',
      backgroundColor: Color(0xFF1E3A5F),
      accentColor: Color(0xFFE8A817),
      cardColor: Color(0xFF2A4D72),
      type: HuntThemeType.pirate,
      foundItText: 'Treasure Found! 💰',
      countdownPrefix: 'Anchors away in',
      defaultVictoryMessage: 'Arr! Ye found all the treasure, ye scurvy dog! 🏴‍☠️💰',
      introMessage: 'Ahoy matey! Read each riddle to find the hidden treasure. X marks the spot!',
      decorativeEmojis: ['💰', '🗡️', '🦜', '⚓', '🏴‍☠️'],
      description: 'Sail the seas and find hidden treasure',
    ),
    HuntThemeData(
      name: 'Space Mission',
      emoji: '🚀',
      backgroundColor: Color(0xFF1A1F3A),
      accentColor: Color(0xFF82E0D6),
      cardColor: Color(0xFF2A2F50),
      type: HuntThemeType.space,
      foundItText: 'Mission Complete! 🛸',
      countdownPrefix: 'Launching in',
      defaultVictoryMessage: 'Houston, we have a winner! All missions complete! 🚀⭐',
      introMessage: 'Astronaut! Your mission: decode each clue and discover the hidden objects. Ground control is counting on you!',
      decorativeEmojis: ['⭐', '🌟', '🛸', '🪐', '🌙'],
      description: 'Explore the cosmos on a galactic quest',
    ),
    HuntThemeData(
      name: 'Jungle Explorer',
      emoji: '🌿',
      backgroundColor: Color(0xFF1A4D2E),
      accentColor: Color(0xFFA5D6A7),
      cardColor: Color(0xFF2A6040),
      type: HuntThemeType.jungle,
      foundItText: 'Discovery Made! 🦁',
      countdownPrefix: 'Expedition starts in',
      defaultVictoryMessage: 'What an explorer! You survived the jungle and found everything! 🌿🦁',
      introMessage: 'Explorer! Venture into the wild, follow the clues through the jungle, and uncover the hidden treasures!',
      decorativeEmojis: ['🦁', '🐒', '🦋', '🌺', '🌴'],
      description: 'Trek through the wild to find hidden wonders',
    ),
    HuntThemeData(
      name: 'Birthday Party',
      emoji: '🎂',
      backgroundColor: Color(0xFF6A1B4D),
      accentColor: Color(0xFFFFD180),
      cardColor: Color(0xFF822860),
      type: HuntThemeType.birthday,
      foundItText: 'Party Find! 🎁',
      countdownPrefix: 'Party starts in',
      defaultVictoryMessage: 'Happy birthday! You found all the party surprises! 🎂🎉🎁',
      introMessage: 'It\'s party time! Follow the clues to find all the birthday surprises hidden around!',
      decorativeEmojis: ['🎈', '🎁', '🎉', '🎊', '🍰'],
      description: 'A special birthday surprise adventure',
    ),
    HuntThemeData(
      name: 'Halloween Spooky',
      emoji: '🎃',
      backgroundColor: Color(0xFF2D1B0E),
      accentColor: Color(0xFFFFAB40),
      cardColor: Color(0xFF3D2818),
      type: HuntThemeType.halloween,
      foundItText: 'Spooky Find! 👻',
      countdownPrefix: 'The haunting begins in',
      defaultVictoryMessage: 'Boo! You braved the spooky hunt and found everything! 🎃👻',
      introMessage: 'Dare to enter... Follow the spooky clues if you\'re brave enough! Mwahaha!',
      decorativeEmojis: ['👻', '🕷️', '🦇', '💀', '🕸️'],
      description: 'A spooky adventure for the brave',
    ),
    HuntThemeData(
      name: 'Christmas Magic',
      emoji: '🎄',
      backgroundColor: Color(0xFF5C2020),
      accentColor: Color(0xFFA5D6A7),
      cardColor: Color(0xFF722828),
      type: HuntThemeType.christmas,
      foundItText: 'Ho Ho Found! 🎅',
      countdownPrefix: 'Santa says... go in',
      defaultVictoryMessage: 'Merry Christmas! You found all the presents! 🎄🎅⭐',
      introMessage: 'Santa needs your help! Follow the Christmas clues to find all the hidden presents!',
      decorativeEmojis: ['🎅', '⭐', '🦌', '❄️', '🎁'],
      description: 'Help Santa find the Christmas magic',
    ),
  ];

  static HuntThemeData fromType(HuntThemeType type) {
    return all.firstWhere((t) => t.type == type);
  }
}
