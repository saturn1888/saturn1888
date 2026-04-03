import 'package:hive/hive.dart';
import 'hunt_theme.dart';

part 'trophy.g.dart';

@HiveType(typeId: 3)
class Trophy extends HiveObject {
  @HiveField(0)
  String huntName;

  @HiveField(1)
  HuntThemeType themeType;

  @HiveField(2)
  DateTime completedAt;

  @HiveField(3)
  int timeTakenSeconds;

  @HiveField(4)
  int clueCount;

  Trophy({
    required this.huntName,
    required this.themeType,
    required this.completedAt,
    required this.timeTakenSeconds,
    required this.clueCount,
  });

  String get timeFormatted {
    final minutes = timeTakenSeconds ~/ 60;
    final seconds = timeTakenSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  HuntThemeData get theme => HuntThemeData.fromType(themeType);
}
