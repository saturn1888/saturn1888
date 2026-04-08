import 'package:hive/hive.dart';
import 'clue.dart';

part 'treasure_item.g.dart';

@HiveType(typeId: 4)
class TreasureItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? photoPath;

  @HiveField(2)
  int? assignedClueIndex; // legacy, kept for compat

  @HiveField(3)
  List<Clue> clues;

  TreasureItem({
    required this.name,
    this.photoPath,
    this.assignedClueIndex,
    List<Clue>? clues,
  }) : clues = clues ?? [];
}
