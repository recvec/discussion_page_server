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
  @HiveField(6)
  bool isParent;
  Comment(
      {@required this.id,
        @required this.authorName,
      @required this.text,
        @required this.creationTime,
      this.state = 0,
        this.isParent=true,
      this.nestedComments});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        authorName: json['authorName'] as String,
        text: json['text'] as String,
        creationTime: json['creationTime'] as String,
    isParent: json['isParent'] as bool,
        state: json['state'] as int,
        nestedComments: (json['nestedComments'] as List)
            ?.map((e) =>
                e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
            ?.toList(),
      );

  Map<String, dynamic> toJson( ) => <String, dynamic>{
        'id': id,
        'authorName': authorName,
        'text': text,
        'creationTime': creationTime,
    'isParent': isParent,
        'state': state,
        'nestedComments': nestedComments,
      };
}
