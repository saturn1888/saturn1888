import 'package:hive/hive.dart';
import 'clue.dart';
import 'hunt_theme.dart';

part 'hunt.g.dart';

@HiveType(typeId: 2)
class Hunt extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  HuntThemeType themeType;

  @HiveField(3)
  List<Clue> clues;

  @HiveField(4)
  int? timerMinutes;

  @HiveField(5)
  String victoryMessage;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String? prizeDescription;

  @HiveField(8)
  String? prizePhotoPath;

  Hunt({
    required this.id,
    required this.name,
    required this.themeType,
    required this.clues,
    this.timerMinutes,
    this.victoryMessage = 'You did it! Amazing treasure hunters! 🎉',
    this.prizeDescription,
    this.prizePhotoPath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  HuntThemeData get theme => HuntThemeData.fromType(themeType);
}
