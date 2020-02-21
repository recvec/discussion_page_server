import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 0)
class Comment extends HiveObject{
  @HiveField(0)
  String text;
  @HiveField(1)
  String authorName;
  @HiveField(2)
  int state;
  @HiveField(3)
  String creationTime;
@HiveField(4)
  HiveList<Comment> nestedComments;

}
