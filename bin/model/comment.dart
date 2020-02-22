import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'comment.g.dart';

@HiveType(typeId: 0)
class Comment extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String text;
  @HiveField(2)
  String authorName;
  @HiveField(3)
  int state;
  @HiveField(4)
  String creationTime;
  @HiveField(5)
  HiveList<Comment> nestedComments;

  Comment(
      {@required this.id,
        @required this.authorName,
      @required this.text,
        @required this.creationTime,
      this.state = 0,

      this.nestedComments});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        authorName: json['authorName'] as String,
        text: json['text'] as String,
        creationTime: json['creationTime'] as String,
        state: json['state'] as int,
        nestedComments: (json['nestedComments'] as List)
            ?.map((e) =>
                e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
            ?.toList(),
      );

  Map<String, dynamic> toJson(Comment instance) => <String, dynamic>{
        'id': instance.id,
        'authorName': instance.authorName,
        'text': instance.text,
        'creationTime': instance.creationTime,
        'state': instance.state,
        'nestedComments': instance.nestedComments,
      };
}
