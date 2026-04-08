import 'package:hive/hive.dart';

part 'clue.g.dart';

@HiveType(typeId: 1)
class Clue extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  String? photoPath;

  @HiveField(2)
  String? wrongAnswerHint;

  @HiveField(3)
  int order;

  @HiveField(4)
  String? answer;

  @HiveField(5)
  String? voicePath;

  Clue({
    required this.text,
    this.photoPath,
    this.wrongAnswerHint,
    this.order = 0,
    this.answer,
    this.voicePath,
  });

  Clue copyWith({
    String? text,
    String? photoPath,
    String? wrongAnswerHint,
    int? order,
    String? answer,
    bool clearPhoto = false,
  }) {
    return Clue(
      text: text ?? this.text,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      wrongAnswerHint: wrongAnswerHint ?? this.wrongAnswerHint,
      order: order ?? this.order,
      answer: answer ?? this.answer,
    );
  }
}
