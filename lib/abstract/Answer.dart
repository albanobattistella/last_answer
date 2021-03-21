import 'package:hive/hive.dart';
import 'package:last_answer/abstract/HiveBoxes.dart';

part 'Answer.g.dart';

@HiveType(typeId: HiveBoxes.answerId)
class Answer extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String questionId;

  @HiveField(3)
  final String id;
  @HiveField(4)
  final DateTime created;

  Answer(
      {required this.title,
      required this.questionId,
      required this.id,
      required this.created});

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Answer && other.id == id;
}
