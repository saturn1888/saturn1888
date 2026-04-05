import 'package:hive/hive.dart';

part 'treasure_item.g.dart';

@HiveType(typeId: 4)
class TreasureItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? photoPath;

  @HiveField(2)
  int? assignedClueIndex;

  TreasureItem({
    required this.name,
    this.photoPath,
    this.assignedClueIndex,
  });
}
